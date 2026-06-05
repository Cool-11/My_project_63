#include "uart_vision.h"
#include "soc_osal.h"
#include "uart.h"
#include "pinctrl.h"
#include "cJSON.h"
#include "tcxo.h"
#include "cmsis_os2.h"
#include "../sle_network/sle_network.h"
#include <string.h>

static uint8_t g_uv_ring[UV_RING_SIZE];
static volatile uint16_t g_uv_ring_head = 0;
static volatile uint16_t g_uv_ring_tail = 0;
static volatile uint32_t g_uv_ring_drop_count = 0;
static volatile uint64_t g_uv_last_recv_ms = 0;

static uint8_t g_uv_rx_buf[UV_RING_SIZE];
static uart_buffer_config_t g_uv_buffer_cfg = {
    .rx_buffer = g_uv_rx_buf,
    .rx_buffer_size = sizeof(g_uv_rx_buf)
};

static uv_cmd_handler_t g_uv_cmd_handler = NULL;

static uint16_t uv_ring_count(void)
{
    uint16_t head = g_uv_ring_head;
    uint16_t tail = g_uv_ring_tail;
    return (head >= tail) ? (head - tail) : (UV_RING_SIZE - tail + head);
}

static void uv_ring_push(const uint8_t *data, uint16_t len)
{
    for (uint16_t i = 0; i < len; i++) {
        uint16_t next = (g_uv_ring_head + 1) % UV_RING_SIZE;
        if (next == g_uv_ring_tail) {
            g_uv_ring_drop_count++;
            break;
        }
        g_uv_ring[g_uv_ring_head] = data[i];
        g_uv_ring_head = next;
    }
}

static bool uv_ring_has_newline(void)
{
    uint16_t i = g_uv_ring_tail;
    uint16_t dist = 0;
    while (i != g_uv_ring_head) {
        if ((g_uv_ring[i] == '\n' || g_uv_ring[i] == '\r') && dist < UV_LINE_MAX) {
            return true;
        }
        i = (i + 1) % UV_RING_SIZE;
        dist++;
    }
    return false;
}

static uint16_t uv_ring_read_line(uint8_t *out, uint16_t max_len)
{
    uint16_t count = 0;
    while (g_uv_ring_tail != g_uv_ring_head && count < max_len - 1) {
        uint8_t ch = g_uv_ring[g_uv_ring_tail];
        g_uv_ring_tail = (g_uv_ring_tail + 1) % UV_RING_SIZE;
        if (ch == '\n' || ch == '\r') {
            if (ch == '\r') {
                if (g_uv_ring_tail != g_uv_ring_head &&
                    g_uv_ring[g_uv_ring_tail] == '\n') {
                    g_uv_ring_tail = (g_uv_ring_tail + 1) % UV_RING_SIZE;
                }
            }
            out[count] = '\0';
            return count;
        }
        out[count++] = ch;
    }
    if (count >= max_len - 1) {
        while (g_uv_ring_tail != g_uv_ring_head) {
            uint8_t ch = g_uv_ring[g_uv_ring_tail];
            g_uv_ring_tail = (g_uv_ring_tail + 1) % UV_RING_SIZE;
            if (ch == '\n' || ch == '\r') {
                break;
            }
        }
    }
    out[count] = '\0';
    return count;
}

static void uv_uart_rx_cb(const void *buffer, uint16_t length, bool error)
{
    if (error || buffer == NULL || length == 0) {
        return;
    }
    g_uv_last_recv_ms = uapi_tcxo_get_ms();
    uv_ring_push((const uint8_t *)buffer, length);

    /* 通知主循环处理接收数据 */
    extern osEventFlagsId_t g_my63_events;
    if (g_my63_events != NULL) {
        (void)osEventFlagsSet(g_my63_events, EVENT_UART1_RX);
    }
}

static void uv_uart_init_pin(void)
{
    uapi_pin_set_mode(UV_UART_TX_PIN, (pin_mode_t)UV_UART_TX_PIN_MODE);
    uapi_pin_set_mode(UV_UART_RX_PIN, (pin_mode_t)UV_UART_RX_PIN_MODE);

    /* SDK 的 uart_port_config_pinmux 在非 ASIC 板上未配置 UART1 信号路由，
     * 导致 GPIO15/16 未连接到 UART1 外设。手动写入 SoC 寄存器补上。 */
    (*(volatile uint32_t *)0x4400d03c) = 1;  /* UART1_TXD_SEL: GPIO15 → UART1 TX */
    (*(volatile uint32_t *)0x4400d040) = 1;  /* UART1_RXD_SEL: GPIO16 → UART1 RX */

    osal_printk("[WS63_UART] pin set tx=%d mode=%d rx=%d mode=%d + UART1 signal routing\r\n",
        UV_UART_TX_PIN, UV_UART_TX_PIN_MODE, UV_UART_RX_PIN, UV_UART_RX_PIN_MODE);
}

static int uv_uart_init_config(void)
{
    uart_attr_t attr = {
        .baud_rate = UV_UART_BAUDRATE,
        .data_bits = UART_DATA_BIT_8,
        .stop_bits = UART_STOP_BIT_1,
        .parity = UART_PARITY_NONE
    };
    uart_pin_config_t pin_cfg = {
        .tx_pin = UV_UART_TX_PIN,
        .rx_pin = UV_UART_RX_PIN,
        .cts_pin = PIN_NONE,
        .rts_pin = PIN_NONE
    };
    errcode_t ret = uapi_uart_deinit(UV_UART_BUS);
    if (ret != ERRCODE_SUCC) {
        osal_printk("[WS63_UART] deinit ret=0x%x (may be first init)\r\n", ret);
    }

    ret = uapi_uart_init(UV_UART_BUS, &pin_cfg, &attr, NULL, &g_uv_buffer_cfg);
    if (ret != ERRCODE_SUCC) {
        osal_printk("[WS63_UART] init failed ret=0x%x\r\n", ret);
        return (int)ret;
    }
    osal_printk("[WS63_UART] init ok bus=%u baud=%u tx=%d rx=%d\r\n",
        UV_UART_BUS, UV_UART_BAUDRATE, UV_UART_TX_PIN, UV_UART_RX_PIN);
    return 0;
}

static int uv_uart_register_rx(void)
{
    errcode_t ret = uapi_uart_register_rx_callback(UV_UART_BUS,
        UART_RX_CONDITION_FULL_OR_SUFFICIENT_DATA_OR_IDLE, 1, uv_uart_rx_cb);
    if (ret != ERRCODE_SUCC) {
        osal_printk("[WS63_UART] register rx cb failed ret=0x%x\r\n", ret);
        return (int)ret;
    }
    osal_printk("[WS63_UART] register rx cb ok\r\n");
    return 0;
}

void uart_vision_register_cmd_handler(uv_cmd_handler_t handler)
{
    g_uv_cmd_handler = handler;
    osal_printk("[WS63_UART] cmd handler registered=%p\r\n", (void *)handler);
}

static void uv_dispatch_line(const char *line, uint16_t len)
{
    cJSON *root = cJSON_Parse(line);
    if (root == NULL) {
        osal_printk("[WS63_UART] json parse fail len=%u\r\n", (unsigned int)len);
        return;
    }

    cJSON *j_type = cJSON_GetObjectItem(root, UV_TYPE_FIELD);
    cJSON *j_cmd  = cJSON_GetObjectItem(root, UV_CMD_FIELD);
    cJSON *j_code = cJSON_GetObjectItem(root, UV_CODE_FIELD);
    cJSON *j_seq  = cJSON_GetObjectItem(root, UV_SEQ_FIELD);

    /* ESP32 上行消息用 "type" 字段；WS63 自身命令/响应用 "cmd" 字段。
     * UART 回环会导致 WS63 发出的帧从 RX 收到 → 只分发 ESP32 来源的 "type" 消息 */
    if (j_type != NULL && cJSON_IsString(j_type)) {
        j_cmd = j_type;
    } else if (j_code != NULL && cJSON_IsNumber(j_code)) {
        /* WS63 响应回环（有 code 字段），丢弃 */
        cJSON_Delete(root);
        return;
    } else {
        /* WS63 命令回环（仅有 cmd 字段，无 type 无 code），丢弃 */
        cJSON_Delete(root);
        return;
    }
    if (j_cmd == NULL || !cJSON_IsString(j_cmd)) {
        osal_printk("[WS63_UART] missing cmd/type field\r\n");
        cJSON_Delete(root);
        return;
    }

    int raw_seq = (j_seq != NULL && cJSON_IsNumber(j_seq)) ? j_seq->valueint : 0;
    uint16_t seq = (raw_seq >= 0 && raw_seq <= 0xFFFF) ? (uint16_t)raw_seq : 0;
    const char *cmd = j_cmd->valuestring;
    /* ESP32 扁平 JSON 无 data 字段，传完整 root 供 biz_handle_esp32_msg 解析 */
    char *data_str = cJSON_PrintUnformatted(root);

    osal_printk("[WS63_UART] recv ESP32 msg type=%s seq=%u\r\n", cmd, (unsigned int)seq);

    if (g_uv_cmd_handler != NULL) {
        g_uv_cmd_handler(cmd, seq, data_str);
    } else {
        osal_printk("[WS63_UART] no cmd handler registered\r\n");
    }

    if (data_str != NULL) {
        cJSON_free(data_str);
    }
    cJSON_Delete(root);
}

static void uv_check_timeout(void)
{
    if (g_uv_last_recv_ms == 0 || g_uv_ring_head == g_uv_ring_tail) {
        return;
    }
    uint64_t now = uapi_tcxo_get_ms();
    if (now - g_uv_last_recv_ms >= UV_LINE_TIMEOUT_MS) {
        if (!uv_ring_has_newline() && g_uv_ring_head != g_uv_ring_tail) {
            uint16_t drop_len = uv_ring_count();
            g_uv_ring_tail = g_uv_ring_head;
            osal_printk("[WS63_UART] timeout drop partial line len=%u\r\n",
                (unsigned int)drop_len);
        }
    }
}

static void uv_process_ring(void)
{
    static uint8_t line_buf[UV_LINE_MAX];

    /* 缓冲区快满且无换行 → 浮空噪音，全部丢弃 */
    if (uv_ring_count() > (UV_RING_SIZE * 3 / 4) && !uv_ring_has_newline()) {
        g_uv_ring_tail = g_uv_ring_head;
        return;
    }

    uv_check_timeout();
    while (uv_ring_has_newline()) {
        uint16_t line_len = uv_ring_read_line(line_buf, sizeof(line_buf));
        if (line_len == 0) {
            continue;
        }
        if (line_len >= UV_LINE_MAX - 1) {
            osal_printk("[WS63_UART] line too long drop len=%u\r\n", (unsigned int)line_len);
            continue;
        }
        uv_dispatch_line((const char *)line_buf, line_len);
    }
    if (g_uv_ring_drop_count > 0) {
        osal_printk("[WS63_UART] ring drop count=%u used=%u/%u\r\n",
            (unsigned int)g_uv_ring_drop_count,
            (unsigned int)uv_ring_count(), (unsigned int)UV_RING_SIZE);
        g_uv_ring_drop_count = 0;
    }
}

int uart_vision_send_json(uint16_t seq, const char *cmd, int code, const char *msg,
    const char *data_json)
{
    if (cmd == NULL) {
        osal_printk("[WS63_UART] send_json null cmd\r\n");
        return -1;
    }

    cJSON *root = cJSON_CreateObject();
    if (root == NULL) {
        osal_printk("[WS63_UART] send_json create obj fail\r\n");
        return -1;
    }

    cJSON_AddStringToObject(root, UV_CMD_FIELD, cmd);
    cJSON_AddNumberToObject(root, UV_SEQ_FIELD, seq);
    cJSON_AddNumberToObject(root, UV_CODE_FIELD, code);
    if (msg != NULL) {
        cJSON_AddStringToObject(root, UV_MSG_FIELD, msg);
    }
    if (data_json != NULL) {
        cJSON *data_obj = cJSON_Parse(data_json);
        if (data_obj != NULL) {
            cJSON_AddItemToObject(root, UV_DATA_FIELD, data_obj);
        }
    }

    char *out = cJSON_PrintUnformatted(root);
    cJSON_Delete(root);
    if (out == NULL) {
        osal_printk("[WS63_UART] send_json print fail\r\n");
        return -1;
    }

    uint32_t out_len = (uint32_t)strlen(out);
    int32_t written = uapi_uart_write(UV_UART_BUS, (const uint8_t *)out, out_len, 0);
    if (written != (int32_t)out_len) {
        osal_printk("[WS63_UART] send_json partial: wrote=%d expected=%u\r\n",
            (int)written, (unsigned int)out_len);
        if (written > 0) {
            uapi_uart_write(UV_UART_BUS, (const uint8_t *)"\r\n", 2, 0);
        }
        cJSON_free(out);
        return (written < 0) ? (int)written : -1;
    }

    uapi_uart_write(UV_UART_BUS, (const uint8_t *)"\r\n", 2, 0);
    cJSON_free(out);

    osal_printk("[WS63_UART] send cmd=%s seq=%u code=%d len=%u\r\n",
        cmd, (unsigned int)seq, code, (unsigned int)out_len);
    return 0;
}

int uart_vision_send_raw_json(const char *json_str)
{
    if (json_str == NULL) {
        return -1;
    }

    uint32_t len = (uint32_t)strlen(json_str);
    int32_t written = uapi_uart_write(UV_UART_BUS, (const uint8_t *)json_str, len, 0);
    if (written != (int32_t)len) {
        osal_printk("[WS63_UART] raw send partial: wrote=%d expected=%u\r\n",
            (int)written, (unsigned int)len);
        if (written > 0) {
            uapi_uart_write(UV_UART_BUS, (const uint8_t *)"\r\n", 2, 0);
        }
        return (written < 0) ? (int)written : -1;
    }

    uapi_uart_write(UV_UART_BUS, (const uint8_t *)"\r\n", 2, 0);
    osal_printk("[WS63_UART] raw send len=%u\r\n", (unsigned int)len);
    return 0;
}

uint16_t uart_vision_ring_usage(void)
{
    return uv_ring_count();
}

int uart_vision_init(void)
{
    osal_printk("[WS63_UART] init start\r\n");

    uv_uart_init_pin();

    int ret = uv_uart_init_config();
    if (ret != 0) {
        return ret;
    }

    ret = uv_uart_register_rx();
    if (ret != 0) {
        return ret;
    }

    osal_printk("[WS63_UART] init done bus=%u tx=%d rx=%d baud=%u\r\n",
        UV_UART_BUS, UV_UART_TX_PIN, UV_UART_RX_PIN, UV_UART_BAUDRATE);
    return 0;
}

void uart_vision_poll(void)
{
    uv_process_ring();
}

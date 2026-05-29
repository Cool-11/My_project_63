#include "uart_display.h"
#include "soc_osal.h"
#include "uart.h"
#include "pinctrl.h"
#include "tcxo.h"
#include <string.h>
#include <stdarg.h>
#include <stdio.h>

/* ========== 环形缓冲区 ========== */
static uint8_t g_ud_ring[UD_RING_SIZE];
static volatile uint16_t g_ud_ring_head = 0;
static volatile uint16_t g_ud_ring_tail = 0;
static volatile uint32_t g_ud_ring_drop_count = 0;
static volatile uint64_t g_ud_last_recv_ms = 0;

/* UART DMA 接收缓冲区 */
static uint8_t g_ud_rx_buf[UD_RING_SIZE];
static uart_buffer_config_t g_ud_buffer_cfg = {
    .rx_buffer = g_ud_rx_buf,
    .rx_buffer_size = sizeof(g_ud_rx_buf)
};

/* 命令回调 */
static ud_cmd_handler_t g_ud_cmd_handler = NULL;

/* 发送缓冲区（下行帧组装） */
static char g_ud_tx_buf[UD_LINE_MAX];

/* ========== 环形缓冲区操作 ========== */

static uint16_t ud_ring_count(void)
{
    uint16_t head = g_ud_ring_head;
    uint16_t tail = g_ud_ring_tail;
    return (head >= tail) ? (head - tail) : (UD_RING_SIZE - tail + head);
}

static void ud_ring_push(const uint8_t *data, uint16_t len)
{
    for (uint16_t i = 0; i < len; i++) {
        uint16_t next = (g_ud_ring_head + 1) % UD_RING_SIZE;
        if (next == g_ud_ring_tail) {
            g_ud_ring_drop_count++;
            break;
        }
        g_ud_ring[g_ud_ring_head] = data[i];
        g_ud_ring_head = next;
    }
}

static bool ud_ring_has_newline(void)
{
    uint16_t i = g_ud_ring_tail;
    uint16_t dist = 0;
    while (i != g_ud_ring_head) {
        if (g_ud_ring[i] == '\n' && dist < UD_LINE_MAX) {
            return true;
        }
        i = (i + 1) % UD_RING_SIZE;
        dist++;
    }
    return false;
}

static uint16_t ud_ring_read_line(uint8_t *out, uint16_t max_len)
{
    uint16_t count = 0;
    while (g_ud_ring_tail != g_ud_ring_head && count < max_len - 1) {
        uint8_t ch = g_ud_ring[g_ud_ring_tail];
        g_ud_ring_tail = (g_ud_ring_tail + 1) % UD_RING_SIZE;
        if (ch == '\n' || ch == '\r') {
            /* 跳过 \r\n 组合 */
            if (ch == '\r' && g_ud_ring_tail != g_ud_ring_head &&
                g_ud_ring[g_ud_ring_tail] == '\n') {
                g_ud_ring_tail = (g_ud_ring_tail + 1) % UD_RING_SIZE;
            }
            out[count] = '\0';
            return count;
        }
        out[count++] = ch;
    }
    /* 缓冲区满或没有换行 */
    if (count >= max_len - 1) {
        while (g_ud_ring_tail != g_ud_ring_head) {
            uint8_t ch = g_ud_ring[g_ud_ring_tail];
            g_ud_ring_tail = (g_ud_ring_tail + 1) % UD_RING_SIZE;
            if (ch == '\n' || ch == '\r') {
                break;
            }
        }
    }
    out[count] = '\0';
    return count;
}

/* ========== UART 硬件初始化 ========== */

static void ud_uart_rx_cb(const void *buffer, uint16_t length, bool error)
{
    if (error || buffer == NULL || length == 0) {
        return;
    }
    g_ud_last_recv_ms = uapi_tcxo_get_ms();
    ud_ring_push((const uint8_t *)buffer, length);
}

static void ud_uart_init_pin(void)
{
    uapi_pin_set_mode(UD_UART_TX_PIN, (pin_mode_t)UD_UART_TX_PIN_MODE);
    uapi_pin_set_mode(UD_UART_RX_PIN, (pin_mode_t)UD_UART_RX_PIN_MODE);
}

static int ud_uart_init_config(void)
{
    uart_attr_t attr = {
        .baud_rate = UD_UART_BAUDRATE,
        .data_bits = UART_DATA_BIT_8,
        .stop_bits = UART_STOP_BIT_1,
        .parity = UART_PARITY_NONE
    };
    uart_pin_config_t pin_cfg = {
        .tx_pin = UD_UART_TX_PIN,
        .rx_pin = UD_UART_RX_PIN,
        .cts_pin = PIN_NONE,
        .rts_pin = PIN_NONE
    };
    errcode_t ret = uapi_uart_deinit(UD_UART_BUS);
    if (ret != ERRCODE_SUCC) {
        osal_printk("[WS63_DISP] deinit ret=0x%x (may be first init)\r\n", ret);
    }

    ret = uapi_uart_init(UD_UART_BUS, &pin_cfg, &attr, NULL, &g_ud_buffer_cfg);
    if (ret != ERRCODE_SUCC) {
        osal_printk("[WS63_DISP] init failed ret=0x%x\r\n", ret);
        return (int)ret;
    }
    osal_printk("[WS63_DISP] init ok bus=%u baud=%u tx=%d rx=%d\r\n",
        UD_UART_BUS, UD_UART_BAUDRATE, UD_UART_TX_PIN, UD_UART_RX_PIN);
    return 0;
}

static int ud_uart_register_rx(void)
{
    errcode_t ret = uapi_uart_register_rx_callback(UD_UART_BUS,
        UART_RX_CONDITION_FULL_OR_SUFFICIENT_DATA_OR_IDLE, 1, ud_uart_rx_cb);
    if (ret != ERRCODE_SUCC) {
        osal_printk("[WS63_DISP] register rx cb failed ret=0x%x\r\n", ret);
        return (int)ret;
    }
    osal_printk("[WS63_DISP] register rx cb ok\r\n");
    return 0;
}

/* ========== Tag ID 格式转换 ========== */

/* "0005" → uint16_t 5 */
int ud_str_to_tag_id(const char *str, uint16_t *out_id)
{
    if (str == NULL || out_id == NULL) {
        return -1;
    }
    /* 跳过前导空格 */
    while (*str == ' ') {
        str++;
    }
    /* 必须是纯数字 */
    if (*str < '0' || *str > '9') {
        return -2;
    }
    uint16_t val = 0;
    const char *p = str;
    while (*p >= '0' && *p <= '9') {
        val = (uint16_t)(val * 10 + (uint16_t)(*p - '0'));
        p++;
    }
    *out_id = val;
    return 0;
}

/* uint16_t 5 → "0005" */
int ud_tag_id_to_str(uint16_t id, char *buf, uint16_t buf_len)
{
    if (buf == NULL || buf_len < 5) {
        return -1;
    }
    int ret = snprintf(buf, buf_len, "%04u", (unsigned int)id);
    return (ret > 0 && ret < (int)buf_len) ? 0 : -1;
}

/* ========== CSV 帧解析（上行） ========== */

/* 从一行文本中解析 @cmd,param1,param2,... 格式 */
static void ud_dispatch_line(const char *line, uint16_t len)
{
    if (line == NULL || len < 2) {
        return;
    }

    /* 必须以 @ 开头（上行帧） */
    if (line[0] != UD_DIR_UP) {
        osal_printk("[WS63_DISP] skip non-uplink frame: %.16s\r\n", line);
        return;
    }

    /* 跳过 @ */
    const char *body = line + 1;

    /* 查找第一个逗号，分离 cmd 和 params */
    const char *comma = strchr(body, ',');
    char cmd[32] = {0};
    const char *params = "";

    if (comma != NULL) {
        /* cmd = body 到 comma 之间 */
        uint16_t cmd_len = (uint16_t)(comma - body);
        if (cmd_len >= sizeof(cmd)) {
            cmd_len = sizeof(cmd) - 1;
        }
        (void)memcpy_s(cmd, sizeof(cmd), body, cmd_len);
        params = comma + 1;  /* 逗号之后都是参数 */
    } else {
        /* 无逗号，整行就是 cmd */
        uint16_t cmd_len = len - 1;  /* 减去 @ */
        if (cmd_len >= sizeof(cmd)) {
            cmd_len = sizeof(cmd) - 1;
        }
        (void)memcpy_s(cmd, sizeof(cmd), body, cmd_len);
    }

    osal_printk("[WS63_DISP] recv cmd=%s params=%s\r\n", cmd, params);

    if (g_ud_cmd_handler != NULL) {
        g_ud_cmd_handler(cmd, params);
    } else {
        osal_printk("[WS63_DISP] no cmd handler registered\r\n");
    }
}

/* 超时检查：丢弃不完整的行 */
static void ud_check_timeout(void)
{
    if (g_ud_last_recv_ms == 0 || g_ud_ring_head == g_ud_ring_tail) {
        return;
    }
    uint64_t now = uapi_tcxo_get_ms();
    if (now - g_ud_last_recv_ms >= UD_LINE_TIMEOUT_MS) {
        if (!ud_ring_has_newline() && g_ud_ring_head != g_ud_ring_tail) {
            uint16_t drop_len = ud_ring_count();
            g_ud_ring_tail = g_ud_ring_head;
            osal_printk("[WS63_DISP] timeout drop partial line len=%u\r\n",
                (unsigned int)drop_len);
        }
    }
}

/* ========== 公共 API ========== */

void uart_display_register_cmd_handler(ud_cmd_handler_t handler)
{
    g_ud_cmd_handler = handler;
    osal_printk("[WS63_DISP] cmd handler registered=%p\r\n", (void *)handler);
}

int uart_display_init(void)
{
    g_ud_ring_head = 0;
    g_ud_ring_tail = 0;
    g_ud_ring_drop_count = 0;
    g_ud_last_recv_ms = 0;

    ud_uart_init_pin();
    int ret = ud_uart_init_config();
    if (ret != 0) {
        return ret;
    }
    ret = ud_uart_register_rx();
    if (ret != 0) {
        return ret;
    }
    osal_printk("[WS63_DISP] module init done\r\n");
    return 0;
}

/* 主循环调用：处理环形缓冲区中的所有完整行 */
void uart_display_poll(void)
{
    static uint8_t line_buf[UD_LINE_MAX];

    ud_check_timeout();
    while (ud_ring_has_newline()) {
        uint16_t line_len = ud_ring_read_line(line_buf, sizeof(line_buf));
        if (line_len == 0) {
            continue;
        }
        ud_dispatch_line((const char *)line_buf, line_len);
    }
}

/* 下行帧发送：#cmd,param1,param2,...\r\n */
int uart_display_send(const char *cmd, const char *fmt, ...)
{
    if (cmd == NULL) {
        return -1;
    }

    int pos = snprintf(g_ud_tx_buf, sizeof(g_ud_tx_buf), "%c%s", UD_DIR_DOWN, cmd);
    if (pos < 0 || pos >= (int)sizeof(g_ud_tx_buf)) {
        return -2;
    }

    /* 如果有参数，追加逗号和参数 */
    if (fmt != NULL && fmt[0] != '\0') {
        g_ud_tx_buf[pos++] = ',';
        va_list ap;
        va_start(ap, fmt);
        int n = vsnprintf(&g_ud_tx_buf[pos], sizeof(g_ud_tx_buf) - (uint16_t)pos, fmt, ap);
        va_end(ap);
        if (n < 0 || (uint16_t)(pos + n) >= sizeof(g_ud_tx_buf)) {
            return -3;
        }
        pos += n;
    }

    /* 追加 \r\n */
    if ((uint16_t)(pos + 2) >= sizeof(g_ud_tx_buf)) {
        return -4;
    }
    g_ud_tx_buf[pos++] = '\r';
    g_ud_tx_buf[pos++] = '\n';

    int32_t written = uapi_uart_write(UD_UART_BUS, (const uint8_t *)g_ud_tx_buf, (uint16_t)pos, 0);
    if (written != pos) {
        osal_printk("[WS63_DISP] send short write %d/%d\r\n", (int)written, pos);
        return -5;
    }
    return 0;
}

uint16_t uart_display_ring_usage(void)
{
    return ud_ring_count();
}

#ifndef MY63_UART_DISPLAY_H
#define MY63_UART_DISPLAY_H

#include <stdint.h>
#include <stdbool.h>

#ifdef __cplusplus
extern "C" {
#endif

/* ========== 硬件配置 ========== */
#define UD_UART_BUS         2
#define UD_UART_BAUDRATE    115200
#define UD_UART_TX_PIN      8       /* GPIO8 复用模式2 = UART2_TXD */
#define UD_UART_RX_PIN      7       /* GPIO7 复用模式2 = UART2_RXD */
#define UD_UART_TX_PIN_MODE 2
#define UD_UART_RX_PIN_MODE 2

/* ========== 缓冲区配置 ========== */
#define UD_RING_SIZE        1024    /* 环形缓冲区大小 */
#define UD_LINE_MAX         256     /* 单行最大长度 */
#define UD_LINE_TIMEOUT_MS  100     /* 行超时（ms） */

/* ========== 帧方向标识 ========== */
#define UD_DIR_UP           '@'     /* 屏→WS63 上行帧 */
#define UD_DIR_DOWN         '#'     /* WS63→屏 下行帧 */

/* ========== 回调类型 ========== */
/* cmd: 命令名(如"in","out","inv","find","back")
 * params: 参数字符串(如"0005","all","zone,A1")，已去除@头和\r\n尾 */
typedef void (*ud_cmd_handler_t)(const char *cmd, const char *params);

/* ========== 模块 API ========== */
int uart_display_init(void);
void uart_display_poll(void);
int uart_display_send(const char *cmd, const char *fmt, ...);
void uart_display_register_cmd_handler(ud_cmd_handler_t handler);
uint16_t uart_display_ring_usage(void);

/* ========== Tag ID 格式转换工具 ========== */
int ud_str_to_tag_id(const char *str, uint16_t *out_id);
int ud_tag_id_to_str(uint16_t id, char *buf, uint16_t buf_len);

#ifdef __cplusplus
}
#endif

#endif

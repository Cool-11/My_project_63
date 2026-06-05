#ifndef MY63_UART_VISION_H
#define MY63_UART_VISION_H

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#define UV_UART_BUS         1
#define UV_UART_BAUDRATE    115200
#define UV_UART_TX_PIN      15
#define UV_UART_RX_PIN      16
#define UV_UART_TX_PIN_MODE 1
#define UV_UART_RX_PIN_MODE 1
#define UV_RING_SIZE        8192
#define UV_LINE_MAX         512
#define UV_LINE_TIMEOUT_MS  100
#define UV_SEQ_FIELD        "seq"
#define UV_CMD_FIELD        "cmd"
#define UV_TYPE_FIELD       "type"
#define UV_DATA_FIELD       "data"
#define UV_CODE_FIELD       "code"
#define UV_MSG_FIELD        "msg"

typedef void (*uv_cmd_handler_t)(const char *cmd, uint16_t seq, const char *data_json);

int uart_vision_init(void);
int uart_vision_send_json(uint16_t seq, const char *cmd, int code, const char *msg,
    const char *data_json);
int uart_vision_send_raw_json(const char *json_str);
void uart_vision_register_cmd_handler(uv_cmd_handler_t handler);
void uart_vision_poll(void);
uint16_t uart_vision_ring_usage(void);

#ifdef __cplusplus
}
#endif

#endif

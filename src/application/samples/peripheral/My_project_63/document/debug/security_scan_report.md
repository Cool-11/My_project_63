# Security Scan Report -- WS63 Smart Warehouse Gateway

**Scan Date:** 2026-05-15
**Scope:** C/embedded security review of modified files
**Platform:** WS63 (LiteOS, Cortex-M33, static buffers, no heap allocator)
**Files Scanned:**
- `components/business_logic/business_logic.c`
- `components/business_logic/business_logic.h`
- `components/uart_vision/uart_vision.c`
- `components/uart_vision/uart_vision.h`
- `components/shared_protocol/shared_protocol.h` (+ `.c`)

---

## Summary

| Severity | Count |
|----------|-------|
| Critical | 0     |
| High     | 2     |
| Medium   | 5     |
| Low      | 2     |
| Info     | 2     |

---

## High

### H-01: Format String Injection via User-Controlled MQTT Host

**File:** `business_logic.c:591`
**Category:** Buffer Overflow / Injection

```c
} else if (j_host != NULL && cJSON_IsString(j_host)) {
    cJSON *j_port = cJSON_GetObjectItem(root, "port");
    int port = (j_port != NULL && cJSON_IsNumber(j_port)) ?
        j_port->valueint : 1883;
    snprintf(params.uri, BIZ_MQTT_URI_MAX, "tcp://%s:%d",
        j_host->valuestring, port);
}
```

**Issue:** `j_host->valuestring` comes directly from UART JSON input (user-controlled). While `snprintf` limits output to `BIZ_MQTT_URI_MAX` (128 bytes), a malicious host string could:
1. Contain embedded null bytes, truncating the URI unexpectedly.
2. Contain special characters that confuse the MQTT client library (e.g., `@`, `/`, `\n`).
3. Overflow the 128-byte buffer if the host string is long (snprintf handles this safely, but truncation produces an invalid URI).

There is no validation that `j_host->valuestring` is a valid hostname/IP. No length check before the snprintf call.

**Recommended Fix:**
```c
} else if (j_host != NULL && cJSON_IsString(j_host)) {
    cJSON *j_port = cJSON_GetObjectItem(root, "port");
    int port = (j_port != NULL && cJSON_IsNumber(j_port)) ?
        j_port->valueint : 1883;
    /* Validate host length: "tcp://" (6) + host + ":" (1) + port (max 5) + null */
    size_t host_len = strlen(j_host->valuestring);
    if (host_len == 0 || host_len > 100) {
        cJSON_Delete(root);
        biz_reply(seq, "mqtt_connect", -4, "invalid host length", NULL);
        return;
    }
    snprintf(params.uri, BIZ_MQTT_URI_MAX, "tcp://%s:%d",
        j_host->valuestring, port);
}
```

### H-02: Integer Truncation from `int` to `uint16_t` Without Bounds Check

**File:** `business_logic.c:367, 422, 483-484`
**Category:** Integer Overflow/Underflow

```c
// Line 367 (biz_cmd_find):
entry = biz_map_find_by_tag((uint16_t)j_tag_id->valueint);

// Line 422 (biz_cmd_outbound):
entry = biz_map_find_by_tag((uint16_t)j_tag_id->valueint);

// Lines 483-484 (biz_cmd_update_qty):
uint16_t tag_id = (uint16_t)j_tag_id->valueint;
uint16_t qty = (uint16_t)j_qty->valueint;
```

**Issue:** `cJSON::valueint` is `int` (32-bit). Casting to `uint16_t` silently truncates:
- Negative values wrap to large positive values (e.g., -1 -> 65535).
- Values > 65535 lose upper bits (e.g., 65536 -> 0, 131072 -> 0).
- For `qty`, a negative JSON value like `{"qty": -1}` becomes 65535, corrupting inventory data.

This could cause incorrect tag lookups, inventory corruption, or out-of-bounds access if `tag_id` is used as an array index elsewhere.

**Recommended Fix:**
```c
static uint16_t json_get_uint16(cJSON *item, uint16_t *out)
{
    if (item == NULL || !cJSON_IsNumber(item)) return -1;
    int val = item->valueint;
    if (val < 0 || val > 65535) return -2;
    *out = (uint16_t)val;
    return 0;
}

// Usage:
uint16_t tag_id;
if (json_get_uint16(j_tag_id, &tag_id) != 0) {
    biz_reply(seq, "find", -2, "invalid tag_id", NULL);
    return;
}
```

---

## Medium

### M-01: Unchecked `strncpy_s` Return Value in `biz_cmd_register`

**File:** `business_logic.c:755-761`
**Category:** Silent Data Truncation

```c
if (j_zone != NULL && cJSON_IsString(j_zone)) {
    strncpy_s(entry->zone, BIZ_ZONE_LEN,
        j_zone->valuestring, BIZ_ZONE_LEN - 1);  // return value IGNORED
}
if (j_item != NULL && cJSON_IsString(j_item)) {
    strncpy_s(entry->item, BIZ_ITEM_LEN,
        j_item->valuestring, BIZ_ITEM_LEN - 1);   // return value IGNORED
}
```

**Issue:** Unlike `biz_cmd_inbound` (lines 314-328) which checks `rc != EOK` and resets the field, `biz_cmd_register` silently ignores `strncpy_s` failures. If the source string exceeds the buffer, the destination is set to empty string by `strncpy_s` on error, silently losing data. The user gets a success response with empty zone/item fields.

**Recommended Fix:** Add return value checks matching `biz_cmd_inbound`:
```c
if (j_zone != NULL && cJSON_IsString(j_zone)) {
    errno_t rc = strncpy_s(entry->zone, BIZ_ZONE_LEN,
        j_zone->valuestring, BIZ_ZONE_LEN - 1);
    if (rc != EOK) {
        osal_printk("[WS63_BIZ] register zone copy fail rc=%d\r\n", (int)rc);
        entry->zone[0] = '\0';
    }
}
```

### M-02: Tight `snprintf` Buffer in `biz_cmd_find`

**File:** `business_logic.c:386-389`
**Category:** Buffer Overflow (truncation)

```c
char data_buf[64];
snprintf(data_buf, sizeof(data_buf),
    "{\"tag_id\":%u,\"zone\":\"%s\",\"item\":\"%s\"}",
    (unsigned int)entry->tag_id, entry->zone, entry->item);
```

**Issue:** Maximum output: `{"tag_id":65535,"zone":"1234567","item":"123456789012345"}` = ~56 chars. Fits in 64 bytes, but with zero margin. If `BIZ_ZONE_LEN` or `BIZ_ITEM_LEN` increase in a future iteration, this silently truncates the JSON, producing malformed output that could crash the JSON parser on the receiving end.

**Recommended Fix:** Increase buffer to 96 bytes, or use dynamic sizing:
```c
char data_buf[96];
```

### M-03: Potential Null `valuestring` Dereference

**File:** `business_logic.c:370`
**Category:** Null Pointer Dereference

```c
} else if (j_item != NULL && cJSON_IsString(j_item)) {
    for (uint16_t i = 0; i < g_biz_map.count; i++) {
        if (strncmp(g_biz_map.entries[i].item, j_item->valuestring,
            BIZ_ITEM_LEN) == 0) {
```

**Issue:** While `cJSON_IsString()` should guarantee `valuestring != NULL` in standard cJSON implementations, a corrupted or hand-crafted cJSON node could have `type == cJSON_String` with `valuestring == NULL`. The code trusts the cJSON library invariant without a defensive check. Same pattern at lines 313-316 (`j_zone->valuestring`) and lines 518, 578-580 (mqtt params).

**Recommended Fix:** Add defensive NULL checks:
```c
if (j_item != NULL && cJSON_IsString(j_item) && j_item->valuestring != NULL) {
```

### M-04: Ring Buffer Lacks Explicit Memory Barrier

**File:** `uart_vision.c:30-41`
**Category:** Race Condition (theoretical)

```c
static void uv_ring_push(const uint8_t *data, uint16_t len)
{
    for (uint16_t i = 0; i < len; i++) {
        uint16_t next = (g_uv_ring_head + 1) % UV_RING_SIZE;
        if (next == g_uv_ring_tail) {
            g_uv_ring_drop_count++;
            break;
        }
        g_uv_ring[g_uv_ring_head] = data[i];
        g_uv_ring_head = next;  // volatile write
    }
}
```

**Issue:** The ring buffer uses `volatile` indices for ISR/main-loop communication. On ARM Cortex-M33 (single-core, in-order), `volatile` provides sufficient ordering. However:
1. No explicit compiler barrier between `g_uv_ring[g_uv_ring_head] = data[i]` (line 38) and `g_uv_ring_head = next` (line 39). The `volatile` on `head` prevents reordering of the head update, but the data write is to a non-volatile array. A sufficiently aggressive compiler could reorder the data store after the head update.
2. The `g_uv_ring_drop_count++` (line 35) is a read-modify-write on a volatile variable, which is not atomic. If the main loop reads `g_uv_ring_drop_count` between the read and write in the ISR, it gets a stale value.

In practice, Cortex-M33's interrupt masking and the `volatile` keyword make this safe. But it violates the C standard's intent.

**Recommended Fix:** Add a compiler barrier before the head update:
```c
#include <stdatomic.h>
// or for this toolchain:
#define compiler_barrier() __asm__ volatile("" ::: "memory")

g_uv_ring[g_uv_ring_head] = data[i];
compiler_barrier();
g_uv_ring_head = next;
```

### M-05: Fragile Cleanup Pattern in `biz_handle_esp32_msg`

**File:** `business_logic.c:678-731`
**Category:** Memory Leak (latent)

```c
static void biz_handle_esp32_msg(const char *cmd, const char *data_json)
{
    cJSON *root = (data_json != NULL) ? cJSON_Parse(data_json) : NULL;

    if (strcmp(cmd, "task_done") == 0) {
        if (root == NULL) {
            return;   // OK: root is NULL, nothing to free
        }
        // ...
        if (j_task == NULL || !cJSON_IsString(j_task)) {
            cJSON_Delete(root);
            return;   // OK: freed before return
        }
        // ...
    } else if (strcmp(cmd, "error") == 0) {
        if (root == NULL) {
            return;   // OK: root is NULL
        }
        // ...
    }
    // ...
    if (root != NULL) {
        cJSON_Delete(root);  // only reached on non-early-return paths
    }
}
```

**Issue:** Every current code path correctly frees `root` before returning. However, the function mixes early returns (with manual cleanup) and a fall-through cleanup at the end. This is a maintenance hazard: any future branch that adds an early return between lines 715-728 without calling `cJSON_Delete(root)` will introduce an actual memory leak. On an embedded system with no heap allocator, cJSON uses an internal pool -- leaked objects exhaust the pool and cause all subsequent `cJSON_Parse` calls to fail.

**Recommended Fix:** Restructure to use a single cleanup exit point:

```c
static void biz_handle_esp32_msg(const char *cmd, const char *data_json)
{
    cJSON *root = (data_json != NULL) ? cJSON_Parse(data_json) : NULL;

    if (strcmp(cmd, "task_done") == 0) {
        if (root == NULL) goto out;
        cJSON *j_task = cJSON_GetObjectItem(root, "task");
        if (j_task == NULL || !cJSON_IsString(j_task)) goto out;
        // ... rest of logic
    } else if (strcmp(cmd, "error") == 0) {
        if (root == NULL) goto out;
        // ...
    }
    // ...

out:
    if (root != NULL) {
        cJSON_Delete(root);
    }
}
```

---

## Low

### L-01: `sscanf` with `%02x` Edge Case in `biz_parse_mac`

**File:** `business_logic.c:393-406`
**Category:** Input Validation

```c
static int biz_parse_mac(const char *str, uint8_t *mac)
{
    unsigned int a, b, c, d, e, f;
    if (sscanf(str, "%02x:%02x:%02x:%02x:%02x:%02x",
        &a, &b, &c, &d, &e, &f) != 6) {
        return -1;
    }
    mac[0] = (uint8_t)a; mac[1] = (uint8_t)b; mac[2] = (uint8_t)c;
    mac[3] = (uint8_t)d; mac[4] = (uint8_t)e; mac[5] = (uint8_t)f;
    return 0;
}
```

**Issue:** `sscanf` with `%02x` reads "up to 2 hex characters". Edge cases:
- `"1:00:00:00:00:00"` -- parses `a=1` (single digit), succeeds with wrong value.
- `"00:00:00:00:00:000000extra"` -- parses all 6 bytes, ignores trailing garbage. No length validation.
- Input shorter than 17 chars (e.g., `"00:00:00"`) -- sscanf returns 3, correctly rejected.

The single-digit parse is the real risk: `"1:00:00:00:00:00"` produces MAC `01:00:00:00:00:00` instead of being rejected. This could cause incorrect tag lookups.

**Recommended Fix:** Validate the format explicitly:
```c
static int biz_parse_mac(const char *str, uint8_t *mac)
{
    if (str == NULL || mac == NULL) return -1;
    /* MAC must be exactly "XX:XX:XX:XX:XX:XX" = 17 chars */
    if (strlen(str) != 17) return -1;
    unsigned int a, b, c, d, e, f;
    if (sscanf(str, "%02x:%02x:%02x:%02x:%02x:%02x",
        &a, &b, &c, &d, &e, &f) != 6) return -1;
    if (a > 0xFF || b > 0xFF || c > 0xFF ||
        d > 0xFF || e > 0xFF || f > 0xFF) return -1;
    mac[0] = (uint8_t)a; mac[1] = (uint8_t)b; mac[2] = (uint8_t)c;
    mac[3] = (uint8_t)d; mac[4] = (uint8_t)e; mac[5] = (uint8_t)f;
    return 0;
}
```

### L-02: `tag_id` Wraparound in `biz_map_alloc`

**File:** `business_logic.c:133`
**Category:** Integer Overflow

```c
entry->tag_id = g_biz_next_tag_id++;
```

**Issue:** `g_biz_next_tag_id` is `uint16_t`. After 65535 allocations (over the lifetime of the device), it wraps to 0. Tag ID 0 is never explicitly rejected by `biz_map_find_by_tag`, so a wrapped-around tag_id of 0 could collide with uninitialized entries. In practice, with `BIZ_TAG_MAX = 32`, this requires 65535 allocation/deletion cycles, which is unlikely but not impossible in a long-running warehouse system.

**Recommended Fix:**
```c
entry->tag_id = g_biz_next_tag_id++;
if (g_biz_next_tag_id == 0) {
    g_biz_next_tag_id = 1;  /* skip 0, reserved as "invalid" */
}
```

---

## Info

### I-01: Callback Function Pointers Not Validated on Registration

**File:** `business_logic.c:72-100`
**Category:** Defensive Programming

```c
void business_logic_register_uart_cb(biz_notify_uart_t cb)
{
    g_biz_uart_cb = cb;
    // no NULL check
}
```

**Issue:** All `business_logic_register_*_cb` functions accept NULL without complaint. While the call sites in `business_logic_init` pass valid function pointers, a future caller could register NULL, and the guard checks (`if (g_biz_uart_cb != NULL)`) in the wrapper functions would silently skip the callback. This is by design (optional callbacks), but logging a warning on NULL registration would aid debugging.

**Recommended Fix:** Add a warning log:
```c
void business_logic_register_uart_cb(biz_notify_uart_t cb)
{
    if (cb == NULL) {
        osal_printk("[WS63_BIZ] WARN: registering NULL uart cb\r\n");
    }
    g_biz_uart_cb = cb;
}
```

### I-02: NV Data Integrity Not Cryptographically Verified

**File:** `business_logic.c:184-208`
**Category:** Data Integrity

```c
int biz_map_load_nv(void)
{
    // ...
    if (data_len != max_len || g_biz_map.count > BIZ_TAG_MAX) {
        g_biz_map.count = 0;
        return -1;
    }
}
```

**Issue:** The NV load validates `count` range and data length, but does not verify data integrity (no CRC/checksum). Corrupted NV flash (power loss during write, flash wear) could produce valid-looking but semantically wrong data (e.g., garbled zone/item strings, invalid status enum values). The `status` field is cast from `uint8_t` without range validation against `biz_tag_status_t`.

**Recommended Fix:** Add a CRC field to `biz_tag_map_t` and validate on load:
```c
typedef struct {
    uint16_t count;
    biz_tag_entry_t entries[BIZ_TAG_MAX];
    uint32_t crc32;
} biz_tag_map_t;
```

---

## Positive Findings (Well-Done)

1. **`snprintf` used consistently** -- All format string operations use `snprintf` with explicit size, never `sprintf`.
2. **`strncpy_s` / `memcpy_s` used** -- Secure C functions used throughout, per project convention.
3. **cJSON NULL checks** -- All `cJSON_GetObjectItem` results checked for NULL before access.
4. **cJSON_Delete on most paths** -- All cJSON objects freed on success and error paths (except the fragile pattern noted in M-05).
5. **Ring buffer overflow handled** -- `uv_ring_push` correctly checks `next == tail` before writing.
6. **NV load validation** -- Count range and data length checked on load, with graceful fallback to empty table.
7. **`_Static_assert` on packed structs** -- `shared_protocol.h` enforces struct size at compile time.
8. **Big-endian protocol handling** -- SSAP protocol consistently uses big-endian for cross-device fields.
9. **UART RX callback is non-blocking** -- `uv_uart_rx_cb` only pushes to ring buffer, no business logic in ISR.

/*
 * test_shared_protocol.c — shared_protocol 单元测试
 * 测试 pack/unpack 和大小端处理
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

/* 包含业务代码 */
#include "shared_protocol.h"

/* 测试计数器 */
static int g_tests_passed = 0;
static int g_tests_failed = 0;

#define TEST(name) printf("  [TEST] %-40s ", name)
#define PASS() do { printf("✅ PASS\n"); g_tests_passed++; } while(0)
#define FAIL(msg) do { printf("❌ FAIL: %s\n", msg); g_tests_failed++; } while(0)

/* ========== 测试用例 ========== */

void test_struct_size(void) {
    TEST("shared_proto_adv_field_t 大小 = 12");
    if (sizeof(shared_proto_adv_field_t) != SHARED_PROTO_ADV_FIELD_LEN) {
        FAIL("结构体大小不为 12");
        return;
    }
    PASS();
}

void test_pack_le(void) {
    TEST("pack_adv: LE 格式打包");
    shared_proto_adv_field_t tx = {
        .magic = SHARED_PROTO_MAGIC,
        .tag_id = 0x0003,
        .qty = 52,
        .status = 2,
        .battery = 100,
        .seq = 1
    };
    uint8_t buf[SHARED_PROTO_ADV_FIELD_LEN] = {0};
    int ret = shared_protocol_pack_adv(&tx, buf, sizeof(buf));
    if (ret != SHARED_PROTO_OK) { FAIL("pack 返回错误"); return; }

    /* 验证 magic 字节 (LE: DD CC BB AA) */
    if (buf[0] != 0xDD || buf[1] != 0xCC || buf[2] != 0xBB || buf[3] != 0xAA) {
        FAIL("magic 字节不正确");
        return;
    }

    PASS();
}

void test_unpack_le(void) {
    TEST("unpack_adv: LE 格式解包");
    uint8_t buf[12] = {
        0xDD, 0xCC, 0xBB, 0xAA,  /* magic LE */
        0x03, 0x00,               /* tag_id = 3 */
        0x34, 0x00,               /* qty = 52 */
        0x02,                     /* status = 2 */
        0x64,                     /* battery = 100 */
        0x01, 0x00                /* seq = 1 */
    };

    shared_proto_adv_field_t rx = {0};
    int ret = shared_protocol_unpack_adv(buf, sizeof(buf), &rx);
    if (ret != SHARED_PROTO_OK) { FAIL("unpack 返回错误"); return; }
    if (rx.tag_id != 3) { FAIL("tag_id 不匹配"); return; }
    if (rx.qty != 52) { FAIL("qty 不匹配"); return; }
    if (rx.battery != 100) { FAIL("battery 不匹配"); return; }

    PASS();
}

void test_unpack_be(void) {
    TEST("unpack_adv: BE 格式解包 (兜底)");
    uint8_t buf[12] = {
        0xAA, 0xBB, 0xCC, 0xDD,  /* magic BE */
        0x00, 0x03,               /* tag_id = 3 (BE) */
        0x00, 0x34,               /* qty = 52 (BE) */
        0x02,                     /* status = 2 */
        0x64,                     /* battery = 100 */
        0x00, 0x01                /* seq = 1 (BE) */
    };

    shared_proto_adv_field_t rx = {0};
    int ret = shared_protocol_unpack_adv(buf, sizeof(buf), &rx);
    if (ret != SHARED_PROTO_OK) { FAIL("unpack 返回错误"); return; }
    if (rx.tag_id != 3) { FAIL("tag_id 不匹配"); return; }
    if (rx.qty != 52) { FAIL("qty 不匹配"); return; }

    PASS();
}

void test_unpack_invalid_magic(void) {
    TEST("unpack_adv: 无效 magic");
    uint8_t buf[12] = {
        0x00, 0x00, 0x00, 0x00,  /* 无效 magic */
        0x03, 0x00, 0x34, 0x00,
        0x02, 0x64, 0x01, 0x00
    };

    shared_proto_adv_field_t rx = {0};
    int ret = shared_protocol_unpack_adv(buf, sizeof(buf), &rx);
    if (ret == SHARED_PROTO_OK) { FAIL("无效 magic 应返回错误"); return; }

    PASS();
}

void test_unpack_null_input(void) {
    TEST("unpack_adv: NULL 输入");
    shared_proto_adv_field_t rx = {0};
    int ret = shared_protocol_unpack_adv(NULL, 12, &rx);
    if (ret != SHARED_PROTO_ERR_NULL) { FAIL("NULL 应返回 ERR_NULL"); return; }

    PASS();
}

void test_unpack_wrong_len(void) {
    TEST("unpack_adv: 错误长度");
    uint8_t buf[10] = {0};
    shared_proto_adv_field_t rx = {0};
    int ret = shared_protocol_unpack_adv(buf, 10, &rx);
    if (ret != SHARED_PROTO_ERR_LEN) { FAIL("错误长度应返回 ERR_LEN"); return; }

    PASS();
}

void test_pack_unpack_roundtrip(void) {
    TEST("pack → unpack 往返测试");
    shared_proto_adv_field_t tx = {
        .magic = SHARED_PROTO_MAGIC,
        .tag_id = 0x1234,
        .qty = 100,
        .status = 1,
        .battery = 85,
        .seq = 999
    };
    uint8_t buf[SHARED_PROTO_ADV_FIELD_LEN] = {0};
    int ret = shared_protocol_pack_adv(&tx, buf, sizeof(buf));
    if (ret != SHARED_PROTO_OK) { FAIL("pack 失败"); return; }

    shared_proto_adv_field_t rx = {0};
    ret = shared_protocol_unpack_adv(buf, sizeof(buf), &rx);
    if (ret != SHARED_PROTO_OK) { FAIL("unpack 失败"); return; }
    if (rx.tag_id != tx.tag_id) { FAIL("tag_id 不匹配"); return; }
    if (rx.qty != tx.qty) { FAIL("qty 不匹配"); return; }
    if (rx.status != tx.status) { FAIL("status 不匹配"); return; }
    if (rx.battery != tx.battery) { FAIL("battery 不匹配"); return; }
    if (rx.seq != tx.seq) { FAIL("seq 不匹配"); return; }

    PASS();
}

/* ========== 测试运行器 ========== */

void run_all_tests(void) {
    printf("\n========== shared_protocol 单元测试 ==========\n\n");

    test_struct_size();
    test_pack_le();
    test_unpack_le();
    test_unpack_be();
    test_unpack_invalid_magic();
    test_unpack_null_input();
    test_unpack_wrong_len();
    test_pack_unpack_roundtrip();

    printf("\n========== 结果: %d 通过, %d 失败 ==========\n\n",
        g_tests_passed, g_tests_failed);
}

int main(void) {
    run_all_tests();
    return g_tests_failed > 0 ? 1 : 0;
}

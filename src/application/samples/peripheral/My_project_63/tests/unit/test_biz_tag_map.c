/*
 * test_biz_tag_map.c — biz_tag_map 单元测试
 * 编译: gcc -I../mock -I../../components/business_logic -I../../components/shared_protocol test_biz_tag_map.c -o test_biz_tag_map
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

/* Mock 头文件（在 include 业务代码之前） */
#include "mock_nv_storage.h"

/* 业务代码需要的类型定义 */
#include "business_logic.h"

/* 测试计数器 */
static int g_tests_passed = 0;
static int g_tests_failed = 0;

#define TEST(name) printf("  [TEST] %-40s ", name)
#define PASS() do { printf("✅ PASS\n"); g_tests_passed++; } while(0)
#define FAIL(msg) do { printf("❌ FAIL: %s\n", msg); g_tests_failed++; } while(0)

/* ========== 测试用例 ========== */

void test_biz_map_add_normal(void) {
    TEST("biz_map_add: 正常添加");
    biz_tag_map_init();

    biz_tag_entry_t *e = biz_map_add(1);
    if (e == NULL) { FAIL("返回 NULL"); return; }
    if (e->tag_id != 1) { FAIL("tag_id 不匹配"); return; }
    if (biz_map_get_count() != 1) { FAIL("count 不为 1"); return; }

    PASS();
}

void test_biz_map_add_duplicate(void) {
    TEST("biz_map_add: 重复添加");
    biz_tag_map_init();

    biz_map_add(1);
    biz_tag_entry_t *e = biz_map_add(1);
    if (e != NULL) { FAIL("重复添加应返回 NULL"); return; }

    PASS();
}

void test_biz_map_add_max(void) {
    TEST("biz_map_add: 达到上限");
    biz_tag_map_init();

    for (uint16_t i = 1; i <= BIZ_TAG_MAX; i++) {
        biz_map_add(i);
    }
    biz_tag_entry_t *e = biz_map_add(BIZ_TAG_MAX + 1);
    if (e != NULL) { FAIL("超出上限应返回 NULL"); return; }

    PASS();
}

void test_biz_map_find_by_tag(void) {
    TEST("biz_map_find_by_tag: 正常查找");
    biz_tag_map_init();

    biz_map_add(42);
    biz_tag_entry_t *e = biz_map_find_by_tag(42);
    if (e == NULL) { FAIL("未找到"); return; }
    if (e->tag_id != 42) { FAIL("tag_id 不匹配"); return; }

    PASS();
}

void test_biz_map_find_by_tag_not_exist(void) {
    TEST("biz_map_find_by_tag: 不存在");
    biz_tag_map_init();

    biz_tag_entry_t *e = biz_map_find_by_tag(999);
    if (e != NULL) { FAIL("不存在应返回 NULL"); return; }

    PASS();
}

void test_biz_map_find_by_mac(void) {
    TEST("biz_map_find_by_mac: 正常查找");
    biz_tag_map_init();

    uint8_t mac[6] = {0x11, 0x22, 0x33, 0x44, 0x55, 0x66};
    biz_tag_entry_t *e = biz_map_add(1);
    if (e) memcpy(e->mac, mac, 6);

    biz_tag_entry_t *found = biz_map_find_by_mac(mac);
    if (found == NULL) { FAIL("未找到"); return; }
    if (found->tag_id != 1) { FAIL("tag_id 不匹配"); return; }

    PASS();
}

void test_biz_map_remove(void) {
    TEST("biz_map_remove: 正常删除");
    biz_tag_map_init();

    biz_map_add(1);
    biz_map_add(2);
    biz_map_remove(1);

    if (biz_map_find_by_tag(1) != NULL) { FAIL("已删除但仍能找到"); return; }
    if (biz_map_find_by_tag(2) == NULL) { FAIL("误删了其他条目"); return; }
    if (biz_map_get_count() != 1) { FAIL("count 不为 1"); return; }

    PASS();
}

void test_biz_map_save_load_nv(void) {
    TEST("biz_map_save/load_nv: 持久化");
    mock_nv_reset();
    biz_tag_map_init();

    biz_tag_entry_t *e = biz_map_add(1);
    if (e) {
        strncpy(e->item, "test_item", BIZ_ITEM_LEN - 1);
        strncpy(e->zone, "A", BIZ_ZONE_LEN - 1);
        e->qty = 50;
    }
    biz_map_save_nv();

    /* 重新初始化并加载 */
    biz_tag_map_init();
    biz_map_load_nv();

    biz_tag_entry_t *loaded = biz_map_find_by_tag(1);
    if (loaded == NULL) { FAIL("加载后未找到"); return; }
    if (strcmp(loaded->item, "test_item") != 0) { FAIL("item 不匹配"); return; }
    if (strcmp(loaded->zone, "A") != 0) { FAIL("zone 不匹配"); return; }
    if (loaded->qty != 50) { FAIL("qty 不匹配"); return; }

    PASS();
}

void test_biz_map_null_input(void) {
    TEST("biz_map: NULL 输入处理");
    biz_tag_map_init();

    biz_tag_entry_t *e = biz_map_find_by_tag(0);
    /* tag_id=0 不应该崩溃 */

    PASS();
}

/* ========== 测试运行器 ========== */

void run_all_tests(void) {
    printf("\n========== biz_tag_map 单元测试 ==========\n\n");

    test_biz_map_add_normal();
    test_biz_map_add_duplicate();
    test_biz_map_add_max();
    test_biz_map_find_by_tag();
    test_biz_map_find_by_tag_not_exist();
    test_biz_map_find_by_mac();
    test_biz_map_remove();
    test_biz_map_save_load_nv();
    test_biz_map_null_input();

    printf("\n========== 结果: %d 通过, %d 失败 ==========\n\n",
        g_tests_passed, g_tests_failed);
}

int main(void) {
    run_all_tests();
    return g_tests_failed > 0 ? 1 : 0;
}

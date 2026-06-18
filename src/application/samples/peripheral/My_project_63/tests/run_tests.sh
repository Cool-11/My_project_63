#!/bin/bash
# run_tests.sh — 单元测试运行脚本
# 用法: ./run_tests.sh [模块名]
# 示例: ./run_tests.sh biz_tag_map
#       ./run_tests.sh all

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$SCRIPT_DIR/.."
UNIT_DIR="$SCRIPT_DIR/unit"
MOCK_DIR="$SCRIPT_DIR/mock"
BUILD_DIR="$SCRIPT_DIR/build"

# 源代码目录
COMPONENTS_DIR="$PROJECT_DIR/components"

# 颜色
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# 创建构建目录
mkdir -p "$BUILD_DIR"

# 包含路径（mock 目录优先，覆盖系统头文件）
INCLUDES="-I$MOCK_DIR"
INCLUDES="$INCLUDES -I$COMPONENTS_DIR/business_logic"
INCLUDES="$INCLUDES -I$COMPONENTS_DIR/shared_protocol"
INCLUDES="$INCLUDES -I$COMPONENTS_DIR/sle_network"
INCLUDES="$INCLUDES -I$PROJECT_DIR/../../../../open_source/cjson/cjson"

# 源文件路径
SHARED_PROTOCOL_SRC="$COMPONENTS_DIR/shared_protocol/shared_protocol.c"
BIZ_TAG_MAP_SRC="$COMPONENTS_DIR/business_logic/biz_tag_map.c"

# 编译标志
CFLAGS="-Wall -Wextra -g -O0"

# 统计
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0

run_test() {
    local test_name=$1
    local test_file="$UNIT_DIR/test_${test_name}.c"
    local test_bin="$BUILD_DIR/test_${test_name}"

    if [ ! -f "$test_file" ]; then
        echo -e "${RED}[ERROR] 测试文件不存在: $test_file${NC}"
        return 1
    fi

    echo -e "${YELLOW}[BUILD] 编译 test_${test_name}...${NC}"

    # 根据模块选择源文件
    local extra_src=""
    case $test_name in
        shared_protocol)
            extra_src="$SHARED_PROTOCOL_SRC"
            ;;
        # biz_tag_map 需要更多 Mock，暂时跳过
        # biz_tag_map)
        #     extra_src="$BIZ_TAG_MAP_SRC"
        #     ;;
    esac

    # 编译
    gcc $CFLAGS $INCLUDES "$test_file" $extra_src -o "$test_bin" 2>&1 || {
        echo -e "${RED}[FAIL] 编译失败${NC}"
        return 1
    }

    echo -e "${GREEN}[RUN] 运行 test_${test_name}...${NC}"

    # 运行
    "$test_bin"
    local exit_code=$?

    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    if [ $exit_code -eq 0 ]; then
        PASSED_TESTS=$((PASSED_TESTS + 1))
    else
        FAILED_TESTS=$((FAILED_TESTS + 1))
    fi

    return $exit_code
}

# 主逻辑
MODULE=${1:-all}

echo ""
echo "=========================================="
echo "  WS63 单元测试运行器"
echo "=========================================="
echo ""

case $MODULE in
    # biz_tag_map 需要更多 Mock，暂时跳过
    # biz_tag_map)
    #     run_test "biz_tag_map"
    #     ;;
    shared_protocol)
        run_test "shared_protocol"
        ;;
    all)
        # run_test "biz_tag_map" || true  # 暂时跳过
        run_test "shared_protocol" || true
        ;;
    *)
        echo -e "${RED}[ERROR] 未知模块: $MODULE${NC}"
        echo "可用模块: shared_protocol, all"
        exit 1
        ;;
esac

echo ""
echo "=========================================="
echo "  总计: $TOTAL_TESTS 个测试模块"
echo -e "  通过: ${GREEN}$PASSED_TESTS${NC}"
echo -e "  失败: ${RED}$FAILED_TESTS${NC}"
echo "=========================================="
echo ""

if [ $FAILED_TESTS -gt 0 ]; then
    exit 1
fi
exit 0

#===============================================================================
# @brief    cmake file
#===============================================================================
set(SOURCES "${SOURCES}"
	"${CMAKE_CURRENT_SOURCE_DIR}/app/main.c"
	"${CMAKE_CURRENT_SOURCE_DIR}/components/shared_protocol/shared_protocol.c"
	"${CMAKE_CURRENT_SOURCE_DIR}/components/sle_network/sle_network.c"
	"${CMAKE_CURRENT_SOURCE_DIR}/components/uart_vision/uart_vision.c"
	"${CMAKE_CURRENT_SOURCE_DIR}/components/uart_display/uart_display.c"
	"${CMAKE_CURRENT_SOURCE_DIR}/components/cloud_storage/cloud_storage.c"
	"${CMAKE_CURRENT_SOURCE_DIR}/components/business_logic/biz_core.c"
	"${CMAKE_CURRENT_SOURCE_DIR}/components/business_logic/biz_tag_map.c"
	"${CMAKE_CURRENT_SOURCE_DIR}/components/business_logic/biz_esp32_cmd.c"
	"${CMAKE_CURRENT_SOURCE_DIR}/components/business_logic/biz_esp32_resp.c"
	"${CMAKE_CURRENT_SOURCE_DIR}/components/business_logic/biz_screen_cmd.c"
	"${CMAKE_CURRENT_SOURCE_DIR}/components/business_logic/biz_wifi_mqtt.c"
	"${CMAKE_CURRENT_SOURCE_DIR}/components/business_logic/biz_sle.c"
	PARENT_SCOPE)

set(PUBLIC_HEADER "${PUBLIC_HEADER}"
	"${CMAKE_CURRENT_SOURCE_DIR}/components/shared_protocol"
	"${CMAKE_CURRENT_SOURCE_DIR}/components/sle_network"
	"${CMAKE_CURRENT_SOURCE_DIR}/components/uart_vision"
	"${CMAKE_CURRENT_SOURCE_DIR}/components/uart_display"
	"${CMAKE_CURRENT_SOURCE_DIR}/components/cloud_storage"
	"${CMAKE_CURRENT_SOURCE_DIR}/components/business_logic"
	PARENT_SCOPE)

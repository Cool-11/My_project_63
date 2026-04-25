#===============================================================================
# @brief    cmake file
#===============================================================================
set(SOURCES "${SOURCES}"
	"${CMAKE_CURRENT_SOURCE_DIR}/app/main.c"
	"${CMAKE_CURRENT_SOURCE_DIR}/components/shared_protocol/shared_protocol.c"
	"${CMAKE_CURRENT_SOURCE_DIR}/components/sle_network/sle_network.c"
	"${CMAKE_CURRENT_SOURCE_DIR}/components/uart_vision/uart_vision.c"
	"${CMAKE_CURRENT_SOURCE_DIR}/components/cloud_storage/cloud_storage.c"
	"${CMAKE_CURRENT_SOURCE_DIR}/components/business_logic/business_logic.c"
	PARENT_SCOPE)

set(PUBLIC_HEADER "${PUBLIC_HEADER}"
	"${CMAKE_CURRENT_SOURCE_DIR}/components/shared_protocol"
	"${CMAKE_CURRENT_SOURCE_DIR}/components/sle_network"
	"${CMAKE_CURRENT_SOURCE_DIR}/components/uart_vision"
	"${CMAKE_CURRENT_SOURCE_DIR}/components/cloud_storage"
	"${CMAKE_CURRENT_SOURCE_DIR}/components/business_logic"
	PARENT_SCOPE)

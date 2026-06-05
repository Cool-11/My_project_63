# Install script for directory: /home/zyh110206/TcXc/ws63_bs2x_sle_project/src/drivers/drivers/hal

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/usr/local")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "TRUE")
endif()

# Set default install directory permissions.
if(NOT DEFINED CMAKE_OBJDUMP)
  set(CMAKE_OBJDUMP "/home/zyh110206/TcXc/ws63_bs2x_sle_project/src/tools/bin/compiler/riscv/cc_riscv32_musl_105/cc_riscv32_musl/bin/riscv32-linux-musl-objdump")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("/home/zyh110206/TcXc/ws63_bs2x_sle_project/src/output/ws63/acore/ws63-loaderboot/hal/adc/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("/home/zyh110206/TcXc/ws63_bs2x_sle_project/src/output/ws63/acore/ws63-loaderboot/hal/cpu_core/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("/home/zyh110206/TcXc/ws63_bs2x_sle_project/src/output/ws63/acore/ws63-loaderboot/hal/dma/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("/home/zyh110206/TcXc/ws63_bs2x_sle_project/src/output/ws63/acore/ws63-loaderboot/hal/efuse/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("/home/zyh110206/TcXc/ws63_bs2x_sle_project/src/output/ws63/acore/ws63-loaderboot/hal/gpio/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("/home/zyh110206/TcXc/ws63_bs2x_sle_project/src/output/ws63/acore/ws63-loaderboot/hal/i2c/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("/home/zyh110206/TcXc/ws63_bs2x_sle_project/src/output/ws63/acore/ws63-loaderboot/hal/mips/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("/home/zyh110206/TcXc/ws63_bs2x_sle_project/src/output/ws63/acore/ws63-loaderboot/hal/pinmux/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("/home/zyh110206/TcXc/ws63_bs2x_sle_project/src/output/ws63/acore/ws63-loaderboot/hal/pmp/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("/home/zyh110206/TcXc/ws63_bs2x_sle_project/src/output/ws63/acore/ws63-loaderboot/hal/pwm/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("/home/zyh110206/TcXc/ws63_bs2x_sle_project/src/output/ws63/acore/ws63-loaderboot/hal/reboot/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("/home/zyh110206/TcXc/ws63_bs2x_sle_project/src/output/ws63/acore/ws63-loaderboot/hal/reg_config/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("/home/zyh110206/TcXc/ws63_bs2x_sle_project/src/output/ws63/acore/ws63-loaderboot/hal/security_unified/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("/home/zyh110206/TcXc/ws63_bs2x_sle_project/src/output/ws63/acore/ws63-loaderboot/hal/spi/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("/home/zyh110206/TcXc/ws63_bs2x_sle_project/src/output/ws63/acore/ws63-loaderboot/hal/tcxo/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("/home/zyh110206/TcXc/ws63_bs2x_sle_project/src/output/ws63/acore/ws63-loaderboot/hal/timer/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("/home/zyh110206/TcXc/ws63_bs2x_sle_project/src/output/ws63/acore/ws63-loaderboot/hal/uart/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("/home/zyh110206/TcXc/ws63_bs2x_sle_project/src/output/ws63/acore/ws63-loaderboot/hal/watchdog/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("/home/zyh110206/TcXc/ws63_bs2x_sle_project/src/output/ws63/acore/ws63-loaderboot/hal/sfc/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("/home/zyh110206/TcXc/ws63_bs2x_sle_project/src/output/ws63/acore/ws63-loaderboot/hal/tsensor/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("/home/zyh110206/TcXc/ws63_bs2x_sle_project/src/output/ws63/acore/ws63-loaderboot/hal/sio/cmake_install.cmake")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("/home/zyh110206/TcXc/ws63_bs2x_sle_project/src/output/ws63/acore/ws63-loaderboot/hal/rtc_unified/cmake_install.cmake")
endif()


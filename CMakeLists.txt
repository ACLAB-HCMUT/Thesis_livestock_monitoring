# SPDX-License-Identifier: Apache-2.0

cmake_minimum_required(VERSION 3.20.0)

set(BOARD xiao_ble/nrf52840/sense)

find_package(Zephyr REQUIRED HINTS $ENV{ZEPHYR_BASE})
project(do_an)


FILE(GLOB app_sources src/*.cpp)

add_subdirectory(src/global)
add_subdirectory(src/thread)
add_subdirectory(src/lora)
add_subdirectory(src/gps)
add_subdirectory(src/button)
add_subdirectory(src/ble)
add_subdirectory(src/flash)

target_sources(app  
                    PRIVATE 
                        src/main.cpp)

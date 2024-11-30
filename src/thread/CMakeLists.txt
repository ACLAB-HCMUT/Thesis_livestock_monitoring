cmake_minimum_required(VERSION 3.20.0)

target_include_directories(app PRIVATE .)
target_sources(app 
                    PRIVATE 
                        ${CMAKE_CURRENT_SOURCE_DIR}/blink_led_thread.cpp
                        ${CMAKE_CURRENT_SOURCE_DIR}/button_thread.cpp
                        ${CMAKE_CURRENT_SOURCE_DIR}/read_lora_thread.cpp
                        ${CMAKE_CURRENT_SOURCE_DIR}/gps_thread.cpp
                        )
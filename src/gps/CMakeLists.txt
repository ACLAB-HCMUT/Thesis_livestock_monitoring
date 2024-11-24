cmake_minimum_required(VERSION 3.20.0)

target_include_directories(app PRIVATE .)
target_sources(app 
                    PRIVATE 
                        ${CMAKE_CURRENT_SOURCE_DIR}/gps_software_serial.cpp
                        )
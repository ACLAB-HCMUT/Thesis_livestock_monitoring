extern "C" {
#include <cstdint>
#include <zephyr/drivers/flash.h>
#include <zephyr/storage/flash_map.h>
#include <zephyr/fs/nvs.h>
}
#include <iostream>

#include "global.hpp"
#include "flash.hpp"

enum system_status_e system_status = NORMAL;
uint16_t cow_addr = 0x0000;

int init_cow_addr()
{
    int error_code = read_flash(COW_ADDR_ID, (uint8_t*)&cow_addr, 2);
    if (error_code == 2){
        std::cout << "Read cow addr success " << cow_addr << std::endl;
    }else{
        std::cout << "Read cow addr failed, error_code: " << error_code << std::endl;
    }
    return error_code;
}
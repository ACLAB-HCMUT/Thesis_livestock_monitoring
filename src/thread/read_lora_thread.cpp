extern "C" {
#include <zephyr/kernel.h>
#include <zephyr/drivers/gpio.h>
}

#include <iostream>
#include "global.hpp"
#include "lora.hpp"


void read_lora_entry(void *p1, void *p2, void *p3)
{
    if(init_lora()){
        return;
    }
    uint8_t data;
    uint8_t buffer[512] = {0};
    uint8_t index = 0, is_begin = 0;
	while (1) {
        while(lora_read(&data) == 0){
            /* ------------ Test ------------- */
            std::cout << data;
            if(data == '#') {
                std::cout << std::endl;
            }
            /* -------------------------------- */
            
            if(is_begin == 1){
                if(data == '#'){
                    handle_lora_message(buffer, index);
                    index = 0, is_begin = 0;
                }else{
                    buffer[index ++] = data;
                }
            }else{
                if(data == '!'){
                    is_begin = 1, index = 0;
                }
            }
        }
        
		k_msleep(10);
	}
}
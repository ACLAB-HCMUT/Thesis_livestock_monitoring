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
    uint8_t lora_buffer[128] = {0};
    uint8_t length = 0, is_begin = 0;
    uint8_t lora_send_buffer[50] = {0};
	while (1) {
        while(lora_read(&data) == 0){

            if(data == '!'){
                is_begin = 1;
            }else{
                if(is_begin == 1){
                    if(data == '#') {
                        // Handle data receive
                        uint16_t cow_addr_recv = (uint16_t)lora_buffer[0] << 8 | (uint16_t)lora_buffer[1];
                        std::cout << "cow_addr_recv: " << cow_addr_recv << std::endl;

                        if(cow_addr_recv == cow_addr){
                            std::cout << "handle lora recv\n";
                            lora_send_buffer[0] = '!';              // 0
                            lora_send_buffer[1] = cow_addr >> 8;    // 1
                            lora_send_buffer[2] = cow_addr & 0xff;   // 2
                            memcpy(lora_send_buffer + 3, &lat, 4);  // 3 4 5 6
                            memcpy(lora_send_buffer + 7, &lng, 4);  // 7 8 9 10
                            lora_send_buffer[11] = 0; // cow status // 11
                            lora_send_buffer[12] = '#';             // 12

                            lora_write(lora_send_buffer, 13);                            
                        }
                        is_begin = 0;
                        length = 0;
                    }else{
                        lora_buffer[length++] = data;
                    }
                }
            }
            
        }
		k_msleep(10);
	}
}
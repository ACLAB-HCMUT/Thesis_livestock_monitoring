extern "C" {
#include <zephyr/kernel.h>
#include <zephyr/drivers/gpio.h>
#include <cstdint>
}

#include <iostream>
#include "global.hpp"
#include "button.hpp"
#include "ble.hpp"

/* Define button action */
enum button_status_e {RELEASED, PRESSED, HOLD};
enum button_status_e button_status = RELEASED;
uint16_t button_count = 0;

/* Define button dt */
struct gpio_dt_spec button_dt;

int init_button(){
    std::cout << "init_button\n";

    const struct device *button_port = DEVICE_DT_GET(BUTTON_PORT);
	if (!device_is_ready(button_port)) {
        std::cout << "button_port device not found or not ready\n";	
		return 1;
	}

    button_dt.port = button_port;
	button_dt.pin = BUTTON_PIN;

    /* Configure input for button */
    int ret = gpio_pin_configure_dt(&button_dt, GPIO_INPUT);
    if (ret < 0) {
        std::cout << "Cannot configure button_dt, err_code: " << ret << std::endl;
        return ret;
    }

    return 0;
}


void change_system_status(){
    if(system_status == NORMAL){
        system_status = CONFIG_ADDR;
        /* Enable bluetooth */
        enable_ble();
    }else{
        system_status = NORMAL;
        /* Disable bluetooth */
        disable_ble();
    }
}


void fsm_button() {
    uint8_t button_value = gpio_pin_get_dt(&button_dt);

    switch (button_status)
    {
    case RELEASED:
        if(button_value == 0) {
            /* Pressed */
            button_count ++;
            if(button_count >= 3){
                button_count = 0;
                button_status = PRESSED;
                
            }
        }else{
            button_count = 0;
        }
        break;
    case PRESSED:
        if(button_value == 0){
            /* Pressed */
            button_count ++;
            if(button_count >= 300){
                button_count = 0;
                button_status = RELEASED;
                change_system_status();
            }
        }else{
            button_count = 0;
            button_status = RELEASED;
        }
        break;
    default:
        break;
    }
}


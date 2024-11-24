extern "C" {
#include <zephyr/kernel.h>
#include <zephyr/drivers/gpio.h>
}

#include <iostream>
#include "global.hpp"


void blink_led_entry(void *p1, void *p2, void *p3)
{
	const struct gpio_dt_spec blink_led0 = GPIO_DT_SPEC_GET(LED0_NODE, gpios);
	const struct gpio_dt_spec blink_led1 = GPIO_DT_SPEC_GET(LED1_NODE, gpios);

	int ret = gpio_pin_configure_dt(&blink_led0, GPIO_OUTPUT_ACTIVE);
	if (ret) {
		std::cout << "Error configuring led0, err_code: " << ret << std::endl;
		return;
	}

	ret = gpio_pin_configure_dt(&blink_led1, GPIO_OUTPUT_ACTIVE);
	if (ret) {
		std::cout << "Error configuring led1, err_code: " << ret << std::endl;
		return;
	}
	
	while (1) {
		
		switch (system_status)
		{
		case NORMAL:
			/* Blink led 0 */
			gpio_pin_toggle_dt(&blink_led0);
			gpio_pin_set_dt(&blink_led1, 0);
			k_msleep(1000);
			break;
		case CONFIG_ADDR:
			/* Blink led 1 */
			gpio_pin_toggle_dt(&blink_led1);
			gpio_pin_set_dt(&blink_led0, 0);
			k_msleep(1000);
			break;
		case CONNECTED:
			/* Blink led 1 */
			gpio_pin_toggle_dt(&blink_led1);
			gpio_pin_set_dt(&blink_led0, 0);
			k_msleep(250);
			break;
		default:
			k_msleep(1000);
			break;
		}
		
		
	}
}
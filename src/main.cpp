extern "C" {
#include <zephyr/kernel.h>
}

#include "flash.hpp"
#include "global.hpp"

struct k_thread blink_led_thread;
K_THREAD_STACK_DEFINE(blink_led_stack_area, 1024);
extern void blink_led_entry(void *p1, void *p2, void *p3);

struct k_thread button_thread;
K_THREAD_STACK_DEFINE(button_stack_area, 1024);
extern void button_entry(void *p1, void *p2, void *p3);

struct k_thread read_lora_thread;
K_THREAD_STACK_DEFINE(read_lora_stack_area, 1024);
extern void read_lora_entry(void *p1, void *p2, void *p3);

struct k_thread gps_thread;
K_THREAD_STACK_DEFINE(gps_stack_area, 1024);
extern void gps_entry(void *p1, void *p2, void *p3);

int main(void)
{
	k_thread_create(&blink_led_thread, (k_thread_stack_t *)&blink_led_stack_area,
			K_THREAD_STACK_SIZEOF(blink_led_stack_area), blink_led_entry, NULL, NULL,
			NULL, 5, 0, K_NO_WAIT);

	k_thread_create(&button_thread, (k_thread_stack_t *)&button_stack_area,
			K_THREAD_STACK_SIZEOF(button_stack_area), button_entry, NULL, NULL, NULL, 5,
			0, K_NO_WAIT);

	k_thread_create(&read_lora_thread, (k_thread_stack_t *)&read_lora_stack_area,
			K_THREAD_STACK_SIZEOF(read_lora_stack_area), read_lora_entry, NULL, NULL,
			NULL, 5, 0, K_NO_WAIT);
	
	k_thread_create(&gps_thread, (k_thread_stack_t *)&gps_stack_area,
			K_THREAD_STACK_SIZEOF(gps_stack_area), gps_entry, NULL, NULL, NULL, 5,
			0, K_NO_WAIT);

	init_flash_memory();
	init_cow_addr();

	while (1) {
		k_msleep(1000);
	}
	return 0;
}

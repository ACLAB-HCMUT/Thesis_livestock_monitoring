extern "C" {
#include <zephyr/kernel.h>
#include <zephyr/device.h>
#include <zephyr/drivers/uart.h>
}

#include <iostream>
#include "ble.hpp"
#include "global.hpp"
#include "gps_software_serial.hpp"
#include "SoftwareSerial.hpp"
#include "TinyGPSPlus.hpp"
#include "flash.hpp"

struct k_thread blink_led_thread;
K_THREAD_STACK_DEFINE(blink_led_stack_area, 1024);
extern void blink_led_entry(void *p1, void *p2, void *p3);

struct k_thread button_thread;
K_THREAD_STACK_DEFINE(button_stack_area, 1024);
extern void button_entry(void *p1, void *p2, void *p3);

struct k_thread read_lora_thread;
K_THREAD_STACK_DEFINE(read_lora_stack_area, 1024);
extern void read_lora_entry(void *p1, void *p2, void *p3);

const char *gpsStream =
	"$GNGGA,090858.000,1052.82434,N,10648.24335,E,1,08,2.6,5.8,M,-3.7,M,,*52\r\n"
	"$GPGGA,045104.000,3014.1985,N,09749.2873,W,1,09,1.2,211.6,M,-22.5,M,,0000*62\r\n"
	"$GPRMC,045200.000,A,3014.3820,N,09748.9514,W,36.88,65.02,030913,,,A*77\r\n"
	"$GPGGA,045201.000,3014.3864,N,09748.9411,W,1,10,1.2,200.8,M,-22.5,M,,0000*6C\r\n"
	"$GPRMC,045251.000,A,3014.4275,N,09749.0626,W,0.51,217.94,030913,,,A*7D\r\n"
	"$GPGGA,045252.000,3014.4273,N,09749.0628,W,1,09,1.3,206.9,M,-22.5,M,,0000*6F\r\n"
	"$GNRMC,090858.000,A,1052.82434,N,10648.24335,E,0.00,291.12,221124,,,A,V*0E\r\n"
	"$GNGLL,1052.82434,N,10648.24335,E,090858.000,A,A*4C\r\n"
	"$GNGGA,,,,,,,,,,,,,,*52\r\n";

TinyGPSPlus gps;

void displayInfo()
{
	std::cout << "Location:";
	if (gps.location.isValid()) {
		std::cout << gps.location.lat() << ", " << gps.location.lng();
	} else {
		std::cout << "INVALID";
	}
	std::cout << std::endl;
}

int main(void)
{
	k_thread_create(&blink_led_thread, (k_thread_stack_t *)&blink_led_stack_area,
			K_THREAD_STACK_SIZEOF(blink_led_stack_area), blink_led_entry, NULL, NULL,
			NULL, 5, 0, K_NO_WAIT);

	k_thread_create(&button_thread, (k_thread_stack_t *)&button_stack_area,
			K_THREAD_STACK_SIZEOF(button_stack_area), button_entry, NULL, NULL, NULL, 5,
			0, K_NO_WAIT);

	// k_thread_create(&read_lora_thread, (k_thread_stack_t *)&read_lora_stack_area,
	// 		K_THREAD_STACK_SIZEOF(read_lora_stack_area), read_lora_entry, NULL, NULL,
	// 		NULL, 5, 0, K_NO_WAIT);
	
	// while (*gpsStream) {
	// 	if (gps.encode(*gpsStream++)) {
	// 		displayInfo();
	// 	}
	// }
	// std::cout << "Encode GPS Done\n";
	init_flash_memory();
	// init_gps_serial();
	init_cow_addr();

	while (1) {
		// while(gps_serial_is_available()){
		// 	uint8_t data = gps_serial_read();
		// 	if(gps.encode(data)){
		// 		displayInfo();
		// 	}
		// }
		k_msleep(10);
	}
	return 0;
}

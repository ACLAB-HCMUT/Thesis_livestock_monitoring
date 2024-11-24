extern "C" {
#include <cstdint>
#include <zephyr/device.h>
#include <zephyr/drivers/uart.h>
#include <string.h>
}

#include <iostream>
#include "lora.hpp"
#include "global.hpp"
#include "gps_software_serial.hpp"

const struct device *const uart_dev = DEVICE_DT_GET(LORA_SERIAL);
int init_lora()
{
	/* Init hardware serial */
	if (!device_is_ready(uart_dev)) {
		/* Not ready, do not use */
		std::cout << "uart0 not ready\n";
		return -ENODEV;
	}
	std::cout << "init uart success\n";
	return 0;
}

void lora_write(uint8_t byte)
{
	uart_poll_out(uart_dev, byte);
}

int lora_read(uint8_t *data)
{
	int err_code = uart_poll_in(uart_dev, data);
	return err_code;
}

uint8_t gps_message[11] = {0};
void update_gps_message()
{
	memcpy(gps_message, &cow_addr, 2); // 0 1
	gps_message[2] = 0;               // 2
	memcpy(gps_message + 3, &lat, 4);  // 3 4 5 6
	memcpy(gps_message + 7, &lng, 4);  // 7 8 9 10
}

void handle_lora_message(uint8_t *message, uint8_t length)
{
	for(uint8_t i = 0; i < length; i++){
		std::cout << std::hex << message[i] << " ";
	}
	std::cout << std::endl;

	uint16_t addr = 0;
	memcpy(&addr, message, 2);

	if (addr == cow_addr) {
		uint8_t command = message[2];
		if (command == 0x10) {
			/* GPS */
			update_gps_message();
			for (uint8_t i = 0; i < 11; i++) {
				lora_write(gps_message[i]);
			}
		}
	} else {
		return;
	}
}
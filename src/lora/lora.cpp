extern "C" {
#include <cstdint>
#include <zephyr/device.h>
#include <zephyr/drivers/uart.h>
#include <string.h>
}

#include <iostream>
#include "lora.hpp"
#include "global.hpp"


const struct device *uart_dev = DEVICE_DT_GET(DT_NODELABEL(uart0));
struct uart_config uart_cfg = {
	.baudrate = 9600,
	.parity = UART_CFG_PARITY_NONE,
	.stop_bits = UART_CFG_STOP_BITS_1,
	.data_bits = UART_CFG_DATA_BITS_8,
	.flow_ctrl = UART_CFG_FLOW_CTRL_NONE,
};

int init_lora()
{
	/* Init hardware serial */
	if (!device_is_ready(uart_dev)) {
		/* Not ready, do not use */
		std::cout << "uart0 not ready\n";
		return -ENODEV;
	}
	int rc;
	rc = uart_configure(uart_dev, &uart_cfg);
	if (rc) {
		std::cout << "Could not configure device "  << uart_dev->name << std::endl;
		return rc;
	}

	std::cout << "init uart success\n";
	return 0;
}

void lora_write(uint8_t* data, int length)
{
	uart_tx(uart_dev, data, length, 10);
}

int lora_read(uint8_t *data)
{
	int err_code = uart_poll_in(uart_dev, data);
	return err_code;
}

uint8_t gps_message[11] = {0};
float gps_denta = 0.00001;
void update_gps_message()
{
	memcpy(gps_message, &cow_addr, 2); // 0 1
	gps_message[2] = 0;               // 2
	memcpy(gps_message + 3, &lat, 4);  // 3 4 5 6
	memcpy(gps_message + 7, &lng, 4);  // 7 8 9 10
	
	/* ------------ Test ------------- */
	lat += gps_denta;
	lng += gps_denta;
	gps_denta = gps_denta + 0.00001;
	/* --------------------------------*/
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
			lora_write(gps_message, 11);
			
		}
	} else {
		return;
	}
}
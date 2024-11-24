extern "C" {
#include <zephyr/drivers/gpio.h>
}

#include <iostream>

#include "LoraM5Stack.hpp"
#include "SoftwareSerial.hpp"

LoraM5Stack::LoraM5Stack(struct gpio_dt_spec *rx_dt, struct gpio_dt_spec *tx_dt)
{
	lora_serial = new SoftwareSerial(rx_dt, tx_dt);
}

uint8_t LoraM5Stack::lora_send_command(uint8_t opcode, uint8_t addr, uint8_t length, uint8_t *param)
{
	lora_serial->write(opcode);
	lora_serial->write(addr);
	lora_serial->write(length);

	if (opcode == SET_REGISTER_COMMAND) {
		for (uint8_t i = 0; i < length; i++) {
			lora_serial->write(param[i]);
		}
	}

	return 0;
}

uint8_t LoraM5Stack::lora_config_addr(uint16_t addr)
{
    std::cout << "Config addr: " << addr << std::endl;
	
	uint8_t addr_bytes[2];
	addr_bytes[0] = addr >> 8;
	addr_bytes[1] = addr & 0xff;

	lora_send_command(SET_REGISTER_COMMAND, 0x00, 2, addr_bytes);
	return 0;
}

uint8_t LoraM5Stack::lora_config_channel(uint8_t channel)
{
    std::cout << "Config channel: " << channel << std::endl;
	
	lora_send_command(SET_REGISTER_COMMAND, 0x04, 1, &channel);
	return 0;
}

uint8_t LoraM5Stack::lora_config_key(uint16_t key)
{
    std::cout << "Config key: " << key << std::endl;
	uint8_t key_bytes[2];
	key_bytes[0] = key >> 8;
	key_bytes[1] = key & 0xff;

	lora_send_command(SET_REGISTER_COMMAND, 0x06, 2, key_bytes);
	return 0;
}

void LoraM5Stack::lora_recv_response()
{
	if (lora_serial->isAvailable()) {
        std::cout << "From lora: ";
		
		while (lora_serial->isAvailable()) {
			uint8_t byte_recv = lora_serial->read();
            std::cout << byte_recv << " ";
		}
        std::cout << std::endl;
	}
}

uint8_t LoraM5Stack::lora_get_addr()
{
    std::cout << "get addr\n";
	lora_send_command(READ_REGISTER_COMMAND, 0x00, 2, NULL);
	return 0;
}

uint8_t LoraM5Stack::lora_get_channel()
{
	std::cout << "get addr\n";
	lora_send_command(READ_REGISTER_COMMAND, 0x04, 1, NULL);
	return 0;
}

void LoraM5Stack::lora_send_data(uint16_t addr, uint8_t channel, uint8_t *data, uint8_t length)
{

	uint8_t temp1 = addr >> 8;
	this->lora_serial->write(temp1);
	// this->lora_serial->write(addr & 0xff);
	uint8_t temp2 = addr & 0xff;
	this->lora_serial->write(temp2);
	this->lora_serial->write(channel);
	for (uint8_t i = 0; i < length; i++) {
		this->lora_serial->write(data[i]);
	}
}

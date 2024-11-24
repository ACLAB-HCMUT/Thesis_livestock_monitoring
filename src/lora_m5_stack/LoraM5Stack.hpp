#ifndef LORAM5STACK_H
#define LORAM5STACK_H

extern "C" {
#include <zephyr/drivers/gpio.h>
}

#include <SoftwareSerial.hpp>

#define SET_REGISTER_COMMAND  0xC0
#define READ_REGISTER_COMMAND 0xC1

class LoraM5Stack
{
      private:
	SoftwareSerial *lora_serial;

      public:
	/**
	 * @brief This function will create an instance of LoraM5Stack with baudrate is 9600
	 * @param rx_dt Rx pin
	 * @param tx_dt Tx pin
	 */
	LoraM5Stack(struct gpio_dt_spec *rx_dt, struct gpio_dt_spec *tx_dt);

	/**
	 * @brief This function use to send command to module lora (this module must be in
	 * configurable mode)
	 * @param opcode opcode of command
	 * @param addr starting register address which we want to write data
	 * @param length number of register which we would like to write
	 * @param param a array contains `length` bytes (each byte for each register)
	 */
	uint8_t lora_send_command(uint8_t opcode, uint8_t addr, uint8_t length, uint8_t *param);

	/**
	 * @brief This function use to config address of module lora
	 * @param addr address which we want to assign for module lora
	 */
	uint8_t lora_config_addr(uint16_t addr);

	/**
	 * @brief This function use to config channel of module lora
	 * @param channel channel which we want to assign for module lora
	 */

	uint8_t lora_config_channel(uint8_t channel);
	/**
	 * @brief This function use to config key of module lora
	 * @param key key which we want to assign for module lora
	 */

	uint8_t lora_config_key(uint16_t key);

	/**
	 * @brief This function use to send a command which use to get address of module lora.
	 * User need to get response from lora module in another task `xxx`
	 */
	uint8_t lora_get_addr();

	/**
	 * @brief This function use to send a command which use to get channel of module lora.
	 * User need to get response from lora module in another task `xxx`
	 */
	uint8_t lora_get_channel();

	/**
	 * @brief This function use to check lora receive buffer and only one byte from this buffer
	 * if it availabel
	 */
	void lora_recv_response();

	/**
	 * @brief This function user to send message to another lora module
	 * @param addr address of another lora module
	 * @param channel chanel of another lora module
	 * @param data data which we would like to send to another lora module
	 */
	void lora_send_data(uint16_t addr, uint8_t channel, uint8_t *data, uint8_t length);
};

#endif

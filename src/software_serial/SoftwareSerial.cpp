extern "C" {
#include <zephyr/kernel.h>
#include <zephyr/drivers/gpio.h>
}

#include <iostream>

#include "SoftwareSerial.hpp"

static void static_rx_recv_cb(const struct device *dev, struct gpio_callback *cb, uint32_t pins)
{
	// Retrieve the instance pointer from the callback data
	SoftwareSerial *instance = CONTAINER_OF(cb, SoftwareSerial, rx_cb_data);
	instance->rx_recv_cb(dev, cb, pins);
}

SoftwareSerial::SoftwareSerial(struct gpio_dt_spec *rx_dt, struct gpio_dt_spec *tx_dt)
{
	this->rx_dt = rx_dt;
	this->tx_dt = tx_dt;

	/* Config rx_dt and tx_dt */

	if (rx_dt != NULL) {
		/* Config to rx pin*/
		if (!device_is_ready(this->rx_dt->port)) {
			std::cout << "GPIO rx device not ready\n";
			return;
		}

		int ret = gpio_pin_configure_dt(this->rx_dt, GPIO_INPUT);
		if (ret < 0) {
			std::cout << "Cannot configure rx_pin, err_code: " << ret << std::endl;
			return;
		}

		ret = gpio_pin_interrupt_configure_dt(this->rx_dt, GPIO_INT_EDGE_TO_INACTIVE);
		if (ret < 0) {
			std::cout << "Cannot configure rx_pin interrupt, err_code: " << ret
				  << std::endl;
		}

		/* Init callback function */
		gpio_init_callback(&this->rx_cb_data, static_rx_recv_cb, BIT(this->rx_dt->pin));
		gpio_add_callback_dt(this->rx_dt, &this->rx_cb_data);
	}

	if (tx_dt != NULL) {
		/* Config tx pin */
		if (!device_is_ready(this->tx_dt->port)) {
			std::cout << "GPIO tx device not ready\n";
			return;
		}

		int ret = gpio_pin_configure_dt(this->tx_dt, GPIO_OUTPUT_ACTIVE);
		if (ret < 0) {
			std::cout << "Cannot configure tx_pin\n";
			return;
		}
	}

	/* Init buffer */
	this->length = 0;
	this->index = 0;
	this->buffer = new uint8_t(256);
}

void SoftwareSerial::send_bit(bool bit)
{
	if (bit) {
		gpio_pin_set_dt(this->tx_dt, 1);
	} else {
		gpio_pin_set_dt(this->tx_dt, 0);
	}
	k_busy_wait(this->uart_delay);
}

void SoftwareSerial::rx_recv_cb(const struct device *dev, struct gpio_callback *cb, uint32_t pins)
{

	gpio_pin_interrupt_configure_dt(this->rx_dt, GPIO_INT_DISABLE);
	// Wait approximately 1/2 of a bit width to "center" the sample
	if (length == 255) {
		std::cout << "Uart buffer full\n";
		k_busy_wait(this->uart_delay * 9);
	} else {
		k_busy_wait(this->uart_delay / 2);
		// Read each of the 8 bits
		uint8_t d = 0;
		for (uint8_t i = 8; i > 0; --i) {
			k_busy_wait(this->uart_delay);
			d >>= 1;
			if (gpio_pin_get_dt(this->rx_dt)) {
				d |= 0x80;
			}
		}
		this->buffer[this->length] = d;
		this->length++;
	}
	gpio_pin_interrupt_configure_dt(this->rx_dt, GPIO_INT_EDGE_TO_INACTIVE);
}

uint8_t SoftwareSerial::isAvailable()
{
	return this->length == 0 ? 0 : 1;
}

void SoftwareSerial::write(uint8_t byte)
{
	/* Start bit */
	this->send_bit(0);

	for (int i = 0; i < 8; i++) {
		bool bit = (byte >> i) & 0x01;
		this->send_bit(bit);
	}

	/* Stop bit */
	this->send_bit(1);
}

uint8_t SoftwareSerial::read()
{
	/* If buffer is empty, return 0 */
	if (this->isAvailable() == 0) {
		return 0;
	}

	uint8_t result = this->buffer[this->index];
	this->length--;
	this->index++;

	return result;
}

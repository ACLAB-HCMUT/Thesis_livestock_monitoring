#ifndef SOFTWARESERIAL_H
#define SOFTWARESERIAL_H

extern "C" {
#include <cstdint>

#include <zephyr/drivers/gpio.h>
}

class SoftwareSerial{

private:
	struct gpio_dt_spec *rx_dt;
	struct gpio_dt_spec *tx_dt;
	const uint8_t uart_delay = 104;
	uint8_t *buffer;
	uint8_t length;
	uint8_t index;
	uint8_t capacity;

	/**
	 * @brief This function will send a bit through UART by Tx pin
	 * @param bit A bit which we wanna send
	 */
	void send_bit(bool bit);

      public:
	struct gpio_callback rx_cb_data;

	/**
	 * @brief This is a callback function which will be actived when receive start bit in Rx
	 * pin. Then, it will write a byte to buffer
	 */
	void rx_recv_cb(const struct device *dev, struct gpio_callback *cb, uint32_t pins);

      public:
	/**
	 * @brief This function will create an instance of SoftwareSerial with baudrate is 9600
	 * @param rx_dt Rx pin
	 * @param tx_dt Tx pin
	 */
	SoftwareSerial(struct gpio_dt_spec *rx_dt, struct gpio_dt_spec *tx_dt);

	/**
	 * @brief Check buffer of UART exist data
	 * @return Return 1 if exist data, otherwise return 0
	 */
	uint8_t isAvailable();

	/**
	 * @brief Send a byte through UART by Tx pin
	 * @param byte a byte which we wanna send
	 */
	void write(uint8_t byte);

	/**
	 * @brief Read a byte which came to buffer nearest and remove this byte from buffer
	 * @return A byte
	 */
	uint8_t read();
};


#endif
extern "C" {
#include <zephyr/kernel.h>
#include <zephyr/drivers/gpio.h>
}

#include <iostream>
#include "global.hpp"
#include "lora.hpp"

#define MAX_BUFFER 512 /* unit: byte */
#define UART_DELAY 104 /* unit: micro second */

/* Define RX and TX pin */
struct gpio_dt_spec lora_rx_dt;
struct gpio_dt_spec lora_tx_dt;
struct gpio_callback lora_rx_cb_data;

static uint8_t buffer[MAX_BUFFER] = {0};
static uint16_t begin = 0, end = 0;


void lora_rx_falling_callback(const struct device *dev, struct gpio_callback *cb, uint32_t pins) {
    /* Disable all other external interrupt */
    gpio_pin_interrupt_configure_dt(&lora_rx_dt, GPIO_INT_DISABLE);
	// Wait approximately 1/2 of a bit width to "center" the sample
    k_busy_wait(UART_DELAY / 2);
    // Read each of the 8 bits
    uint8_t d = 0;
    for (uint8_t i = 8; i > 0; --i) {
        k_busy_wait(UART_DELAY);
        d >>= 1;
        if (gpio_pin_get_dt(&lora_rx_dt)) {
            d |= 0x80;
        }
    }
    buffer[end] = d;
    end = (end + 1) % MAX_BUFFER;
	
	gpio_pin_interrupt_configure_dt(&lora_rx_dt, GPIO_INT_EDGE_TO_INACTIVE);
}

int init_lora_serial(){
    std::cout << "init_lora_serial\n";

    const struct device *lora_rx_port = DEVICE_DT_GET(LORA_RX_PORT);
	if (!device_is_ready(lora_rx_port)) {
        std::cout << "lora_rx_port device not found or not ready\n";	
		return 1;
	}

    const struct device *lora_tx_port = DEVICE_DT_GET(LORA_TX_PORT);
	if (!device_is_ready(lora_tx_port)) {      
        std::cout << "lora_tx_port device not found or not ready\n";
		return 2;
	}

	lora_rx_dt.port = lora_rx_port;
	lora_rx_dt.pin = LORA_RX_PIN;

	lora_tx_dt.port = lora_tx_port;
	lora_tx_dt.pin = LORA_TX_PIN;

    /* Configure input for RX */
    int ret = gpio_pin_configure_dt(&lora_rx_dt, GPIO_INPUT);
    if (ret < 0) {
        std::cout << "Cannot configure lora_rx_pin, err_code: " << ret << std::endl;
        return ret;
    }

    /* Configure external interrupt with falling edge for RX */
    ret = gpio_pin_interrupt_configure_dt(&lora_rx_dt, GPIO_INT_EDGE_TO_INACTIVE);
    if (ret < 0) {
        std::cout << "Cannot configure lora_rx_pin interrupt, err_code: " << ret
                << std::endl;
        return ret;
    }
    /* Assign callback function for lora RX pin external interrupt */

    gpio_init_callback(&lora_rx_cb_data, lora_rx_falling_callback, BIT(lora_rx_dt.pin));
    gpio_add_callback_dt(&lora_rx_dt, &lora_rx_cb_data);
    
    /* Configure output for TX */
    ret = gpio_pin_configure_dt(&lora_tx_dt, GPIO_OUTPUT);
    if (ret < 0) {
        std::cout << "Cannot configure lora_tx_pin, err_code: " << ret << std::endl;
        return ret;
    }
    return 0;
}



static void send_bit(bool bit)
{
	if (bit) {
		gpio_pin_set_dt(&lora_tx_dt, 1);
	} else {
		gpio_pin_set_dt(&lora_tx_dt, 0);
	}
	k_busy_wait(UART_DELAY);
}


uint8_t lora_serial_is_available()
{
	return begin != end;
}

void lora_serial_write(uint8_t byte)
{
	/* Start bit */
	send_bit(0);

	for (uint8_t i = 0; i < 8; i++) {
		bool bit = (byte >> i) & 0x01;
		send_bit(bit);
	}

	/* Stop bit */
	send_bit(1);
}

uint8_t lora_serial_read()
{
	/* If buffer is empty, return 0 */
	if (lora_serial_is_available() == 0) {
		return 0;
	}

	uint8_t result = buffer[begin];
    begin = (begin + 1) % MAX_BUFFER;
	return result;
}

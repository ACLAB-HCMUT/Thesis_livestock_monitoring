#ifndef GLOBAL_HPP
#define GLOBAL_HPP

extern "C" {
#include <zephyr/drivers/gpio.h>
#include <cstdint>
}

enum system_status_e {
	NORMAL,
	CONFIG_ADDR,
	CONNECTED
};

#define LORA_SERIAL DT_NODELABEL(uart0)

#define LED0_NODE DT_ALIAS(led0)
#define LED1_NODE DT_ALIAS(led1)
#define LED2_NODE DT_ALIAS(led2)

#define GPIO0 DT_NODELABEL(gpio0)
#define GPIO1 DT_NODELABEL(gpio1)

#define D0_PIN 2
#define D1_PIN 3
#define D2_PIN 28
#define D3_PIN 29
#define D4_PIN 4

#define LORA_RX_PORT GPIO0
#define LORA_RX_PIN  D0_PIN
#define LORA_TX_PORT GPIO0
#define LORA_TX_PIN  D1_PIN

#define GPS_RX_PORT GPIO0
#define GPS_RX_PIN  D2_PIN
#define GPS_TX_PORT GPIO0
#define GPS_TX_PIN  D3_PIN

#define BUTTON_PORT GPIO0
#define BUTTON_PIN  D4_PIN

#define COW_ADDR_ID 1
extern enum system_status_e system_status;
extern uint16_t cow_addr;

/* This function will read cow_addr from flash memory */
int init_cow_addr();
#endif
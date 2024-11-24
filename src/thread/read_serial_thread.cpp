extern "C" {
#include <zephyr/device.h>
#include <zephyr/drivers/gpio.h>
#include <zephyr/kernel.h>
}

#include <iostream>

#include "SoftwareSerial.hpp"
#include "global.hpp"

void read_serial_entry(void *p1, void *p2, void *p3)
{
	const struct device *gpio0 = DEVICE_DT_GET(GPIO0);
	if (!device_is_ready(gpio0)) {
		std::cout << "GPIO0 device not found or not ready\n";
		return;
	}

	/**
	 * Rx: D0
	 * Tx: D1
	 * */
	struct gpio_dt_spec d0_dt;
	d0_dt.port = gpio0;
	d0_dt.pin = D0;

	struct gpio_dt_spec d1_dt;
	d1_dt.port = gpio0;
	d1_dt.pin = D1;

	SoftwareSerial *softwareSerial = new SoftwareSerial(&d0_dt, &d1_dt);

	while (1) {
		if (softwareSerial->isAvailable()) {
			while (softwareSerial->isAvailable()) {
				uint8_t byte = softwareSerial->read();
			}
		}
		k_msleep(10);
	}
}
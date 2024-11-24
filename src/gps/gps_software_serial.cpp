extern "C" {
#include <zephyr/kernel.h>
#include <zephyr/drivers/gpio.h>
}

#include <iostream>
#include "global.hpp"

#define MAX_BUFFER 1024 /* unit: byte */
#define UART_DELAY 104  /* unit: micro second */

/* Define RX and TX pin */
struct gpio_dt_spec gps_rx_dt;
struct gpio_dt_spec gps_tx_dt;
struct gpio_callback gps_rx_cb_data;

static uint8_t buffer[MAX_BUFFER] = {0};
static uint16_t begin = 0, end = 0;

void gps_rx_falling_callback(const struct device *dev, struct gpio_callback *cb, uint32_t pins)
{
	/* Disable all other external interrupt */
	gpio_pin_interrupt_configure_dt(&gps_rx_dt, GPIO_INT_DISABLE);
	// Wait approximately 1/2 of a bit width to "center" the sample
	k_busy_wait(UART_DELAY / 2);
	// Read each of the 8 bits
	uint8_t d = 0;
	for (uint8_t i = 8; i > 0; --i) {
		k_busy_wait(UART_DELAY);
		d >>= 1;
		if (gpio_pin_get_dt(&gps_rx_dt)) {
			d |= 0x80;
		}
	}
	buffer[end] = d;
	end = (end + 1) % MAX_BUFFER;

	gpio_pin_interrupt_configure_dt(&gps_rx_dt, GPIO_INT_EDGE_TO_INACTIVE);
}

int init_gps_serial()
{
	std::cout << "init_gps_serial\n";

	const struct device *gps_rx_port = DEVICE_DT_GET(GPS_RX_PORT);
	if (!device_is_ready(gps_rx_port)) {
		std::cout << "gps_rx_port device not found or not ready\n";
		return 1;
	}

	const struct device *gps_tx_port = DEVICE_DT_GET(GPS_TX_PORT);
	if (!device_is_ready(gps_tx_port)) {
		std::cout << "gps_tx_port device not found or not ready\n";
		return 2;
	}

	gps_rx_dt.port = gps_rx_port;
	gps_rx_dt.pin = GPS_RX_PIN;

	gps_tx_dt.port = gps_tx_port;
	gps_tx_dt.pin = GPS_TX_PIN;

	/* Configure input for RX */
	int ret = gpio_pin_configure_dt(&gps_rx_dt, GPIO_INPUT);
	if (ret < 0) {
		std::cout << "Cannot configure gps_rx_pin, err_code: " << ret << std::endl;
		return ret;
	}

	/* Configure external interrupt with falling edge for RX */
	ret = gpio_pin_interrupt_configure_dt(&gps_rx_dt, GPIO_INT_EDGE_TO_INACTIVE);
	if (ret < 0) {
		std::cout << "Cannot configure gps_rx_pin interrupt, err_code: " << ret
			  << std::endl;
		return ret;
	}
	/* Assign callback function for gps RX pin external interrupt */

	gpio_init_callback(&gps_rx_cb_data, gps_rx_falling_callback, BIT(gps_rx_dt.pin));
	gpio_add_callback_dt(&gps_rx_dt, &gps_rx_cb_data);

	/* Configure output for TX */
	ret = gpio_pin_configure_dt(&gps_tx_dt, GPIO_OUTPUT);
	if (ret < 0) {
		std::cout << "Cannot configure gps_tx_pin, err_code: " << ret << std::endl;
		return ret;
	}
	return 0;
}

static void send_bit(bool bit)
{
	if (bit) {
		gpio_pin_set_dt(&gps_tx_dt, 1);
	} else {
		gpio_pin_set_dt(&gps_tx_dt, 0);
	}
	k_busy_wait(UART_DELAY);
}

uint8_t gps_serial_is_available()
{
	return begin != end;
}

void gps_serial_write(uint8_t byte)
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

uint8_t gps_serial_read()
{
	/* If buffer is empty, return 0 */
	if (gps_serial_is_available() == 0) {
		return 0;
	}

	uint8_t result = buffer[begin];
	begin = (begin + 1) % MAX_BUFFER;
	return result;
}

const float epsilon = 1e-6;

float lat = 0.0;
float lng = 0.0;

uint8_t len = 0;
bool read = true;
char command[100];
#define LOCALADDRESS 0x01

bool isZero(float number)
{
	number = number > 0 ? number : -number;
	return number < epsilon;
}

// Hàm chuyển đổi định dạng NMEA sang hệ tọa độ thập phân
float convertToDecimalDegrees(char *nmeaCoord, char *direction)
{
	// NMEA: ddmm.mmmm hoặc dddmm.mmmm (với dd/ddd là độ, mm.mmmm là phút)
	int degrees;
	float minutes;
	float decimalDegrees;

	if (strlen(nmeaCoord) < 4) {
		return 0; // Kiểm tra chuỗi hợp lệ
	}

	// Chia phần độ
	char deg[4];
	strncpy(deg, nmeaCoord, (strlen(nmeaCoord) == 10) ? 2 : 3);
	deg[(strlen(nmeaCoord) == 10) ? 2 : 3] = '\0';
	degrees = atoi(deg);

	minutes = atof(nmeaCoord + ((strlen(nmeaCoord) == 10) ? 2 : 3));
	decimalDegrees = degrees + (minutes / 60.0);

	// // Xử lý hướng (N/S, E/W)
	if (direction[0] == 'S' || direction[0] == 'W') {
		decimalDegrees = -decimalDegrees;
	}
	return decimalDegrees;
}

void parseNMEA(char *nmeaData, float *latitude, float *longitude)
{
	char buffer[256];
	char lat[16], lon[16];
	char latDir, lonDir;
	char valid;

	// Copy dữ liệu vào buffer để xử lý
	strcpy(buffer, nmeaData);
    
	// Phân tích cú pháp câu $GNGGA
	strtok(buffer, ",");
	strtok(NULL, ",");

	strcpy(lat, strtok(NULL, ","));

	strcpy(&latDir, strtok(NULL, ","));

	strcpy(lon, strtok(NULL, ","));

	strcpy(&lonDir, strtok(NULL, ","));
	strcpy(&valid, strtok(NULL, ","));

	if (valid == '0') {
		*latitude = 0.0;
		*longitude = 0.0;
		return;
	}

	// Chuyển đổi tọa độ NMEA sang thập phân
	*latitude = convertToDecimalDegrees(lat, &latDir);
	*longitude = convertToDecimalDegrees(lon, &lonDir);
}

void readGPSTask()
{
	if (gps_serial_is_available()) {
		// std::cout << "x\n";
		while (gps_serial_is_available()) {
			char c = gps_serial_read();
			if (c == '$') {
                // std::cout << "$\n";
				if (len > 5) {
					// process data before $
					command[len] = '\0';
					parseNMEA(command, &lat, &lng);
				}
				// process new data after $
				len = 0;
				read = true;
				continue;
			}

			if (!read) {
				continue;
			}

			command[len++] = c;
			if (len == 5) {
				command[len] = '\0';
				read = (strcmp(command, "GNGGA") == 0) ? true : false;
			}
		}

		if (isZero(lat) && isZero(lng)) {
			/*
			 * value of gps is not valid
			 * do nothing
			 */
			std::cout << "Zero value\n";
		} else {
			//   createGPSPacket(LOCALADDRESS, lat, lng);
			std::cout << lat << ", " << lng << std::endl;
		}

	} else {
		std::cout << "GPS is not available\n";
	}
}
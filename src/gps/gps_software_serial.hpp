#ifndef GPS_SOFTWARE_SERIAL_HPP
#define GPS_SOFTWARE_SERIAL_HPP

extern "C" {
#include <cstdint>
}
/**
 * This function use to init software serial for gps 
 * Rx = `GPS_RX_PIN`, Tx = `GPS_TX_PIN`
*/
int init_gps_serial();

/**
 * This function will check serial buffer is valid or not
 * @return Return 1 if buffer has data, otherwise return 0
 */
uint8_t gps_serial_is_available();

/**
 * This function will read data from gps serial buffer
 * @return A byte from buffer
 */
uint8_t gps_serial_read();
#endif
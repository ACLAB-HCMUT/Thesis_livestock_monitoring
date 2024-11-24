#ifndef GPS_SOFTWARE_SERIAL_HPP
#define GPS_SOFTWARE_SERIAL_HPP

extern "C" {
#include <cstdint>
}
extern float lat, lng;

int init_gps_serial();
uint8_t gps_serial_is_available();
void gps_serial_write(uint8_t byte);
uint8_t gps_serial_read();
void readGPSTask();
#endif
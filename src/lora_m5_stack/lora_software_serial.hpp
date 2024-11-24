#ifndef LORA_SOFTWARE_SERIAL_HPP
#define LORA_SOFTWARE_SERIAL_HPP

extern "C" {
#include <cstdint>
}

int init_lora_serial();
uint8_t lora_serial_is_available();
void lora_serial_write(uint8_t byte);
uint8_t lora_serial_read();

#endif
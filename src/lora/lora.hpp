#ifndef LORA_HPP
#define LORA_HPP
extern "C"{
#include<cstdint>
}

/**
 * This function use to init hardware serial as well as config it
 * @return Return 0 if success, otherwise return error code
 */
int init_lora();

/**
 * Write `data` which has `length` byte to lora serial
 * @param data Data which we want to send to lora serial
 * @param length Number of elements of `data`
 */
void lora_write(uint8_t* data, int length);

/**
 * Read a byte from lora serial
 * @param data a byte will be stored to `data` variable
 * @return Return 0 if success, otherwise return error code
 */
int lora_read(uint8_t* data);

/**
 * This function user to handle message from lora serial
 * @param message Message we received from lora serial
 * @param length Number of byte in `message`
 */
void handle_lora_message(uint8_t* message, uint8_t length);

#endif
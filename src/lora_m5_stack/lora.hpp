#ifndef LORA_HPP
#define LORA_HPP
extern "C"{
#include<cstdint>
}

int init_lora();
void lora_write(uint8_t byte);
int lora_read(uint8_t* data);
void handle_lora_message(uint8_t* message, uint8_t length);

#endif
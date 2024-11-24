#ifndef BLE_H
#define BLE_H
#include <stdint.h>

extern uint16_t cow_addr;

/* This function will init bluetooth low energy */
int enable_ble();

/* This function will disable bluetooth low energy */
int disable_ble();

#endif
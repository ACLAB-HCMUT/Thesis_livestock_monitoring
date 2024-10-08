#include <SPI.h>
#include <LoRa.h>
#include <TinyGPSPlus.h>
#include <SoftwareSerial.h>
#include <Arduino_FreeRTOS.h>
#include <Arduino.h>

#define GPS             0
#define Acceleration    1

#define localAddress    0x01
#define gatewayAddress  0xBB    
#define broadcast       0xFF      

#define gpsPacketSize       12
#define start_idx           0
#define targetAddress_idx   1
#define opcode_idx          2
#define lat_idx             3            
#define lng_idx             7
#define end_idx             11

/* declare Software Serial pin*/
const byte rxPin = 3;
const byte txPin = 4;

/* Lora Configuration */
const long frequency = 915E6; // LoRa Frequency
const uint8_t csPin = 10;     // LoRa radio chip select
const uint8_t resetPin = 9;   // LoRa radio reset
const uint8_t irqPin = 2;     // change for your board; must be a hardware interrupt pin

/* declare GPS packet */
byte gpsPacket[gpsPacketSize];

/* declare Software UART */
SoftwareSerial mySerial(rxPin, txPin);

/* declare GPS */
TinyGPSPlus gps;

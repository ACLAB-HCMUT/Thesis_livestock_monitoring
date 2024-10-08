#include <global.h>


int count = 0; 
/* ---------------------------HELPER FUNCTION------------------------------------ */
void LoRa_rxMode()
{
  LoRa.enableInvertIQ(); // active invert I and Q signals
  LoRa.receive();        // set receive mode
}

void LoRa_txMode()
{
  LoRa.idle();            // set standby mode
  LoRa.disableInvertIQ(); // normal mode
}

void createGPSPacket(byte destination, float lat, float lng){
  gpsPacket[start_idx] = 's';
  gpsPacket[targetAddress_idx] = destination;
  gpsPacket[opcode_idx] = GPS;
  memcpy(gpsPacket + lat_idx, &lat, 4);
  memcpy(gpsPacket + lng_idx, &lng, 4);
  gpsPacket[end_idx] = 'e';
}

/* ---------------------------SCHEDULER TASK------------------------------ */
void taskLoraSendGPS(void *pvParameters)
{
  (void)pvParameters;
  while (true)
  {
    LoRa_txMode();
    // wrong address packet
    LoRa.beginPacket();
    LoRa.write(count++);
    gpsPacket[targetAddress_idx] = 0xAA;
    LoRa.write(gpsPacket, gpsPacketSize);
    LoRa.endPacket(true);
    Serial.println("Send Wrong packet");

    // true packet
    LoRa.beginPacket();
    LoRa.write(count++);
    LoRa.write(gpsPacket, gpsPacketSize);
    LoRa.endPacket(true);
    Serial.println("Send true packet");
    vTaskDelay(2500 / portTICK_PERIOD_MS);
  }
}

void taskReadGPS(void *pvParameters)
{
  (void)pvParameters;
  // loop
  while (true)
  {
    if(mySerial.available()){
      while (mySerial.available())
      {
        gps.encode(mySerial.read());
      }
      if(gps.location.lat() != 0.0){
        Serial.println(gps.location.lat(), 5); 
      }
    }
    else{
      Serial.println("GPS is not available");
    }

    createGPSPacket(gatewayAddress, gps.location.lat(), gps.location.lng());
    vTaskDelay(2000 / portTICK_PERIOD_MS);
  }
}

/* ---------------------------CALLBACK FUNCTION--------------------------- */
void onReceive(int packetSize)
{
  String message = "";

  while (LoRa.available())
  {
    message += (char)LoRa.read();
  }

  Serial.print("Node Receive: ");
  Serial.println(message);
}

void onTxDone()
{
  Serial.println("TxDone");
  LoRa_rxMode();
}

/* ---------------------------MAIN FUNCTION------------------------------ */

void setup(){
  // initialize hardware serial
  Serial.begin(9600);
  while (!Serial);

  // initialize software serial
  mySerial.begin(9600);
  while (!mySerial);

  // config lora
  LoRa.setPins(csPin, resetPin, irqPin);

  if (!LoRa.begin(frequency))
  {
    Serial.println("LoRa init failed. Check your connections.");
    while (true)
      ;
  }

  xTaskCreate(taskReadGPS, "taskReadGPS", 80, NULL, 1, NULL);
  xTaskCreate(taskLoraSendGPS, "taskLoraSendGPS", 80, NULL, 1, NULL);

  Serial.println("LoRa init succeeded.");
  Serial.println("LoRa Simple Node");
  // Serial.println("Only receive messages from gateways");
  // Serial.println("Tx: invertIQ disable");
  // Serial.println("Rx: invertIQ enable");
  // Serial.println();

  // callback function
  LoRa.onReceive(onReceive);
  LoRa.onTxDone(onTxDone);

  // Init mode receiver for lora
  LoRa_rxMode();
}

void loop(){}
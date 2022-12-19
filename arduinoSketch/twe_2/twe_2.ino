#include <SoftwareSerial.h>
SoftwareSerial TWE(3, 2); // RX, TX
#define LED 13
#define DATA_SIZE 15

void setup() {
  TWE.begin(115200);
  Serial.begin(115200);
  pinMode(LED, OUTPUT);
  byte DATA[DATA_SIZE] = {':', '7', '8', '0', '1', '3', '5', 'X', 'l','f'};
  digitalWrite(LED, HIGH);
  for (byte i = 0 ; i < DATA_SIZE ; i++) TWE.write(DATA[i]);
}
void loop() {
  uint8_t recv [60] = {};
  byte count     = 0;
  //receive data  
  digitalWrite(LED, HIGH);
  while (TWE.available()){
    recv [count] = TWE.read();
    count++;
  }
  
    for (byte i = 0 ; i < count ; i++) Serial.print((char)(recv[i]));

    byte DATA[DATA_SIZE] = {'h', 'h', '7', '8', '0', '1', '3', '5', 'X', 'e', 'e', 'l','f','\n'};
    digitalWrite(LED, HIGH);
    for (byte i = 0 ; i < DATA_SIZE ; i++) TWE.write(DATA[i]);
    delay(1000);
}

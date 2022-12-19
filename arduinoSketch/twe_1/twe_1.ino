#include <SoftwareSerial.h>
SoftwareSerial TWE(5, 6); // RX, TX
#define LED 13
void setup() {
TWE.begin(38400);
pinMode(13, OUTPUT);
}
void loop() {
#define DATA_SIZE 10
byte DATA[DATA_SIZE] = {':', '7', '8', '0', '1', '3', '5', 'X', '\r', '\n'};
digitalWrite(LED, HIGH);
for (byte i = 0 ; i < DATA_SIZE ; i++) TWE.write(DATA[i]);
delay(300);
digitalWrite(LED, LOW);
delay(300);
}

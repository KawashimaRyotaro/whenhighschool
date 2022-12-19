#include <SoftwareSerial.h>
SoftwareSerial TWE(3, 2); // RX, TX
#define LED 13
#define DATA_SIZE 9
 
byte recv [60] = {};
byte t=0;

void setup() {
  TWE.begin(115200);
  Serial.begin(115200);
}

void loop() {
  byte j=0;
  byte count=0;
  //receive data  
  while (TWE.available()){
    recv[j]=TWE.read();
    j++;
  }

  if(j==9&&(recv[6]==0x82||recv[7]==0x82)){
    for(byte i=0;i<j;i++)Serial.print(String(i)+":"+recv[i]+" ");
    Serial.println(":"+String(j));
    
    byte DATA[DATA_SIZE] = {0, 0, 0, 0, t, t, 0x83, 0x83, 0x65};
    for (byte i = 0 ; i < DATA_SIZE ; i++) TWE.write(DATA[i]);
    Serial.println("sended.....");
  }
}

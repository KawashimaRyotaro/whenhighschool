#include <SoftwareSerial.h>
SoftwareSerial TWE(3, 2); // RX, TX
#define DATA_SIZE 11
  
byte recv [60] = {};
byte t=0;
byte lqi[3]={0,0,0};
byte LQI=0;


void setup() {
  TWE.begin(115200);
  Serial.begin(115200);
}

void loop() {
  byte j=0;
  byte m=0;
  byte count=0;
  //receive data  
  while (TWE.available()){
    recv[j]=TWE.read();
    j++;
    m++;
  }
  
  if(m>0){
    for(byte i=0;i<j;i++)Serial.print(String(i)+":"+recv[i]+" ");
    Serial.println(":"+String(j));
  }
  
  if(j==9&&(recv[6]==0x83||recv[7]==0x83)){
    delay(10);
    LQI=recv[1];
    byte DATA[DATA_SIZE] = {0, 0, 0, 0, LQI, LQI, t, t, 0x84, 0x84, 0x65};
    for (byte i = 0 ; i < DATA_SIZE ; i++) TWE.write(DATA[i]); 
    Serial.println("Sended.....");
  }
  
}

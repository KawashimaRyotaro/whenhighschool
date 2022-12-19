#include <SoftwareSerial.h>
SoftwareSerial TWE(3, 2); // RX, TX
#define DATA_SIZE 9

byte t=0x00;
byte LQI_3=0;
byte LQI_2=0;
byte LQI_1=0;
byte recv[60]={};
byte count=0;
int a=0;

void setup() {
  TWE.begin(115200);
  Serial.begin(115200);
  byte DATA[DATA_SIZE] = {0, 0, 0, 0, t, t, 0x82, 0x82, 0x65};
  for (byte i = 0 ; i < DATA_SIZE ; i++) TWE.write(DATA[i]);
}
void loop() {
  if(count==0x05){
    byte DATA[DATA_SIZE] = { 0, 0, 0, 0, t, t, 0x82, 0x82, 0x65};
    for (byte i = 0 ; i < DATA_SIZE ; i++) TWE.write(DATA[i]);
    count=0;
    //Serial.println("1919");
  }

  int m=0;
  byte j = 0;
  //receive data  
  while (TWE.available()){
    recv [j] = TWE.read();
    j++;
    m++;
    count=0;
  }
  
  if(m>0){
   //for(byte i=0;i<j;i++)Serial.print(String(i)+":"+recv[i]+" ");
   //Serial.println(":"+String(j));
  }  

  if(j==9&&(recv[6]==0x83||recv[7]==0x83)){
    LQI_1=recv[1];
    LQI_2=recv[4];
  }
  
  if(j==11&&(recv[8]==0x84||recv[9]==0x84)){
    LQI_2=recv[1];
    LQI_3=recv[4];
    byte DATA[DATA_SIZE] = {0, 0, 0, 0, t, t, 0x82, 0x82, 0x65};
    for (byte i = 0 ; i < DATA_SIZE ; i++) TWE.write(DATA[i]);
   // Serial.println("lqi_1:"+String(LQI_1)+"  lqi_2:"+String(LQI_2)+" lqi_3:"+String(LQI_3));
  }
  if(a==25){
    byte Data[5] = {0x01, LQI_1, LQI_2, LQI_3, 0x03};
    //for(byte i=0;i<5;i++)Serial.print(String(i)+":"+Data[i]+" ");
    //Serial.println();
    //for(byte i=0;i<5;i++)Serial.write(Data[i]);
    a=0;
  }
  Serial.println(String(LQI_1)+","+String(LQI_2)+","+String(LQI_3));
  delay(5);
  count++;
  a++;
}

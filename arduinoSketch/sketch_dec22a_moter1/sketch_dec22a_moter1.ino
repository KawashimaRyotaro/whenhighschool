#include <Wire.h>
int16_t axRaw, ayRaw, azRaw, gxRaw, gyRaw, gzRaw, temperature;
float  ax, ay, az, gx, gy, gz;
/*----------------------------------------------------------------------------------------------------------------*/
int val=0;
int val1=0,val2=0;
void setup() {
/*----------------------------------------------------------------------------------------------------------------*/
  Serial.begin(57600);
  Wire.begin();
  TWBR = 12;
  Wire.beginTransmission(0x68);
  Wire.write(0x6B);
  Wire.write(0x00);
  Wire.endTransmission();
  Wire.beginTransmission(0x68);
  Wire.write(0x1C);
  Wire.write(0x10);
  Wire.endTransmission();
  Wire.beginTransmission(0x68);
  Wire.write(0x1B);
  Wire.write(0x08);
  Wire.endTransmission();
  Wire.beginTransmission(0x68);
  Wire.write(0x1A);
  Wire.write(0x05);
  Wire.endTransmission();
/*----------------------------------------------------------------------------------------------------------------*/
  pinMode(13,OUTPUT);
  pinMode(12,OUTPUT);
}

void loop() {
/*----------------------------------------------------------------------------------------------------------------*/
  Wire.beginTransmission(0x68);
  Wire.write(0x3B);
  Wire.endTransmission();
  Wire.requestFrom(0x68, 14);
  while (Wire.available() < 14);
  axRaw = Wire.read() << 8 | Wire.read();
  ayRaw = Wire.read() << 8 | Wire.read();
  azRaw = Wire.read() << 8 | Wire.read();
  temperature = Wire.read() << 8 | Wire.read();
  gxRaw = Wire.read() << 8 | Wire.read();
  gyRaw = Wire.read() << 8 | Wire.read();
  gzRaw = Wire.read() << 8 | Wire.read();

  ax = axRaw / 4096.0;
  ay = ayRaw / 4096.0;
  az = azRaw / 4096.0;
  gx = gxRaw / 65.5;
  gy = gyRaw / 65.5;
  gz = gzRaw / 65.5;

  if (Serial.available() == 1) {
    byte inBuf[1];
    Serial.readBytes(inBuf, 1);
    if (inBuf[0] == 's') {
      byte outBuf[14];
      outBuf[0]  = 's';                        // 1
      outBuf[1]  = (int16_t)(gx * 100) >> 8;   // 2
      outBuf[2]  = (int16_t)(gx * 100) & 0xFF; // 3
      outBuf[3]  = (int16_t)(gy * 100) >> 8;   // 4
      outBuf[4]  = (int16_t)(gy * 100) & 0xFF; // 5
      outBuf[5]  = (int16_t)(gz * 100) >> 8;   // 6
      outBuf[6]  = (int16_t)(gz * 100) & 0xFF; // 7
      outBuf[7]  = (int16_t)(ax * 100) >> 8;   // 8
      outBuf[8]  = (int16_t)(ax * 100) & 0xFF; // 9
      outBuf[9]  = (int16_t)(ay * 100) >> 8;   // 10
      outBuf[10] = (int16_t)(ay * 100) & 0xFF; // 11
      outBuf[11] = (int16_t)(az * 100) >> 8;   // 12
      outBuf[12] = (int16_t)(az * 100) & 0xFF; // 13
      outBuf[13]  = 'e';                       // 14
      Serial.write(outBuf, 14);
    }
    else {
      while (Serial.available() > 0)Serial.read();
    }
  }
  if (Serial.available() > 1) {
    while (Serial.available() > 0)Serial.read();
  }
/*----------------------------------------------------------------------------------------------------------------*/
  val=analogRead(A0);
  val1=map(val,480,1023,0,40);
  val2=40.00-val1;
  if(val1<0){
    val1=0;
  }else if(val2<0){
    val2=0;
  }
  digitalWrite(13,HIGH);
  digitalWrite(12,HIGH);
  delay(val1);
  digitalWrite(13,LOW);
  digitalWrite(12,LOW);
  delay(val2); 
}

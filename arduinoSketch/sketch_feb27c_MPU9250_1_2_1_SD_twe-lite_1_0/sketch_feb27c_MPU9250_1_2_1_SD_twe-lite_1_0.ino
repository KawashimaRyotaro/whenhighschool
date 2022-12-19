#include <Wire.h>
#include <MadgwickAHRS.h>
#include <SPI.h>
#include <SD.h>
#include <SoftwareSerial.h>
Madgwick MadgwickFilter;
SoftwareSerial TWE(5, 6);

volatile uint8_t accGyroTempData[14];
volatile uint8_t magneticData[7];
volatile uint8_t ST1Bit;

volatile int16_t ax = 0;
volatile int16_t ay = 0;
volatile int16_t az = 0;

volatile int16_t mx = 0;
volatile int16_t my = 0;
volatile int16_t mz = 0;

volatile float accX = 0;
volatile float accY = 0;
volatile float accZ = 0;

volatile float gyroX = 0;
volatile float gyroY = 0;
volatile float gyroZ = 0;

volatile float magX = 0;
volatile float magY = 0;
volatile float magZ = 0;

float gx1, gy1, gz1, ax1, ay1, az1, magX1, magY1, magZ1, magX2, magY2, magZ2;

int n=1;
int m=0;

void setup() {
  TWE.begin(38400);
  Wire.begin();
  Serial.begin(57600);
  MadgwickFilter.begin(25);

  while (!Serial) {
    ; 
  }

  pinMode(10, OUTPUT);
 
  if (!SD.begin(10)) {
    return;
  }

  i2cWriteByte(0x68, 0x6b, 0x00);

  i2cWriteByte(0x68, 0x1c, 0x18);

  i2cWriteByte(0x68, 0x1b, 0x18);
  
  i2cWriteByte(0x68, 0x37, 0x02);
  i2cWriteByte(0x0c, 0x0a, 0x16);
}

void loop() {
  char recv = 0;
    String a="";
    int b=0;
    while (TWE.available())
    {
        recv = TWE.read();
        a+=recv;
        b=a.length();
        if(b==49){
            Serial.println(a+" , "+b);
        }
    }
  
  MPU9250();

  MadgwickFilter.update(gx1, gy1, gz1, ax1, ay1, az1, magX1, magY1, magZ1);

  float ROLL  = MadgwickFilter.getRoll();
  float PITCH = MadgwickFilter.getPitch();
  float YAW   = MadgwickFilter.getYaw();

  String dataString = "s:";

  dataString+=String(ROLL)+","+String(PITCH)+","+String(magX1)+","+String(magY1)+","+String(magZ1)+":e";
 
  File dataFile = SD.open("datalog"+String(n)+".txt", FILE_WRITE);
 
  if (dataFile) {
    dataFile.println(dataString);
    dataFile.close();
    Serial.println(dataString);
  }else {
  Serial.println("error opening datalog.txt");
  }
  
  m++;

}



void MPU9250() {

  i2cRead(0x68, 0x3b, 14, accGyroTempData);

  i2cRead(0x0c, 0x02, 1, &ST1Bit);

  if ((ST1Bit & 0x01)) {

    i2cRead(0x0c, 0x03, 7, magneticData);

  }

  ax = (accGyroTempData[0] << 8) | accGyroTempData[1];
  ay = (accGyroTempData[2] << 8) | accGyroTempData[3];
  az = (accGyroTempData[4] << 8) | accGyroTempData[5];
  ax = ax * 16 / 327.68;
  ay = ay * 16 / 327.68;
  az = az * 16 / 327.68;
  ax1=(float)ax+0.5;
  ay1=(float)ay-0.5;
  az1=(float)az-0.5;

  ax = (accGyroTempData[8] << 8) | accGyroTempData[9];
  ay = (accGyroTempData[10] << 8) | accGyroTempData[11];
  az = (accGyroTempData[12] << 8) | accGyroTempData[13];
  ax = ax * 2000 / 32768.0;
  ay = ay * 2000 / 32768.0;
  az = az * 2000 / 32768.0;
  gx1=(float)ax+0.98;
  gy1=(float)ay-1+0.01;
  gz1=(float)az+0.49;

  mx = (magneticData[3] << 8) | magneticData[2];
  my = (magneticData[1] << 8) | magneticData[0];
  mz = -((magneticData[5] << 8) | magneticData[4]);

  mx = mx / 32768.0f * 4800.0f;
  my = my / 32768.0f * 4800.0f;
  mz = mz / 32768.0f * 4800.0f;
  
    magX2 = ((float)mx-6.5)/37.5*112/3;

    magY2 = ((float)my-9.5)/35.5*112/3;

    magZ2 = ((float)mz-30)/39*112/3;

    magX1 = (float)(mx + 344.0f) / 32768.0f * 4921.0f * 10.0f;

    magY1 = (float)(my - 234.0f) / 32768.0f * 4921.0f * 10.0f;

    magZ1 = (float)(mz - 410.0f) / 32768.0f * 4921.0f * 10.0f;

}



void i2cRead(uint8_t Address, uint8_t Register, uint8_t NBytes, volatile uint8_t* Data) {

  Wire.beginTransmission(Address);
  Wire.write(Register);
  Wire.endTransmission();

  Wire.requestFrom(Address, NBytes);
  uint8_t index = 0;
  
  while (Wire.available()) {
    Data[index++] = Wire.read();
  }
}

void i2cWriteByte(uint8_t Address, uint8_t Register, volatile uint8_t Data) {
  
  Wire.beginTransmission(Address);
  Wire.write(Register);
  Wire.write(Data);
  Wire.endTransmission();

}

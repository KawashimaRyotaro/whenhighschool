#include "Wire.h"
int16_t mx, my, mz;

void setup() {
  Wire.begin();
  TWBR = 24;
  Serial.begin(115200);
  setupMPU9255();
}

void loop() {
  readCompass();
  Serial.print(mx); Serial.print(",");
  Serial.print(my); Serial.print(",");
  Serial.println(mz);
  delay(10);
}

void readCompass() {
  Wire.beginTransmission(0x0C);
  Wire.write(0x02);
  Wire.endTransmission();
  Wire.requestFrom(0x0C, 1);

  uint8_t ST1 = Wire.read();
  if (ST1 & 0x01) {
    Wire.beginTransmission(0x0C);
    Wire.write(0x03);
    Wire.endTransmission();
    Wire.requestFrom(0x0C, 7);
    uint8_t i = 0;
    uint8_t buf[7];
    while (Wire.available()) {
      buf[i++] = Wire.read();
    }
    if (!(buf[6] & 0x08)) {
      mx = ((int16_t)buf[1] << 8) | buf[0];
      my = ((int16_t)buf[3] << 8) | buf[2];
      mz = ((int16_t)buf[5] << 8) | buf[4];
    }
  }
}

void setupMPU9255() {
  Wire.beginTransmission(0x68);
  Wire.write(0x6B);
  Wire.write(0x00);
  Wire.endTransmission();

  Wire.beginTransmission(0x68);
  Wire.write(0x1A);
  Wire.write(0x05);
  Wire.endTransmission();

  Wire.beginTransmission(0x68);
  Wire.write(0x37);
  Wire.write(0x02);
  Wire.endTransmission();

  Wire.beginTransmission(0x0C);
  Wire.write(0x0A);
  Wire.write(0x16);
  Wire.endTransmission();
  delay(500);
}

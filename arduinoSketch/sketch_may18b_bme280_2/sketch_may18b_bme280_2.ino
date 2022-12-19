
#include "SparkFunBME280.h"
#include "Wire.h"
#include "SPI.h"

BME280 Sensor;

void setup() {
  Serial.begin(115200);
  while (!Serial);

  Sensor.settings.commInterface = I2C_MODE; 
  Sensor.settings.I2CAddress = 0x77;
  Sensor.settings.runMode = 3; 
  Sensor.settings.tStandby = 0;
  Sensor.settings.filter = 0;
  Sensor.settings.tempOverSample = 1 ;
  Sensor.settings.pressOverSample = 1;
  Sensor.settings.humidOverSample = 1;

  Serial.println("Starting BME280... ");
  delay(10);
  Sensor.begin();
}

void loop() {
  Serial.print("Temperature: ");
  Serial.print(Sensor.readTempC(), 2);
//  Serial.print(" ");
//  Serial.print((char)223);
//  Serial.print("C");
  Serial.print(" ℃");
  Serial.print("\t Pressure: ");
  Serial.print(Sensor.readFloatPressure() / 100, 2);
  Serial.print(" hPa");
  Serial.print("\t Humidity: ");
  Serial.print(Sensor.readFloatHumidity(), 2);
  Serial.println(" %");
  delay(1000);
}

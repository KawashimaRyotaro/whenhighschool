#include <Servo.h>
Servo myservo;
int sensorValue=0;
int outputValue=0;
void setup() {
  myservo.attach(9);
  myservo.attach(10);
  Serial.begin(9600);
}

void loop() {
  sensorValue=analogRead(A0);
  outputValue=map(sensorValue,460,1023,0,180);
  if(outputValue<0){
    outputValue=0;
  }
  myservo.write(outputValue);
  Serial.print("sensor=");
  Serial.print(sensorValue);
  Serial.print("\t output=");
  Serial.println(outputValue);
  delay(100);
}

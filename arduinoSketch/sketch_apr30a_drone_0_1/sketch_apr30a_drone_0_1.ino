#include <Servo.h>//ESCをコントロールするためのライブラリを追加
Servo esc;
float n=20;
void setup()
{
Serial.begin(9600);
pinMode(0,OUTPUT);
pinMode(1,OUTPUT);
pinMode(2,OUTPUT);
pinMode(3,OUTPUT);
pinMode(5,OUTPUT);
pinMode(9,OUTPUT);
}
void loop()
{
digitalWrite(0,HIGH);
digitalWrite(1,LOW);
digitalWrite(2,LOW);
digitalWrite(3,HIGH);
digitalWrite(5,LOW);
digitalWrite(9,LOW);
delay(n);
digitalWrite(0,LOW);
digitalWrite(1,HIGH);
digitalWrite(2,LOW);
digitalWrite(3,LOW);
digitalWrite(5,HIGH);
digitalWrite(9,LOW);
delay(n);
digitalWrite(0,LOW);
digitalWrite(1,LOW);
digitalWrite(2,HIGH);
digitalWrite(3,LOW);
digitalWrite(5,LOW);
digitalWrite(9,HIGH);
delay(n);
/*m+=0.1;
n+=m;
if(n>=100){
  n=0;
  m=0;
}
Serial.println(m);*/
}

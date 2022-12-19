#include <Servo.h>//ESCをコントロールするためのライブラリを追加
Servo esc1;
Servo esc2;
Servo esc3;
Servo esc4;
int m=0,n=1000;
int b=1000;
void setup()
{
pinMode(A0, INPUT);        // A0ピンを入力に指定
Serial.begin(9600);
esc1.attach(3);
esc1.writeMicroseconds(1000);
esc2.attach(5);
esc2.writeMicroseconds(1000);
esc3.attach(6);
esc3.writeMicroseconds(1000);
esc4.attach(9);
esc4.writeMicroseconds(1000);
Serial.begin(9600);
delay(1000);
}
void loop()
{
esc1.writeMicroseconds(n);
esc2.writeMicroseconds(n);
esc3.writeMicroseconds(n);
esc4.writeMicroseconds(n);
m++;
n+=m/b;
if(n>=1500){
  n=1000;
  m=0;
}
delay(10);
}

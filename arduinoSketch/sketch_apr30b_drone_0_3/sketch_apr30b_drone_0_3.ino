#include <Servo.h>//ESCをコントロールするためのライブラリを追加
Servo esc1;
Servo esc2;
Servo esc3;
Servo esc4;
int m=0,n=1000,n1=1000;
int a=0;
int tm=0;
void setup()
{
  pinMode(A0, INPUT);        // A0ピンを入力に指定
  pinMode(13,INPUT);
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
  tm++;
  if(digitalRead(13)==LOW){
    a++;
    if(a>=2){
      a=0;
    }
    while(digitalRead(13)==LOW){
      Serial.println(a);
      Serial.print(n1);     // vol_valに代入された値をPCへシリアルプリント
      Serial.print(n);     // vol_valに代入された値をPCへシリアルプリント]
      Serial.println();
    }
  }
  Serial.println(a);
  m = analogRead(A0);  // 変数vol_valにアナログ読み取りしたA0ピンの値を代入
  n=map(m,0,1023,1000,2000);
  if(n<=1100){
    n=1000;
  }
  Serial.print(n1);     // vol_valに代入された値をPCへシリアルプリント
  Serial.print(n);     // vol_valに代入された値をPCへシリアルプリント
  Serial.println();
  if(a==0){
    if(n1<n){
    n1++;
    }else if(n1==n){
      n1=n;
    }else if(n1>n){
      n1--;
    }
    esc1.writeMicroseconds(n1);
    esc2.writeMicroseconds(n1);
    esc3.writeMicroseconds(n1);
    esc4.writeMicroseconds(n1);
  }else{
    n1=1000;
    esc1.writeMicroseconds(1000);
    esc2.writeMicroseconds(1000);
    esc3.writeMicroseconds(1000);
    esc4.writeMicroseconds(1000);
  }
}

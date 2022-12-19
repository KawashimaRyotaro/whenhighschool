#include <LiquidCrystal_I2C.h>
#include <SoftwareSerial.h>

SoftwareSerial TWE(5, 6); // RX, TX

LiquidCrystal_I2C lcd(0x3f,16,2);

String LQI="FF";
int lqi=0;

void setup() {
  TWE.begin(38400);
  Serial.begin(38400);
  pinMode(3, OUTPUT);
  pinMode(9, OUTPUT);
}

void loop(){
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
            moniter(a);
        }
    }
}

void moniter(String a){
    int b=0;
    b=a.length();
    if(b==49){
        String AID=String(a.substring(1,3));
        String COM=String(a.substring(3,5));
        LQI=String(a.substring(9,11));
        lqi=toDEC(LQI);
        String NAM=String(a.substring(11,19));
        String BID=String(a.substring(19,21));
        String TIM=String(a.substring(21,25));
        String VAL=String(a.substring(25,29));
        String DIG1=String(a.substring(33,35));
        String DIG2=String(a.substring(35,37));
        String A1=String(a.substring(37,39));
        String A2=String(a.substring(39,41));
        String A3=String(a.substring(41,43));
        String A4=String(a.substring(43,45));
    }else{
        Serial.println(a+"It's a String that can't be expressed.");
    }
    lcd.init(); 
  lcd.backlight();
  lcd.setCursor(10, 0);
  lcd.print(String(lqi)+":"+LQI);
  analogWrite(3,lqi/100);
  analogWrite(9,lqi/100);
}

int toDEC(String a){
  String a1;
  String a2;
  int b,c;
  int aa;
  a1=a.substring(0,1);
  a2=a.substring(1,2);
  b=judge(a1);
  c=judge(a2);
  aa=c+16*b;
  return aa;
}

int judge(String k){
  int l;
  if(k.equals("A")){
    l=10;
  }else if(k.equals("B")){
    l=11;
  }else if(k.equals("C")){
    l=12;
  }else if(k.equals("D")){
    l=13;
  }else if(k.equals("E")){
    l=14;
  }else if(k.equals("F")){
    l=15;
  }else{
    l=k.toInt();
  }
  return l;
}

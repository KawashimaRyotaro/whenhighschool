#include <LiquidCrystal_I2C.h>
#include <SoftwareSerial.h>
#define LED 13

SoftwareSerial TWE(5, 6); // RX, TX

LiquidCrystal_I2C lcd(0x3f,16,2);
float lqi;

String LQI;

void setup() {
  TWE.begin(38400);
  Serial.begin(38400);
  pinMode(LED, OUTPUT);
}

void loop(){
  char recv = 0;
    String a="";
    int b=0;
    while (TWE.available())
    {
        digitalWrite(LED, HIGH);
        recv = TWE.read();
        a+=recv;
        b=a.length();
        if(b==49){
            moniter(a);
        }
    }
    digitalWrite(LED,HIGH);
}

void moniter(String a){
    int b=0;
    b=a.length();
    if(b==49){
        String AID=String(a.substring(1,3));
        String COM=String(a.substring(3,5));
        LQI=String(a.substring(9,11));
        lqi=LQI.toFloat();
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
    }
    lcd.init(); 
  lcd.backlight();
  lcd.setCursor(0, 0);
  lcd.print(lqi);
}

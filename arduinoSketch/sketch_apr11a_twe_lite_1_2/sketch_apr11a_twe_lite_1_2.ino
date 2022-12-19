#include <SoftwareSerial.h>
#define LED 13

SoftwareSerial TWE(5, 6); // RX, TX

void setup() {
    TWE.begin(38400);
    Serial.begin(38400);
    pinMode(LED, OUTPUT);
}

void loop() {
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
            Serial.println(a+" , "+b);
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
        String LQI=String(a.substring(9,11));
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
        Serial.println("\t送信元の論理デバイスID:"+AID);
        Serial.println("\tコマンド:"+COM);
        Serial.println("\tLQI値:"+LQI);
        Serial.println("\t送信元の個体識別番号:"+NAM);
        Serial.println("\t宛先の論理デバイスID:"+BID);
        Serial.println("\tタイムスタンプ:"+TIM);
        Serial.println("\t電源電圧[mV]:"+VAL);
        Serial.println("\tDI の状態ビット:"+DIG1);
        Serial.println("\tDI の変更状態ビット:"+DIG2);
        Serial.println("\tAD1の変換値:"+A1);
        Serial.println("\tAD2の変換値:"+A2);
        Serial.println("\tAD3の変換値:"+A3);
        Serial.println("\tAD4の変換値:"+A4);
    }else{
        Serial.println(a+"It's a String that can't be expressed.");
    }
}

#include <SoftwareSerial.h>
const int A_0= 0;
const int inc = 13;
const int ud = 12;
const int cs = 11;
const int t=10;
int i=0;
int lqi;
double f=0;
double g=0;
float px=0;
float cr=0;
float crr=0;
float K=1;
String LQI;
String w1="";
String w2="";
String ccr="";


SoftwareSerial TWE(5, 6); // RX, TX

void setup() {
    TWE.begin(38400);
    Serial.begin(38400);
    initialise();
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
            LQI=String(a.substring(9,11));
            Serial.print("LQI:");
            Serial.println(LQI);
            lqi=todec(LQI);
            cr=map(lqi,0,255,1,300);
            Serial.print("cr:");
            Serial.println(cr);
            crr=cr/100;
            ccr=toHEX(cr);
            Serial.print("cr:");
            Serial.println(ccr);    
            changeCurrent(crr);
        }
    }
    delay(1);
}



/*______________________________________________________________________________________*/

int todec(String hex){
  if(hex.length()==2){
    String d=String(hex.substring(0,1));
    int d1=f_1(d);
    String n=String(hex.substring(1,2));
    int n1=f_1(n);
    int num=d1*16+n1;
    return num;
  }
  return 0;
}

int f_1(String val){
  int v;
  if(val.equals("0")){
    v=0;
    return v;
  }else if(val.equals("1")){
    v=1;
    return v;
  }else if(val.equals("2")){
    v=2;
    return v;
  }else if(val.equals("3")){
    v=3;
    return v;
  }else if(val.equals("4")){
    v=4;
    return v;
  }else if(val.equals("5")){
    v=5;
    return v;
  }else if(val.equals("6")){
    v=6;
    return v;
  }else if(val.equals("7")){
    v=7;
    return v;
  }else if(val.equals("8")){
    v=8;
    return v;
  }else if(val.equals("9")){
    v=9;
    return v;
  }else if(val.equals("A")){
    v=10;
    return v;
  }else if(val.equals("B")){
    v=11;
    return v;
  }else if(val.equals("C")){
    v=12;
    return v;
  }else if(val.equals("D")){
    v=13;
    return v;
  }else if(val.equals("E")){
    v=14;
    return v;
  }else if(val.equals("F")){
    v=15;
    return v;
  }
}


String toHEX(int q){
  String qq=String(q);
  String nS=String("");
  if(qq.length()<=3){
    int q1=q/16;
    w1=f_2(q1);
    int q2=q%16;
    w2=f_2(q2);
    nS.concat(w1);
    nS.concat(w2);
    return nS;
  }else{
    nS="no much";
    return;
  }
}

String f_2(int lmn){
  String xy="";
  if(lmn==0){
    xy.concat("0");
  }else if(lmn==1){
    xy.concat("1");
  }else if(lmn==2){
    xy.concat("2");
  }else if(lmn==3){
    xy.concat("3");
  }else if(lmn==4){
    xy.concat("4");
  }else if(lmn==5){
    xy.concat("5");
  }else if(lmn==6){
    xy.concat("6");
  }else if(lmn==7){
    xy.concat("7");
  }else if(lmn==8){
    xy.concat("8");
  }else if(lmn==9){
    xy.concat("9");
  }else if(lmn==10){
    xy.concat("A");
  }else if(lmn==11){
    xy.concat("B");
  }else if(lmn==12){
    xy.concat("C");
  }else if(lmn==13){
    xy.concat("D");
  }else if(lmn==14){
    xy.concat("E");
  }else if(lmn==15){
    xy.concat("F");
  }else{
  }
  return xy;
}

void check(){
  i = analogRead( A_0 );
  f = i * 5.0 / 1023.0;
  f*=100;
  f=map(f,5,315,0,330);
  f/=100;
}

void check_p(){
  i = analogRead( A_0 );
  f = i * 5.0 / 1023.0;
  f*=100;
  f=map(f,5,315,0,330);
  f/=100;
  //Serial.println(f);
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

void initialise(){
  pinMode(t,OUTPUT);
  pinMode(inc,OUTPUT);
  pinMode(ud,OUTPUT);
  pinMode(cs,OUTPUT);
  digitalWrite(t,LOW);
  digitalWrite(cs,LOW);
  digitalWrite(inc,HIGH);
  digitalWrite(ud,LOW);
  check();
  Serial.print("first current:");
  Serial.println(f);
  if(f==3.3){
    digitalWrite(ud,LOW);
    for(f;f==0;){
      digitalWrite(inc,LOW);
      digitalWrite(inc,HIGH);
      check();
    }
    digitalWrite(ud,HIGH);
    for(f;f==3.3;){
      digitalWrite(inc,LOW);
      digitalWrite(inc,HIGH);
      check();
      i++;
    }
  }else if(f==0){
    digitalWrite(ud,HIGH);
    for(f;f==5;){
      digitalWrite(inc,LOW);
      digitalWrite(inc,HIGH);
      check();
      i++;
    }
  }else{
    for(f;f==0;){
      digitalWrite(inc,LOW);
      digitalWrite(inc,HIGH);
      check();
    }
    digitalWrite(ud,HIGH);
    for(f;f==3.3;){
      digitalWrite(inc,LOW);
      digitalWrite(inc,HIGH);
      check();
      i++;
    }
  }
  g=f/i;
  Serial.print("potentional count:");
  Serial.println(i);
  Serial.print("maxcurrent:");
  Serial.println(f);
  Serial.print("span:");
  Serial.println(g);
}





void changeCurrent(float x){
    if(x>3.3||x<0){
      x=px;
    }
    
    check();

    float d=(f-x)*(f-x);

    if(d>=K){
      if(f>x){
        Serial.print("theoretical curent:");
        Serial.println(x);
        Serial.print("preCurent:");
        Serial.println(f);
        Serial.println("f>x");
        digitalWrite(cs,LOW);
        digitalWrite(ud,LOW);
        digitalWrite(inc,HIGH);
        for(f;f>=x;){
          digitalWrite(inc,LOW);
          digitalWrite(inc,HIGH);
          check_p();
        }
        check();
        Serial.print("real curent:");
        Serial.println(f);
      }else if(f<x){
        Serial.print("theoretical curent:");
        Serial.println(x);
        Serial.print("preCurent:");
        Serial.println(f);
        Serial.println("f<x");
        digitalWrite(cs,LOW);
        digitalWrite(ud,HIGH);
        digitalWrite(inc,HIGH);
        for(f;f<=x;){
          digitalWrite(inc,LOW);
          digitalWrite(inc,HIGH);
          check_p();
        }
        check();
        Serial.print("real curent:");
        Serial.println(f);
      }else{
        check();
        Serial.print("real curent:");
        Serial.println(f);
      }
    }else{
      check();
      Serial.print("real curent:");
      Serial.println(f);
    }
    px=x;
    Serial.println();
    Serial.println();
    Serial.println();
    Serial.println();
    delay(50);
}

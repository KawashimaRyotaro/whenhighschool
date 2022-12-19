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
            LQI=String(a.substring(9,11));
            lqi=todec(LQI);
            cr=map(lqi,0,255,1,300);
            crr=cr/100;
            ccr=toHEX(cr);         
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
}


void moniter(String a){
    int b=0;
    b=a.length();
    if(b==49){
        String LQI=String(a.substring(9,11));
    }else{
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
}





void changeCurrent(float x){
    if(x>3.3||x<0){
      x=px;
    }
    
    check();

    float d=(f-x)*(f-x);

    if(d>=K){
      if(f>x){
        digitalWrite(cs,LOW);
        digitalWrite(ud,LOW);
        digitalWrite(inc,HIGH);
        for(f;f>=x;){
          digitalWrite(inc,LOW);
          digitalWrite(inc,HIGH);
          check_p();
        }
        check();
      }else if(f<x){
        digitalWrite(cs,LOW);
        digitalWrite(ud,HIGH);
        digitalWrite(inc,HIGH);
        for(f;f<=x;){
          digitalWrite(inc,LOW);
          digitalWrite(inc,HIGH);
          check_p();
        }
        check();
      }else{
        check();
      }
    }else{
    }
    px=x;
    delay(50);
}

const int A_0= 0;
const int inc = 13;
const int ud = 12;
const int cs = 11;
int i=0;
double f=0;
double g=0;
float px=0;
float cr=0;





void setup() {
  Serial.begin( 9600 );
  initialise();
}





void loop() {
  if(Serial.available()>0){
    cr=getdata();
    changeCurrent(cr);
  }
}




/*______________________________________________________________________________________________________*/


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
  Serial.println(f);
}





float getdata(){
  int j=0;
  int l=1;
  char val;
  String a="";
  float a1=0;
  float a2=0;
  byte ds=Serial.available();
  if (ds>0){
    delay(20);
    ds=Serial.available();
    
    byte buf[ds];
    Serial.print("data size:");
    Serial.println(ds);

    for(byte i=0;i<ds;i++){
      buf[i]=Serial.read();
      val=(char)buf[i];
      a+=val;
    }
    a1=a.toFloat();
  }
  Serial.print("inputed value:");
  Serial.println(a1);
  return a1;
}






void initialise(){
  pinMode(inc,OUTPUT);
  pinMode(ud,OUTPUT);
  pinMode(cs,OUTPUT);
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
    }
    px=x;
}

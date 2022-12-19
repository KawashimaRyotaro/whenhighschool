const int A_0= 0;
const int inc = 13;
const int ud = 12;
const int cs = 11;
int i=0;
double f=0;
double g=0;

void setup() {
  Serial.begin( 9600 );
  pinMode(inc,OUTPUT);
  pinMode(ud,OUTPUT);
  pinMode(cs,OUTPUT);
  digitalWrite(cs,LOW);
  digitalWrite(inc,HIGH);
  digitalWrite(ud,LOW);
  check();
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
    for(f;f==3.3;){
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
  g=f*1000/i;
  Serial.print("i:");
  Serial.println(i);
  Serial.print("f:");
  Serial.println(f);
  Serial.print("g:");
  Serial.println(g);
}

void loop() {
}

void check(){
  i = analogRead( A_0 );
  f = i * 5.0 / 1023.0;
}

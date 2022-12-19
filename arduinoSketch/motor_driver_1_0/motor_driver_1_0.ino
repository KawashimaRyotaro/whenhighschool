int i=1;
int k=10,k1=5;
int j=11,j1=6;
int a=1;
int b=11;
int d=6;
boolean c=true;

void setup() {
  pinMode(k,OUTPUT);
  pinMode(j,OUTPUT);
  pinMode(k1,OUTPUT);
  pinMode(j1,OUTPUT);
  Serial.begin(9600);
  digitalWrite(k,LOW);
  digitalWrite(j,LOW);
  digitalWrite(k1,LOW);
  digitalWrite(j1,LOW);
}

void loop() {
  i+=a;
  if(i<=0||i>=255){
    a=a*(-1);
  }
  if(i==0){
    digitalWrite(k,LOW);
    digitalWrite(j,LOW);
    digitalWrite(k1,LOW);
    digitalWrite(j1,LOW);
    delay(1000);
    if(c){
      b=j;
      d=j1;
      c=false;
    }else if(!c){
      b=k;
      d=k1;
      c=true;
    }
  }
  analogWrite(b,i);
  analogWrite(d,i);
  Serial.print(i);
  Serial.print(":");
  Serial.println(c);
  delay(10);
}

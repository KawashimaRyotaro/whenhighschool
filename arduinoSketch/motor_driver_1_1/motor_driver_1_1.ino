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
  //analogWrite(k,255);
  analogWrite(j1,255);
}

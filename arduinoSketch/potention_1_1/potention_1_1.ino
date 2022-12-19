const int A_0= 0;
const int inc = 13;
const int ud = 12;
const int cs = 11;
int i=0;
float f=0;
float g=0;

void setup() {
  Serial.begin( 9600 );
  pinMode(inc,OUTPUT);
  pinMode(ud,OUTPUT);
  pinMode(cs,OUTPUT);
  digitalWrite(cs,LOW);
  digitalWrite(inc,HIGH);
  digitalWrite(ud,LOW);
  check();
}

void loop() {
}

void check(){
  i = analogRead( A_0 );
  f = i * 5.0 / 1023.0;
  Serial.println(f);
}

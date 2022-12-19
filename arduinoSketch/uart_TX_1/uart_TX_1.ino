int LED = 13;
String sendstr = "arduino";

void setup(){
  Serial.begin(9600);
  pinMode(LED, OUTPUT);
  pinMode(3,INPUT);
  Serial.println("Start writeing.");
}

void loop(){
  int k=analogRead(3);
  digitalWrite(LED, LOW);
  for (int i = 0; i < sendstr.length(); i++){
    Serial.write(sendstr.charAt(i)); 
  }
  Serial.write(k);
  Serial.write(0);
  digitalWrite(LED, HIGH);
  delay(k);
}

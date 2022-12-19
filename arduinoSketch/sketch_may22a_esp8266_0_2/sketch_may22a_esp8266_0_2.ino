int g_iCounter = 0;  // カウンター

void setup()
{
  // ボーレートを指定して通信開始
  Serial.begin(9600);
}

void loop()
{
  // データ送信
  Serial.println( g_iCounter );
  g_iCounter++;
  delay( 1000 );
}

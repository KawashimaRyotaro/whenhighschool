//akiracing.com (無断転載を禁ず)
#include <Wire.h>
#include <MadgwickAHRS.h>
Madgwick MadgwickFilter;

/////////////////////////MPU9250////////////////////////////

#define MPU9250_ADDRESS 0x68//I2CでのMPU9250のスレーブアドレス
#define PWR_MGMT_1 0x6b//電源管理のアドレス，スリープモード解除用
#define INT_PIN_CFG 0x37//磁気センサのバイパスモード設定用のアドレス

#define ACCEL_CONFIG 0x1c//加速度センサ設定用のアドレス
#define ACCEL_FS_SEL_2G 0x00//加速度センサのレンジ(2G)
#define ACCEL_FS_SEL_4G 0x08//加速度センサのレンジ(4G)
#define ACCEL_FS_SEL_8G 0x10//加速度センサのレンジ(8G)
#define ACCEL_FS_SEL_16G 0x18//加速度センサのレンジ(16G)

#define GYRO_CONFIG 0x1b//ジャイロセンサ設定用のアドレス
#define GYRO_FS_SEL_250DPS 0x00//ジャイロセンサのレンジ(250DPS)
#define GYRO_FS_SEL_500DPS 0x08//ジャイロセンサのレンジ(500DPS)
#define GYRO_FS_SEL_1000DPS 0x10//ジャイロセンサのレンジ(1000DPS)
#define GYRO_FS_SEL_2000DPS 0x18//ジャイロセンサのレンジ(2000DPS)

#define AK8963_ADDRESS 0x0c//磁気センサのスレーブアドレス
#define CNTL1 0x0a//磁気センサ設定用のアドレス
#define CNTL1_MODE_SEL_8HZ 0x12//磁気センサの出力周期(8Hz)
#define CNTL1_MODE_SEL_100HZ 0x16//磁気センサの出力周期(100Hz)
#define ST1 0x02//データ読み込み用フラッグのアドレス


volatile float accRange;//計算で使用するので，選択したレンジを入力する定数
volatile float gyroRange;//計算で使用するので，選択したレンジを入力する定数
volatile uint8_t accGyroTempData[14];//センサからのデータ格納用配列
volatile uint8_t magneticData[7];//センサからのデータ格納用配列
volatile uint8_t ST1Bit;//磁気センサのフラッグ

volatile int16_t ax = 0;//16bitの出力データ
volatile int16_t ay = 0;//16bitの出力データ
volatile int16_t az = 0;//16bitの出力データ

volatile int16_t gx = 0;//16bitの出力データ
volatile int16_t gy = 0;//16bitの出力データ
volatile int16_t gz = 0;//16bitの出力データ

volatile int16_t tempMPU9250Raw = 0;//16bitの出力データ

volatile int16_t mx = 0;//16bitの出力データ
volatile int16_t my = 0;//16bitの出力データ
volatile int16_t mz = 0;//16bitの出力データ

volatile float accX = 0;//加速度センサから求めた重力加速度
volatile float accY = 0;//加速度センサから求めた重力加速度
volatile float accZ = 0;//加速度センサから求めた重力加速度

volatile float gyroX = 0;//ジャイロセンサから求めた角速度
volatile float gyroY = 0;//ジャイロセンサから求めた角速度
volatile float gyroZ = 0;//ジャイロセンサから求めた角速度

volatile float tempMPU9250 = 0;//MPU9250の温度

volatile float magX = 0;//磁気センサから求めたuT
volatile float magY = 0;//磁気センサから求めたuT
volatile float magZ = 0;//磁気センサから求めたuT

float gx1, gy1, gz1, ax1, ay1, az1, magX1, magY1, magZ1, magX2, magY2, magZ2;
float K=112/3;
int k=10,k1=9;
int j=11,j1=6;
float py=0,yaw[]={0,0,0,0,0};
int n=40,val=0,ch=0,ch1=0,o=0;
int a=0;
float cmx=1,cmx1=0,cmy=1,cmy1=0,cmz=1,cmz1=0;

//////////////////////////////////////////////////////////////

void setup() {
  
  Wire.begin();//I2C通信を開始する
  Serial.begin(57600);//シリアル通信開始
  MadgwickFilter.begin(30);//madgwickフィルター開始

  i2cWriteByte(MPU9250_ADDRESS, PWR_MGMT_1, 0x00);//スリープモードを解除

  i2cWriteByte(MPU9250_ADDRESS, ACCEL_CONFIG, ACCEL_FS_SEL_16G);//加速度センサの測定レンジの設定
  accRange = 16.0;//計算で使用するので，選択したレンジを入力する

  i2cWriteByte(MPU9250_ADDRESS, GYRO_CONFIG, GYRO_FS_SEL_2000DPS);//ジャイロセンサの測定レンジの設定
  gyroRange = 2000.0;//計算で使用するので，選択したレンジを入力する

  i2cWriteByte(MPU9250_ADDRESS, INT_PIN_CFG, 0x02);//bypass mode(磁気センサが使用出来るようになる)
  i2cWriteByte(AK8963_ADDRESS, CNTL1, CNTL1_MODE_SEL_100HZ);//磁気センサのAD変換開始
  Serial.println("start");

  pinMode(k,OUTPUT);    //以下モータードライバーセットアップ
  pinMode(j,OUTPUT);
  pinMode(k1,OUTPUT);
  pinMode(j1,OUTPUT);
  digitalWrite(j1,LOW);
  digitalWrite(k,LOW);
  digitalWrite(k1,LOW);
  digitalWrite(j,LOW);

  MPU9250();    //値取得
  Serial.println(magX2);
  Serial.println(magY2);
  Serial.println(magZ2);
  float Mmx=magX2;        //最大値・最小値定義、代入
  float Mmy=magY2;
  float Mmz=magZ2;
  float mmx=magX2;
  float mmy=magY2;
  float mmz=magZ2;

  while(ch!=2){
    float qmx[]={0,0,0,0,0},qmy[]={0,0,0,0,0},qmz[]={0,0,0,0,0},Smx[]={0,0,0,0,0},Smy[]={0,0,0,0,0},Smz[]={0,0,0,0,0};  //以下地磁気キャリブレーション定義
    float smx=0,smy=0,smz=0;
    float ssmx=0,ssmy=0,ssmz=0;
    float tmx=0,tmy=0,tmz=0;
    for(ch1=0;ch1<=4;ch1++){  //直近の値５つを保存
      MPU9250();
      smx+=magX2;
      qmx[ch1]=magX2;
      smy+=magY2;
      qmy[ch1]=magY2;
      smz+=magZ2;
      qmz[ch1]=magZ2;
    }
    smx/=5;     //５つの平均取得
    smy/=5;
    smz/=5;
    for(ch1=0;ch1<=4;ch1++){                   //分散取得
      Smx[ch1]=1/((qmx[ch1]-smx)*(qmx[ch1]-smx));
      ssmx+=Smx[ch1];
      Smy[ch1]=1/((qmy[ch1]-smy)*(qmy[ch1]-smy));
      ssmy+=Smy[ch1];
      Smz[ch1]=1/((qmz[ch1]-smz)*(qmz[ch1]-smz));
      ssmz+=Smz[ch1];
    }
    tmx=qmx[0]*Smx[0]/ssmx+qmx[1]*Smx[1]/ssmx+qmx[2]*Smx[2]/ssmx+qmx[3]*Smx[3]/ssmx+qmx[4]*Smx[0]/ssmx;               //分散補正センサーを用いた値取得
    tmy=qmy[0]*Smy[0]/ssmy+qmy[1]*Smy[1]/ssmy+qmy[2]*Smy[2]/ssmy+qmy[3]*Smy[3]/ssmy+qmy[4]*Smy[0]/ssmy;
    tmz=qmz[0]*Smz[0]/ssmz+qmz[1]*Smz[1]/ssmz+qmz[2]*Smz[2]/ssmz+qmz[3]*Smz[3]/ssmz+qmz[4]*Smz[0]/ssmz;

    if(ch==0){
      float Mmx=tmx;     //最小値・最大値初期化
      float Mmy=tmy;
      float Mmz=tmz;
      float mmx=tmx;
      float mmy=tmy;
      float mmz=tmz;
      ch++;
    }
    if(ch==1){               //最大値・最小値更新
      if(tmx>Mmx){
        Mmx=tmx;
      }else if(tmx<mmx){
        mmx=tmx;
      }
      if(tmy>Mmy){
        Mmy=tmy;
      }else if(tmy<mmy){
        mmy=tmy;
      }
      if(tmz>Mmz){
        Mmz=tmz;
      }else if(tmz<mmz){
        mmz=tmz;
      }
      a++;
      if(a>200){
        ch++;
      }
    }
    digitalWrite(k1,LOW);    //補正回転
    digitalWrite(j,LOW);
    digitalWrite(j1,HIGH);
    digitalWrite(k,HIGH);
    delay(20);
    digitalWrite(k1,LOW);
    digitalWrite(j,LOW);
  }

  cmx=abs(Mmx-mmx);      //補正定数取得
  cmy=abs(Mmy-mmy);
  cmz=abs(Mmz-mmz);

  cmx1=(Mmx+mmx)/2;
  cmy1=(Mmy+mmy)/2;
  cmz1=(Mmz+mmz)/2;
  
  MPU9250();              //センサー値取得
  Serial.print("mmx:");
  Serial.println(mmx);
  Serial.print("mmy:");
  Serial.println(mmy);
  Serial.print("mmz:");
  Serial.println(mmz);
  Serial.print("mx:");
  Serial.println(magX2);
  Serial.print("my:");
  Serial.println(magY2);
  Serial.print("mz:");
  Serial.println(magZ2);

  digitalWrite(j1,LOW);
  digitalWrite(k,LOW);
  digitalWrite(k1,LOW);
  digitalWrite(j,LOW);                

  ch=0;  //判別変数リサイクル
  ch1=0;
}

void loop() {
  
  MPU9250();

  MadgwickFilter.update(gx1, gy1, gz1, ax1, ay1, az1, magX1, magY1, magZ1);

    float ROLL  = MadgwickFilter.getRoll();
    float PITCH = MadgwickFilter.getPitch();

    float cR=cos(-ROLL*PI/180);
    float sR=sin(-ROLL*PI/180);
    float cP=cos(-PITCH*PI/180);
    float sP=sin(-PITCH*PI/180);
    float ccR=cos(ROLL*PI/180);
    float csR=sin(ROLL*PI/180);
    float ccP=cos(PITCH*PI/180);
    float csP=sin(PITCH*PI/180);

    float   q=magY2*ccR-magZ2*csR;
    float  q1=magZ2*ccR+my*csR;//ROLL補正
  
    float q_1=magX2*ccP+magZ2*csP;
           q1=-magX2*csP+magZ2*ccP;//PITCH 補正*/

    //float YAW = atan2(magX2,magY2);
    float YAW = atan2(q,q_1);
    float Y=YAW/PI*180;

  Serial.println(Y);
    if(ch==0){
      if(Y>0){
        val=Y;
        digitalWrite(j1,LOW);
        digitalWrite(k,LOW);
        digitalWrite(k1,HIGH);
        digitalWrite(j,HIGH);
        delay(val/4);
        digitalWrite(k1,LOW);
        digitalWrite(j,LOW);
        delay(30);
      }else if(Y<0){
        val=-Y;
        digitalWrite(k1,LOW);
        digitalWrite(j,LOW);
        digitalWrite(j1,HIGH);
        digitalWrite(k,HIGH);
        delay(val/4);
        digitalWrite(j1,LOW);
        digitalWrite(k,LOW);
        delay(30);
      }else{
        digitalWrite(j1,LOW);
        digitalWrite(k,LOW);
        digitalWrite(k1,LOW);
        digitalWrite(j,LOW);
        delay(10);
      }
      yaw[o]=Y;
      if(o==4){
        if((yaw[0]<=10&&yaw[0]>=-10)&&(yaw[1]<=10&&yaw[1]>=-10)&&(yaw[2]<=10&&yaw[2]>=-10)&&(yaw[3]<=10&&yaw[3]>=-10)&&(yaw[4]<=10&&yaw[4]>=-10)){
          ch++;
        }
        o=0;
      }else{
        o++;
      }
    }else if(ch==1){
      if(Y>0){
        val=Y;
        digitalWrite(k1,HIGH);
        delay(val);
        digitalWrite(k,HIGH);
        delay(5);
      }else if(Y<0){
        val=-Y;
        digitalWrite(k,HIGH);
        delay(val);
        digitalWrite(k1,HIGH);
        delay(5);
      }else{
        digitalWrite(j1,LOW);
        digitalWrite(k,LOW);
        digitalWrite(k1,LOW);
        digitalWrite(j,LOW);
        delay(5);
      }
    }
    py=YAW;
      Serial.print("mx:");
  Serial.println(magX2);
  Serial.print("my:");
  Serial.println(magY2);
  Serial.print("mz:");
  Serial.println(magZ2);
}

void MPU9250() {

  //akiracing.com (無断転載を禁ず)

  //ACC&GRYO///////////////////////////////////////////////////////////////////////////

  i2cRead(MPU9250_ADDRESS, 0x3b, 14, accGyroTempData); //0x3bから，14バイト分をaccGyroDataにいれる

  //COMPASS////////////////////////////////////////////////////////////////////////////

  i2cRead(AK8963_ADDRESS, ST1, 1, &ST1Bit);//読み出し準備ができたか確認

  if ((ST1Bit & 0x01)) {

    i2cRead(AK8963_ADDRESS, 0x03, 7, magneticData);//7番目の0x09(ST2)まで読まないとデータが更新されない

  }

  //Acc
  ax = (accGyroTempData[0] << 8) | accGyroTempData[1];//accGyroTempData[0]を左に8シフトし(<<)，accGyroTempData[1]を足し合わせる(|)
  ay = (accGyroTempData[2] << 8) | accGyroTempData[3];//accGyroTempData[2]を左に8シフトし(<<)，accGyroTempData[3]を足し合わせる(|)
  az = (accGyroTempData[4] << 8) | accGyroTempData[5];//accGyroTempData[4]を左に8シフトし(<<)，accGyroTempData[5]を足し合わせる(|)

  //Gyro
  gx = (accGyroTempData[8] << 8) | accGyroTempData[9];//accGyroTempData[8]を左に8シフトし(<<)，accGyroTempData[9]を足し合わせる(|)
  gy = (accGyroTempData[10] << 8) | accGyroTempData[11];//accGyroTempData[10]を左に8シフトし(<<)，accGyroTempData[11]を足し合わせる(|)
  gz = (accGyroTempData[12] << 8) | accGyroTempData[13];//accGyroTempData[12]を左に8シフトし(<<)，accGyroTempData[13]を足し合わせる(|)

  //Temp
  tempMPU9250Raw = (accGyroTempData[6] << 8) | accGyroTempData[7];//accGyroTempData[6]を左に8シフトし(<<)，accGyroTempData[7]を足し合わせる(|)

  //Magneto
  mx = (magneticData[3] << 8) | magneticData[2];//センサの軸が違うので順番が加速度とジャイロと違う
  my = (magneticData[1] << 8) | magneticData[0];//magneticData[1]を左に8シフトし(<<)，magneticData[0]を足し合わせる(|)
  mz = -((magneticData[5] << 8) | magneticData[4]);//加速度，ジャイロセンサと軸の向きが逆なので-を掛ける

  ax = ax * accRange / 327.68;//[G]に変換
  ay = ay * accRange / 327.68;//[G]に変換
  az = az * accRange / 327.68;//[G]に変換

  gx = gx * gyroRange / 32768.0;//[deg/s]に変換
  gy = gy * gyroRange / 32768.0;//[deg/s]に変換
  gz = gz * gyroRange / 32768.0;//[deg/s]に変換

  ax1=(float)ax+0.5;
  ay1=(float)ay-0.5;
  az1=(float)az-0.5;
  gx1=(float)gx+0.98;
  gy1=(float)gy-1+0.01;
  gz1=(float)gz+0.49;


  tempMPU9250 = ((tempMPU9250Raw - 0.0) / 333.87) + 21.0f;

  //MPU-9250 Product Specification Revision 1.0のP12の値と,
  //MPU-9250Register Map and Descriptions Revision 1.4のP33の式を使用

  mx = mx / 32768.0f * 4800.0f;//[uT]に変換
  my = my / 32768.0f * 4800.0f;//[uT]に変換
  mz = mz / 32768.0f * 4800.0f;//[uT]に変換
  
    /*if (Serial.available() == 1) {
    byte inBuf[1];
    Serial.readBytes(inBuf, 1);
    if (inBuf[0] == 's') {
      byte outBuf[20];
      outBuf[0]  = 's';                        // 1
      outBuf[1]  = (int16_t)(gx * 100) >> 8;   // 2
      outBuf[2]  = (int16_t)(gx * 100) & 0xFF; // 3
      outBuf[3]  = (int16_t)(gy * 100) >> 8;   // 4
      outBuf[4]  = (int16_t)(gy * 100) & 0xFF; // 5
      outBuf[5]  = (int16_t)(gz * 100) >> 8;   // 6
      outBuf[6]  = (int16_t)(gz * 100) & 0xFF; // 7
      outBuf[7]  = (int16_t)(ax * 100) >> 8;   // 8
      outBuf[8]  = (int16_t)(ax * 100) & 0xFF; // 9
      outBuf[9]  = (int16_t)(ay * 100) >> 8;   // 10
      outBuf[10] = (int16_t)(ay * 100) & 0xFF; // 11
      outBuf[11] = (int16_t)(az * 100) >> 8;   // 12
      outBuf[12] = (int16_t)(az * 100) & 0xFF; // 13
      outBuf[13] = (int16_t)(mx * 100) >> 8;   // 8
      outBuf[14] = (int16_t)(mx * 100) & 0xFF; // 9
      outBuf[15] = (int16_t)(my * 100) >> 8;   // 10
      outBuf[16] = (int16_t)(my * 100) & 0xFF; // 11
      outBuf[17] = (int16_t)(mz * 100) >> 8;   // 12
      outBuf[18] = (int16_t)(mz * 100) & 0xFF; // 13
      outBuf[19] = 'e';                       // 14
      Serial.write(outBuf, 20);
    }
    else {
      while (Serial.available() > 0)Serial.read();
    }
  }
  if (Serial.available() > 1) {
    while (Serial.available() > 0)Serial.read();
  }*/  
    magX2 = ((float)mx-6.5)/37.5*K;

    magY2 = ((float)my-9.5)/35.5*K;

    magZ2 = ((float)mz-30)/39*K;

    magX1 = (float)(mx + 344.0f) / 32768.0f * 4921.0f * 10.0f;//[mGauss]に変換

    magY1 = (float)(my - 234.0f) / 32768.0f * 4921.0f * 10.0f;//[mGauss]に変換

    magZ1 = (float)(mz - 410.0f) / 32768.0f * 4921.0f * 10.0f;//[mGauss]に変換

    magX2=(magX2-cmx1)/cmx;

    magY2=(magY2-cmy1)/cmy;

    magZ2=(magZ2-cmz1)/cmz;

}



void i2cRead(uint8_t Address, uint8_t Register, uint8_t NBytes, volatile uint8_t* Data) {//指定したアドレスのデータを読む関数

  Wire.beginTransmission(Address);//指定したアドレスと通信を始める
  Wire.write(Register);//レジスタを書き込む
  Wire.endTransmission();//通信を終了する

  Wire.requestFrom(Address, NBytes);//スレーブからNByteのデータを要求する
  uint8_t index = 0;
  
  while (Wire.available()) {
    Data[index++] = Wire.read();//データを読み込む
  }
}

void i2cWriteByte(uint8_t Address, uint8_t Register, volatile uint8_t Data) {//指定したアドレスにデータを書き込む関数
  
  Wire.beginTransmission(Address);//指定したアドレスと通信を始める
  Wire.write(Register);//指定するレジスタを書き込む
  Wire.write(Data);//データを書き込む
  Wire.endTransmission();//通信を終了する

}

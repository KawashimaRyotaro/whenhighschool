//akiracing.com (無断転載を禁ず)
#include <Wire.h>
#include <MadgwickAHRS.h>
Madgwick MadgwickFilter;
/////////////////////////bme280/////////////////////////////

#define BME280_ADDRESS 0x76

unsigned long int hum_raw,temp_raw,pres_raw;
signed long int t_fine;

uint16_t dig_T1;
 int16_t dig_T2;
 int16_t dig_T3;
uint16_t dig_P1;
 int16_t dig_P2;
 int16_t dig_P3;
 int16_t dig_P4;
 int16_t dig_P5;
 int16_t dig_P6;
 int16_t dig_P7;
 int16_t dig_P8;
 int16_t dig_P9;
 int8_t  dig_H1;
 int16_t dig_H2;
 int8_t  dig_H3;
 int16_t dig_H4;
 int16_t dig_H5;
 int8_t  dig_H6;

////////////////////////////////////////////////////////////

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
int abc=0;
float py=0;
int n=40,val=0;

//////////////////////////////////////////////////////////////

void setup() {

  pinMode(2, OUTPUT);
    digitalWrite(2,HIGH);
    uint8_t osrs_t = 3;             //Temperature oversampling x 1
    uint8_t osrs_p = 3;             //Pressure oversampling x 1
    uint8_t osrs_h = 3;             //Humidity oversampling x 1
    uint8_t mode = 3;               //Normal mode
    uint8_t t_sb = 5;               //Tstandby 1000ms
    uint8_t filter = 0;             //Filter off 
    uint8_t spi3w_en = 0;           //3-wire SPI Disable
    
    uint8_t ctrl_meas_reg = (osrs_t << 5) | (osrs_p << 2) | mode;
    uint8_t config_reg    = (t_sb << 5) | (filter << 2) | spi3w_en;
    uint8_t ctrl_hum_reg  = osrs_h;
  
  Wire.begin();//I2C通信を開始する
  Serial.begin(57600);//シリアル通信を開始する
  MadgwickFilter.begin(30);

    writeReg(0xF2,ctrl_hum_reg);
    writeReg(0xF4,ctrl_meas_reg);
    writeReg(0xF5,config_reg);
    digitalWrite(2,LOW);
    readTrim();

  i2cWriteByte(MPU9250_ADDRESS, PWR_MGMT_1, 0x00);//スリープモードを解除

  i2cWriteByte(MPU9250_ADDRESS, ACCEL_CONFIG, ACCEL_FS_SEL_16G);//加速度センサの測定レンジの設定
  accRange = 16.0;//計算で使用するので，選択したレンジを入力する

  i2cWriteByte(MPU9250_ADDRESS, GYRO_CONFIG, GYRO_FS_SEL_2000DPS);//ジャイロセンサの測定レンジの設定
  gyroRange = 2000.0;//計算で使用するので，選択したレンジを入力する

  i2cWriteByte(MPU9250_ADDRESS, INT_PIN_CFG, 0x02);//bypass mode(磁気センサが使用出来るようになる)
  i2cWriteByte(AK8963_ADDRESS, CNTL1, CNTL1_MODE_SEL_100HZ);//磁気センサのAD変換開始
  Serial.println("start");

  pinMode(k,OUTPUT);
  pinMode(j,OUTPUT);
  pinMode(k1,OUTPUT);
  pinMode(j1,OUTPUT);
  analogWrite(k,0);
  analogWrite(j,0);
  analogWrite(k1,0);
  analogWrite(j1,0);
  
}

void loop() {
  Serial.println("first");
  //analogWrite(k,255);
  //analogWrite(k1,255);

  double temp_act = 0.0, press_act = 0.0,hum_act=0.0;
    signed long int temp_cal;
    unsigned long int press_cal,hum_cal;
    
    readData();
    Serial.println("second");
    
    temp_cal = calibration_T(temp_raw);
    press_cal = calibration_P(pres_raw);
    hum_cal = calibration_H(hum_raw);
    temp_act = (double)temp_cal / 100.0;
    press_act = (double)press_cal / 100.0;
    hum_act = (double)hum_cal / 1024.0;
    Serial.print("TEMP : ");
    Serial.print(temp_act);
    Serial.print(" DegC  PRESS : ");
    Serial.print(press_act);
    Serial.print(" hPa  HUM : ");
    Serial.print(hum_act);
    Serial.println(" %");
  
  MPU9250();
  Serial.println("third");

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
    Serial.print("\t YAW = ");
    Serial.println(Y);
    Serial.println(map(Y,-180,0,0,255));

    if((YAW*py<0)&&(val>128)){
      Serial.println("///////////////////////////restart//////////////////");
      Wire.begin();//I2C通信を開始する
      Serial.begin(57600);//シリアル通信を開始する
      i2cWriteByte(MPU9250_ADDRESS, PWR_MGMT_1, 0x00);//スリープモードを解除

      i2cWriteByte(MPU9250_ADDRESS, ACCEL_CONFIG, ACCEL_FS_SEL_16G);//加速度センサの測定レンジの設定
      accRange = 16.0;//計算で使用するので，選択したレンジを入力する

      i2cWriteByte(MPU9250_ADDRESS, GYRO_CONFIG, GYRO_FS_SEL_2000DPS);//ジャイロセンサの測定レンジの設定
      gyroRange = 2000.0;//計算で使用するので，選択したレンジを入力する

      i2cWriteByte(MPU9250_ADDRESS, INT_PIN_CFG, 0x02);//bypass mode(磁気センサが使用出来るようになる)
      i2cWriteByte(AK8963_ADDRESS, CNTL1, CNTL1_MODE_SEL_100HZ);//磁気センサのAD変換開始
    }
    
    if(YAW>0){
      val=n+Y;
      digitalWrite(j1,LOW);
      digitalWrite(k,LOW);
      analogWrite(k1,val);
      analogWrite(j,val);
      Serial.println("turning:right");
      abc=1;
    }else if(YAW<0){
      val=n-Y;
      digitalWrite(j,LOW);
      digitalWrite(k1,LOW);
      analogWrite(k,val);
      analogWrite(j1,val);
      Serial.println("turning:left");
      abc=2;
    }else{
      digitalWrite(j1,LOW);
      digitalWrite(k,LOW);
      digitalWrite(j,LOW);
      digitalWrite(k1,LOW);
    }
    Serial.print("val:");
    Serial.println(val);
    py=YAW;
}

void readTrim()
{   
    uint8_t data[32],i=0;                      // Fix 2014/04/06
    Wire.beginTransmission(BME280_ADDRESS);
    Wire.write(0x88);
    Wire.endTransmission();
    Wire.requestFrom(BME280_ADDRESS,24);       // Fix 2014/04/06
    while(Wire.available()){
        data[i] = Wire.read();
        i++;
    }
    
    Wire.beginTransmission(BME280_ADDRESS);    // Add 2014/04/06
    Wire.write(0xA1);                          // Add 2014/04/06
    Wire.endTransmission();                    // Add 2014/04/06
    Wire.requestFrom(BME280_ADDRESS,1);        // Add 2014/04/06
    data[i] = Wire.read();                     // Add 2014/04/06
    i++;                                       // Add 2014/04/06
    
    Wire.beginTransmission(BME280_ADDRESS);
    Wire.write(0xE1);
    Wire.endTransmission();
    Wire.requestFrom(BME280_ADDRESS,7);        // Fix 2014/04/06
    while(Wire.available()){
        data[i] = Wire.read();
        i++;    
    }
    dig_T1 = (data[1] << 8) | data[0];
    dig_T2 = (data[3] << 8) | data[2];
    dig_T3 = (data[5] << 8) | data[4];
    dig_P1 = (data[7] << 8) | data[6];
    dig_P2 = (data[9] << 8) | data[8];
    dig_P3 = (data[11]<< 8) | data[10];
    dig_P4 = (data[13]<< 8) | data[12];
    dig_P5 = (data[15]<< 8) | data[14];
    dig_P6 = (data[17]<< 8) | data[16];
    dig_P7 = (data[19]<< 8) | data[18];
    dig_P8 = (data[21]<< 8) | data[20];
    dig_P9 = (data[23]<< 8) | data[22];
    dig_H1 = data[24];
    dig_H2 = (data[26]<< 8) | data[25];
    dig_H3 = data[27];
    dig_H4 = (data[28]<< 4) | (0x0F & data[29]);
    dig_H5 = (data[30] << 4) | ((data[29] >> 4) & 0x0F); // Fix 2014/04/06
    dig_H6 = data[31];                                   // Fix 2014/04/06
}
void writeReg(uint8_t reg_address, uint8_t data)
{
    Wire.beginTransmission(BME280_ADDRESS);
    Wire.write(reg_address);
    Wire.write(data);
    Wire.endTransmission();    
}


void readData()
{
    int i = 0;
    uint32_t data[8];
    Wire.beginTransmission(BME280_ADDRESS);
    Wire.write(0xF7);
    Wire.endTransmission();
    Wire.requestFrom(BME280_ADDRESS,8);
    while(Wire.available()){
        data[i] = Wire.read();
        i++;
    }
    pres_raw = (data[0] << 12) | (data[1] << 4) | (data[2] >> 4);
    temp_raw = (data[3] << 12) | (data[4] << 4) | (data[5] >> 4);
    hum_raw  = (data[6] << 8) | data[7];
}


signed long int calibration_T(signed long int adc_T)
{
    
    signed long int var1, var2, T;
    var1 = ((((adc_T >> 3) - ((signed long int)dig_T1<<1))) * ((signed long int)dig_T2)) >> 11;
    var2 = (((((adc_T >> 4) - ((signed long int)dig_T1)) * ((adc_T>>4) - ((signed long int)dig_T1))) >> 12) * ((signed long int)dig_T3)) >> 14;
    
    t_fine = var1 + var2;
    T = (t_fine * 5 + 128) >> 8;
    return T; 
}

unsigned long int calibration_P(signed long int adc_P)
{
    signed long int var1, var2;
    unsigned long int P;
    var1 = (((signed long int)t_fine)>>1) - (signed long int)64000;
    var2 = (((var1>>2) * (var1>>2)) >> 11) * ((signed long int)dig_P6);
    var2 = var2 + ((var1*((signed long int)dig_P5))<<1);
    var2 = (var2>>2)+(((signed long int)dig_P4)<<16);
    var1 = (((dig_P3 * (((var1>>2)*(var1>>2)) >> 13)) >>3) + ((((signed long int)dig_P2) * var1)>>1))>>18;
    var1 = ((((32768+var1))*((signed long int)dig_P1))>>15);
    if (var1 == 0)
    {
        return 0;
    }    
    P = (((unsigned long int)(((signed long int)1048576)-adc_P)-(var2>>12)))*3125;
    if(P<0x80000000)
    {
       P = (P << 1) / ((unsigned long int) var1);   
    }
    else
    {
        P = (P / (unsigned long int)var1) * 2;    
    }
    var1 = (((signed long int)dig_P9) * ((signed long int)(((P>>3) * (P>>3))>>13)))>>12;
    var2 = (((signed long int)(P>>2)) * ((signed long int)dig_P8))>>13;
    P = (unsigned long int)((signed long int)P + ((var1 + var2 + dig_P7) >> 4));
    return P;
}

unsigned long int calibration_H(signed long int adc_H)
{
    signed long int v_x1;
    
    v_x1 = (t_fine - ((signed long int)76800));
    v_x1 = (((((adc_H << 14) -(((signed long int)dig_H4) << 20) - (((signed long int)dig_H5) * v_x1)) + 
              ((signed long int)16384)) >> 15) * (((((((v_x1 * ((signed long int)dig_H6)) >> 10) * 
              (((v_x1 * ((signed long int)dig_H3)) >> 11) + ((signed long int) 32768))) >> 10) + (( signed long int)2097152)) * 
              ((signed long int) dig_H2) + 8192) >> 14));
   v_x1 = (v_x1 - (((((v_x1 >> 15) * (v_x1 >> 15)) >> 7) * ((signed long int)dig_H1)) >> 4));
   v_x1 = (v_x1 < 0 ? 0 : v_x1);
   v_x1 = (v_x1 > 419430400 ? 419430400 : v_x1);
   return (unsigned long int)(v_x1 >> 12);   
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

    magX2 = (magX2-5-2.525)/25.525;

    magY2 = (magY2-80.5-3.7)/26.35;

    magZ2 = (magZ2-2+1.53)/26.09;

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

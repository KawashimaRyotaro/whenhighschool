#include <MadgwickAHRS.h>
#include <SPI.h>
#include <SD.h>
Madgwick MadgwickFilter;


float gx1, gy1, gz1, ax1, ay1, az1, magX2, magY2, magZ2;
float K=112/3;
char que[100]={};

void setup() {
  Wire.begin();//I2C通信を開始する
  Serial.begin(57600);//シリアル通信を開始する
  MadgwickFilter.begin(120);

  i2cWriteByte(MPU9250_ADDRESS, PWR_MGMT_1, 0x00);//スリープモードを解除

  i2cWriteByte(MPU9250_ADDRESS, ACCEL_CONFIG, ACCEL_FS_SEL_16G);//加速度センサの測定レンジの設定
  accRange = 16.0;//計算で使用するので，選択したレンジを入力する

  i2cWriteByte(MPU9250_ADDRESS, GYRO_CONFIG, GYRO_FS_SEL_2000DPS);//ジャイロセンサの測定レンジの設定
  gyroRange = 2000.0;//計算で使用するので，選択したレンジを入力する

  i2cWriteByte(MPU9250_ADDRESS, INT_PIN_CFG, 0x02);//bypass mode(磁気センサが使用出来るようになる)
  i2cWriteByte(AK8963_ADDRESS, CNTL1, CNTL1_MODE_SEL_100HZ);//磁気センサのAD変換開始
}

void loop() {
  int ch=0;
  int count=0;

  File dataFile=SD.open("datalog"+String(0)+".txt",FILE_READ);
  while(ch==0){
    char a=dataFile.read();
    que[count]=a;
    if(a=='e'){
      ch++;
    }
    count++;
  }

  for(int j=0;

  MadgwickFilter.update(gx1, gy1, gz1, ax1, ay1, az1, magX1, magY1, magZ1);

    float ROLL  = MadgwickFilter.getRoll();
    float PITCH = MadgwickFilter.getPitch();
    float YAW   = MadgwickFilter.getYaw();

    if (Serial.available() == 1) {
    byte inBuf[1];
    Serial.readBytes(inBuf, 1);
    if (inBuf[0] == 's') {
      byte outBuf[26];
      outBuf[0]  = 's';                        // 1
      outBuf[1]  = (int16_t)(ROLL * 100) >> 8;   // 2
      outBuf[2]  = (int16_t)(ROLL * 100) & 0xFF; // 3
      outBuf[3]  = (int16_t)(PITCH * 100) >> 8;   // 4
      outBuf[4]  = (int16_t)(PITCH * 100) & 0xFF; // 5
      outBuf[5]  = (int16_t)(YAW * 100) >> 8;   // 6
      outBuf[6]  = (int16_t)(YAW * 100) & 0xFF; // 7
      outBuf[7]  = (int16_t)(ax1 * 100) >> 8;   // 2
      outBuf[8]  = (int16_t)(ax1 * 100) & 0xFF; // 3
      outBuf[9]  = (int16_t)(ay1 * 100) >> 8;   // 4
      outBuf[10]  = (int16_t)(ay1 * 100) & 0xFF; // 5
      outBuf[11]  = (int16_t)(az1 * 100) >> 8;   // 6
      outBuf[12]  = (int16_t)(az1 * 100) & 0xFF; // 3
      outBuf[13]  = (int16_t)(gx1 * 100) >> 8;   // 2
      outBuf[14]  = (int16_t)(gx1 * 100) & 0xFF; // 3
      outBuf[15]  = (int16_t)(gy1 * 100) >> 8;   // 4
      outBuf[16]  = (int16_t)(gy1 * 100) & 0xFF; // 5
      outBuf[17]  = (int16_t)(gz1 * 100) >> 8;   // 6
      outBuf[18]  = (int16_t)(gz1 * 100) & 0xFF; // 7
      outBuf[19]  = (int16_t)(magX2 * 100) >> 8;   // 2
      outBuf[20]  = (int16_t)(magX2 * 100) & 0xFF; // 3
      outBuf[21]  = (int16_t)(magY2* 100) >> 8;   // 4
      outBuf[22]  = (int16_t)(magY2 * 100) & 0xFF; // 5
      outBuf[23]  = (int16_t)(magZ2 * 100) >> 8;   // 6
      outBuf[24]  = (int16_t)(magZ2 * 100) & 0xFF; // 7
      outBuf[25] = 'e';                       // 14
      Serial.write(outBuf, 26);
    }
    else {
      while (Serial.available() > 0)Serial.read();
    }
  }
  if (Serial.available() > 1) {
    while (Serial.available() > 0)Serial.read();
  }

    /*Serial.print("ROLL = ");
    Serial.print(ROLL);
    Serial.print("\t PITCH = ");
    Serial.print(PITCH);
    Serial.print("\t YAW = ");
    Serial.print(YAW);
    
  
  Serial.print("ax: ");
  Serial.print(ax1);
  Serial.print("\t");
  Serial.print("ay: ");
  Serial.print(ay1);
  Serial.print("\t");
  Serial.print("az: ");
  Serial.print(az1);
  Serial.print("\t");

  Serial.print("gx: ");
  Serial.print(gx1);
  Serial.print("\t");
  Serial.print("gy: ");
  Serial.print(gy1);
  Serial.print("\t");
  Serial.print("gz: ");
  Serial.print(gz1);
  Serial.print("\t");

  Serial.print("mx: ");
  Serial.print(magX1);
  Serial.print("\t");
  Serial.print("my: ");
  Serial.print(magY1);
  Serial.print("\t");
  Serial.print("mz: ");
  Serial.print(magZ1);
  Serial.print("\t");

  Serial.print("temp: ");
  Serial.print(tempMPU9250);
  Serial.println("\t");
  Serial.print("\n");*/

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

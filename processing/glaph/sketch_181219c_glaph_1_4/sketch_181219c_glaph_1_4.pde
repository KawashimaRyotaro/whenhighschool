import processing.serial.*;                                   //ライブラリインポート
float gx, gy, gz, ax, ay, az, mx, my, mz;                     //ジャイロ、加速度、地磁気の値
float gx1, gy1, gz1;                                          //補正後ジャイロ
float pgx=0, pgy=0, pgz=0;                                    //前の状態のジャイロ
float gxt=0, gyt=0, gzt=0;                                    //角度
float x=0, y=0, z=0;                                          //測定時の変化量（ジャイロ）
float px=0, py=0, pz=0;                                       //前の状態の変化量
float sgx=0, sgy=0, sgz=0, avgx=0, avgy=0, avgz=0;            //平均値をとる
int num=0, num1=0, n=0;                                       //カウント
int serialTimer;                                              //カウント
Serial myPort;                                                //シリアルポート開始
graphMonitor1 testGraph1;                                     //
graphMonitor2 testGraph2;                                     //
graphMonitor3 testGraph3;                                     //
graphMonitor4 testGraph4;                                     //グラフ準備     

void setup() {
  /*size(500, 500);*/
  size(1920, 1080, P3D);
  frameRate(100);
  smooth();
  testGraph1 = new graphMonitor1("gylo", 70, 50, 800, 400);
  testGraph2 = new graphMonitor2("accel", 70, 500, 800, 400);
  testGraph3 = new graphMonitor3("magnet", 1000, 500, 800, 400);
  testGraph4 = new graphMonitor4("angle", 1000, 50, 800, 400);
  myPort = new Serial(this, "COM4", 57600);
}

void draw() {
  num++;
  if (millis()-serialTimer > 50) {
    serialTimer = millis();
    byte[] inBuf = new byte[20];
    println(myPort.available());
    if (myPort.available() == 20) {
      myPort.readBytes(inBuf);
      if (inBuf[0]=='s'&&inBuf[19]=='e') {
        gx = (inBuf[1]<<8)+(inBuf[2]&0xff);
        gy = (inBuf[3]<<8)+(inBuf[4]&0xff);
        gz = (inBuf[5]<<8)+(inBuf[6]&0xff);
        ax = (inBuf[7]<<8)+(inBuf[8]&0xff);
        ay = (inBuf[9]<<8)+(inBuf[10]&0xff);
        az = (inBuf[11]<<8)+(inBuf[12]&0xff);
        mx = (inBuf[13]<<8)+(inBuf[14]&0xff);
        my = (inBuf[15]<<8)+(inBuf[16]&0xff);
        mz = (inBuf[17]<<8)+(inBuf[18]&0xff);
        gx/=100.0;
        gy/=100.0;
        gz/=100.0;
        gx1=gx;
        gy1=gy;
        gz1=gz;
        ax/=100.0;
        ay/=100.0;
        az/=100.0;
        mx/=100.0;
        my/=100.0;
        mz/=100.0;
        gx1-=avgx;
        gy1-=avgy;
        gz1-=avgz;
        ax-=2;
        ay-=1;
        az-=1;
      } else {
        while (myPort.available()>0)myPort.read();
        println("missMatch");
      }
    } else if (myPort.available() > 14) {
      while (myPort.available()>0)myPort.read();
      println("overflowe");
    }

    byte[] outBuf = new byte[1];
    outBuf[0]     = 's';
    myPort.write(outBuf);
  }
  
  if(ax>=100){                     //////////////////////////////////////////////////////////////////////
    ax=100;                        //
  }else if(ax<=-100){              //
    ax=-100;                       //
  }else if(ay>=100){               //
    ay=100;                        //
  }else if(ay<=-100){              //加速度センサー補正（１）
    ay=-100;                       //
  }else if(az>=100){               //
    az=100;                        //
  }else if(az<=-100){              //
    az=-100;                       //
  }                                ///////////////////////////////////////////////////////////////////////
  if(num>1){                       ///////////////////////////////////////////////////////////////////////
    x=gx-pgx;                      //
    y=gy-pgy;                      //
    z=gz-pgz;                      //
    if(num>100){                   //
        if(num1==0&&px>0&&x<=0){   //
          num1=1;                  //
        }else if(num1==1){         //
          sgx+=gx;                 //
          sgy+=gy;                 //
          sgz+=gz;                 //
          n+=1;                    //ジャイロ補正（１）
          if(px>0&&x<=0){          //
            avgx=sgx/n;            //
            avgy=sgy/n;            //
            avgz=sgz/n;            //
            sgx=0;                 //
            sgy=0;                 //
            sgz=0;                 //
            n=0;                   //
          }                        //
        }                          //
      }                            //
    }                              //////////////////////////////////////////////////////////////////////
    if(num>=200){
    gxt+=gx1;
    gyt+=gy1;
    gzt+=gz1;
    }
  gx1-=avgx;
  gy1-=avgy;
  gz1-=avgz;
  background(250);
  testGraph1.graphDraw1(gx1, gy1, gz1);
  testGraph2.graphDraw2(ax, ay, az);
  testGraph3.graphDraw3(mx, my, mz);
  testGraph4.graphDraw4(gxt, gyt, gzt);
  px=x;
  py=y;
  pz=z;
  pgx=gx;
  pgy=gy;
  pgz=gz;
}

class graphMonitor1 {
    String TITLE;
    int X_POSITION, Y_POSITION;
    int X_LENGTH, Y_LENGTH;
    float [] y1, y2, y3;
    float maxRange;
    graphMonitor1(String _TITLE, int _X_POSITION, int _Y_POSITION, int _X_LENGTH, int _Y_LENGTH) {
      TITLE = _TITLE;
      X_POSITION = _X_POSITION;
      Y_POSITION = _Y_POSITION;
      X_LENGTH   = _X_LENGTH;
      Y_LENGTH   = _Y_LENGTH;
      y1 = new float[X_LENGTH];
      y2 = new float[X_LENGTH];
      y3 = new float[X_LENGTH];
      for (int i = 0; i < X_LENGTH; i++) {
        y1[i] = 0;
        y2[i] = 0;
        y3[i] = 0;
      }
    }

    void graphDraw1(float _y1, float _y2, float _y3) {
      y1[X_LENGTH - 1] = _y1;
      y2[X_LENGTH - 1] = _y2;
      y3[X_LENGTH - 1] = _y3;
      for (int i = 0; i < X_LENGTH - 1; i++) {
        y1[i] = y1[i + 1];
        y2[i] = y2[i + 1];
        y3[i] = y3[i + 1];
      }
      maxRange = 1;
      for (int i = 0; i < X_LENGTH - 1; i++) {
        maxRange = (abs(y1[i]) > maxRange ? abs(y1[i]) : maxRange);
        maxRange = (abs(y2[i]) > maxRange ? abs(y2[i]) : maxRange);
        maxRange = (abs(y3[i]) > maxRange ? abs(y3[i]) : maxRange);
      }

      pushMatrix();

      translate(X_POSITION, Y_POSITION);
      fill(240);
      stroke(130);
      strokeWeight(1);
      rect(0, 0, X_LENGTH, Y_LENGTH);
      line(0, Y_LENGTH / 2, X_LENGTH, Y_LENGTH / 2);

      textSize(25);
      fill(60);
      textAlign(LEFT, BOTTOM);
      text(TITLE, 20, -5);
      textSize(22);
      textAlign(RIGHT);
      text(0, -5, Y_LENGTH / 2 + 7);
      text(nf( maxRange , 0, 1), -5, 18);
      text(nf(-1 *  maxRange , 0, 1), -5, Y_LENGTH);

      translate(0, Y_LENGTH / 2);
      scale(1, -1);
      strokeWeight(1);
      for (int i = 0; i < X_LENGTH - 1; i++) {
        stroke(255, 0, 0);
        line(i, y1[i] * (Y_LENGTH / 2) /  maxRange , i + 1, y1[i + 1] * (Y_LENGTH / 2) / maxRange);
        stroke(255, 0, 255);
        line(i, y2[i] * (Y_LENGTH / 2) /  maxRange , i + 1, y2[i + 1] * (Y_LENGTH / 2) / maxRange);
        stroke(0, 0, 0);
        line(i, y3[i] * (Y_LENGTH / 2) /  maxRange , i + 1, y3[i + 1] * (Y_LENGTH / 2) / maxRange);
      }
      popMatrix();
    }
}
class graphMonitor2 {
    String TITLE;
    int X_POSITION, Y_POSITION;
    int X_LENGTH, Y_LENGTH;
    float [] y1, y2, y3;
    float maxRange;
    graphMonitor2(String _TITLE, int _X_POSITION, int _Y_POSITION, int _X_LENGTH, int _Y_LENGTH) {
      TITLE = _TITLE;
      X_POSITION = _X_POSITION;
      Y_POSITION = _Y_POSITION;
      X_LENGTH   = _X_LENGTH;
      Y_LENGTH   = _Y_LENGTH;
      y1 = new float[X_LENGTH];
      y2 = new float[X_LENGTH];
      y3 = new float[X_LENGTH];
      for (int i = 0; i < X_LENGTH; i++) {
        y1[i] = 0;
        y2[i] = 0;
        y3[i] = 0;
      }
    }

    void graphDraw2(float _y1, float _y2, float _y3) {
      y1[X_LENGTH - 1] = _y1;
      y2[X_LENGTH - 1] = _y2;
      y3[X_LENGTH - 1] = _y3;
      for (int i = 0; i < X_LENGTH - 1; i++) {
        y1[i] = y1[i + 1];
        y2[i] = y2[i + 1];
        y3[i] = y3[i + 1];
      }
      maxRange = 1;
      for (int i = 0; i < X_LENGTH - 1; i++) {
        maxRange = (abs(y1[i]) > maxRange ? abs(y1[i]) : maxRange);
        maxRange = (abs(y2[i]) > maxRange ? abs(y2[i]) : maxRange);
        maxRange = (abs(y3[i]) > maxRange ? abs(y3[i]) : maxRange);
      }

      pushMatrix();

      translate(X_POSITION, Y_POSITION);
      fill(240);
      stroke(130);
      strokeWeight(1);
      rect(0, 0, X_LENGTH, Y_LENGTH);
      line(0, Y_LENGTH / 2, X_LENGTH, Y_LENGTH / 2);

      textSize(25);
      fill(60);
      textAlign(LEFT, BOTTOM);
      text(TITLE, 20, -5);
      textSize(22);
      textAlign(RIGHT);
      text(0, -5, Y_LENGTH / 2 + 7);
      text(nf( maxRange , 0, 1), -5, 18);
      text(nf(-1 *  maxRange , 0, 1), -5, Y_LENGTH);

      translate(0, Y_LENGTH / 2);
      scale(1, -1);
      strokeWeight(1);
      for (int i = 0; i < X_LENGTH - 1; i++) {
        stroke(255, 0, 0);
        line(i, y1[i] * (Y_LENGTH / 2) /  maxRange , i + 1, y1[i + 1] * (Y_LENGTH / 2) / maxRange);
        stroke(255, 0, 255);
        line(i, y2[i] * (Y_LENGTH / 2) /  maxRange , i + 1, y2[i + 1] * (Y_LENGTH / 2) / maxRange);
        stroke(0, 0, 0);
        line(i, y3[i] * (Y_LENGTH / 2) /  maxRange , i + 1, y3[i + 1] * (Y_LENGTH / 2) / maxRange);
      }
      popMatrix();
    }
}
class graphMonitor3 {
    String TITLE;
    int X_POSITION, Y_POSITION;
    int X_LENGTH, Y_LENGTH;
    float [] y1, y2, y3;
    float maxRange;
    graphMonitor3(String _TITLE, int _X_POSITION, int _Y_POSITION, int _X_LENGTH, int _Y_LENGTH) {
      TITLE = _TITLE;
      X_POSITION = _X_POSITION;
      Y_POSITION = _Y_POSITION;
      X_LENGTH   = _X_LENGTH;
      Y_LENGTH   = _Y_LENGTH;
      y1 = new float[X_LENGTH];
      y2 = new float[X_LENGTH];
      y3 = new float[X_LENGTH];
      for (int i = 0; i < X_LENGTH; i++) {
        y1[i] = 0;
        y2[i] = 0;
        y3[i] = 0;
      }
    }

    void graphDraw3(float _y1, float _y2, float _y3) {
      y1[X_LENGTH - 1] = _y1;
      y2[X_LENGTH - 1] = _y2;
      y3[X_LENGTH - 1] = _y3;
      for (int i = 0; i < X_LENGTH - 1; i++) {
        y1[i] = y1[i + 1];
        y2[i] = y2[i + 1];
        y3[i] = y3[i + 1];
      }
      maxRange = 1;
      for (int i = 0; i < X_LENGTH - 1; i++) {
        maxRange = (abs(y1[i]) > maxRange ? abs(y1[i]) : maxRange);
        maxRange = (abs(y2[i]) > maxRange ? abs(y2[i]) : maxRange);
        maxRange = (abs(y3[i]) > maxRange ? abs(y3[i]) : maxRange);
      }

      pushMatrix();

      translate(X_POSITION, Y_POSITION);
      fill(240);
      stroke(130);
      strokeWeight(1);
      rect(0, 0, X_LENGTH, Y_LENGTH);
      line(0, Y_LENGTH / 2, X_LENGTH, Y_LENGTH / 2);

      textSize(25);
      fill(60);
      textAlign(LEFT, BOTTOM);
      text(TITLE, 20, -5);
      textSize(22);
      textAlign(RIGHT);
      text(0, -5, Y_LENGTH / 2 + 7);
      text(nf( maxRange , 0, 1), -5, 18);
      text(nf(-1 *  maxRange , 0, 1), -5, Y_LENGTH);

      translate(0, Y_LENGTH / 2);
      scale(1, -1);
      strokeWeight(1);
      for (int i = 0; i < X_LENGTH - 1; i++) {
        stroke(255, 0, 0);
        line(i, y1[i] * (Y_LENGTH / 2) /  maxRange , i + 1, y1[i + 1] * (Y_LENGTH / 2) / maxRange);
        stroke(255, 0, 255);
        line(i, y2[i] * (Y_LENGTH / 2) /  maxRange , i + 1, y2[i + 1] * (Y_LENGTH / 2) / maxRange);
        stroke(0, 0, 0);
        line(i, y3[i] * (Y_LENGTH / 2) /  maxRange , i + 1, y3[i + 1] * (Y_LENGTH / 2) / maxRange);
      }
      popMatrix();
    }
}
class graphMonitor4 {
    String TITLE;
    int X_POSITION, Y_POSITION;
    int X_LENGTH, Y_LENGTH;
    float [] y1, y2, y3;
    float maxRange;
    graphMonitor4(String _TITLE, int _X_POSITION, int _Y_POSITION, int _X_LENGTH, int _Y_LENGTH) {
      TITLE = _TITLE;
      X_POSITION = _X_POSITION;
      Y_POSITION = _Y_POSITION;
      X_LENGTH   = _X_LENGTH;
      Y_LENGTH   = _Y_LENGTH;
      y1 = new float[X_LENGTH];
      y2 = new float[X_LENGTH];
      y3 = new float[X_LENGTH];
      for (int i = 0; i < X_LENGTH; i++) {
        y1[i] = 0;
        y2[i] = 0;
        y3[i] = 0;
      }
    }

    void graphDraw4(float _y1, float _y2, float _y3) {
      y1[X_LENGTH - 1] = _y1;
      y2[X_LENGTH - 1] = _y2;
      y3[X_LENGTH - 1] = _y3;
      for (int i = 0; i < X_LENGTH - 1; i++) {
        y1[i] = y1[i + 1];
        y2[i] = y2[i + 1];
        y3[i] = y3[i + 1];
      }
      maxRange = 1;
      for (int i = 0; i < X_LENGTH - 1; i++) {
        maxRange = (abs(y1[i]) > maxRange ? abs(y1[i]) : maxRange);
        maxRange = (abs(y2[i]) > maxRange ? abs(y2[i]) : maxRange);
        maxRange = (abs(y3[i]) > maxRange ? abs(y3[i]) : maxRange);
      }

      pushMatrix();

      translate(X_POSITION, Y_POSITION);
      fill(240);
      stroke(130);
      strokeWeight(1);
      rect(0, 0, X_LENGTH, Y_LENGTH);
      line(0, Y_LENGTH / 2, X_LENGTH, Y_LENGTH / 2);

      textSize(25);
      fill(60);
      textAlign(LEFT, BOTTOM);
      text(TITLE, 20, -5);
      textSize(22);
      textAlign(RIGHT);
      text(0, -5, Y_LENGTH / 2 + 7);
      text(nf( maxRange , 0, 1), -5, 18);
      text(nf(-1 *  maxRange , 0, 1), -5, Y_LENGTH);

      translate(0, Y_LENGTH / 2);
      scale(1, -1);
      strokeWeight(1);
      for (int i = 0; i < X_LENGTH - 1; i++) {
        stroke(255, 0, 0);
        line(i, y1[i] * (Y_LENGTH / 2) /  maxRange , i + 1, y1[i + 1] * (Y_LENGTH / 2) / maxRange);
        stroke(255, 0, 255);
        line(i, y2[i] * (Y_LENGTH / 2) /  maxRange , i + 1, y2[i + 1] * (Y_LENGTH / 2) / maxRange);
        stroke(0, 0, 0);
        line(i, y3[i] * (Y_LENGTH / 2) /  maxRange , i + 1, y3[i + 1] * (Y_LENGTH / 2) / maxRange);
      }
      popMatrix();
    }
}

import processing.serial.*;                                   //ライブラリインポート
float gx, gy, gz, ax, ay, az, mx, my, mz;                     //ジャイロ、加速度、地磁気の値
float gx2,gy2,gz2, x2,y2,z2;
////////////////////////////////////////波形保存////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
double[][] gx1,    gy1,    gz1;

///////////////////////////////////////1サイクルの合計//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
double[]   sgx_1,  sgy_1,  sgz_1;

////////////////////////////////////////////1サイクルの平均/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
double[]   avgx_1, avgy_1, avgz_1;

/////////////////////////////////////////分散///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
double[]   gxs_1,  gys_1,  gzs_1;

//////////////////////////////////////////平均波////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
double[]   avgx1,  avgy1,  avgz1;
double[]   avgx2,  avgy2,  avgz2;

/////////////////////////////////////////分散逆数・ゲイン////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
double[]   a1,     a2,     a3;
double     S1=0,   S2=0,   S3=0,   S4=0,   S5=0,   S6=0,   S7=0,   S8=0,   S9=0,   K=1,   k1=5, k2=100;

/////////////////////////////////////////////その他/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
double     x=0,    y=0,    z=0;
double     x1,     y1,     z1;
/*float gx1, gy1, gz1;                                          //補正後ジャイロ*/
float pgx=0, pgy=0, pgz=0;                                    //前の状態のジャイロ
float gxt=0, gyt=0, gzt=0;                                    //角度
/*float x=0, y=0, z=0;                                          //測定時の変化量（ジャイロ）*/
float px=0, py=0, pz=0;                                       //前の状態の変化量
float sgx=0, sgy=0, sgz=0, avgx=0, avgy=0, avgz=0;            //平均値をとる
int num=0, n=0, num1=0, num2=0, num3=0, n1=10, n2=20, a=0;                                       //カウント
int serialTimer;                                              //カウント
Serial myPort;                                                //シリアルポート開始
graphMonitor1 testGraph1;                                     //
graphMonitor2 testGraph2;                                     //
graphMonitor3 testGraph3;                                     //
graphMonitor4 testGraph4;                                     //グラフ準備     

void setup() {
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                 /*配列宣言*/
//g値

    gx1=new double[n1+1][n2];     
    gy1=new double[n1+1][n2];
    gz1=new double[n1+1][n2];  
  
//sum値

    sgx_1=new double[n1+1];
    sgy_1=new double[n1+1];
    sgz_1=new double[n1+1];
    for(int i=0; i<=n1; i++){
        sgx_1[i]=0;
        sgy_1[i]=0;
        sgz_1[i]=0;
    }

//av値

    avgx_1=new double[n1+1];
    avgy_1=new double[n1+1];
    avgz_1=new double[n1+1];
  
//s値
  
    gxs_1=new double[n1+1];
    gys_1=new double[n1+1];
    gzs_1=new double[n1+1];
  

//av波

    avgx1=new double[n2];  
    avgy1=new double[n2];
    avgz1=new double[n2];    
    avgx2=new double[n2];  
    avgy2=new double[n2];
    avgz2=new double[n2];   
  
//分散ゲイン
  
    a1=new double[n1];
    a2=new double[n1];
    a3=new double[n1];
  /*size(500, 500);*/
  size(1920, 1080, P3D);
  frameRate(100);
  smooth();
  testGraph1 = new graphMonitor1("gylo'", 70, 50, 800, 400);
  testGraph2 = new graphMonitor2("gylo", 70, 500, 800, 400);
  testGraph3 = new graphMonitor3("angle", 1000, 500, 800, 400);
  testGraph4 = new graphMonitor4("angle'", 1000, 50, 800, 400);
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
        gx/=10000.0;
        gy/=10000.0;
        gz/=10000.0;
        gx+=0.01;
        gy+=-0.01-0.0025;
        gz+=0.01-0.00152;
        /*gx1=gx;
        gy1=gy;
        gz1=gz;*/
        ax/=100.0;
        ay/=100.0;
        az/=100.0;
        mx/=100.0;
        my/=100.0;
        mz/=100.0;
        /*gx1-=avgx;
        gy1-=avgy;
        gz1-=avgz;*/
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
 
                                                                                  /*g補正ステップ*/
                                                                                
    //第一フェーズ
    if(num2<n1 && num3<n2){
      
        //波の保存  
        gx1[num2][num3]=gx;
        gy1[num2][num3]=gy;
        gz1[num2][num3]=gz;
        
        //波の加算
        sgx_1[num2]+=gx;
        sgy_1[num2]+=gy;
        sgz_1[num2]+=gz;
    }
    
    if(num2<n1 && num3==n2){
      
        //波の平均  
        avgx_1[num2]=sgx_1[num2]/n2;
        avgy_1[num2]=sgy_1[num2]/n2;
        avgz_1[num2]=sgz_1[num2]/n2;
        
        //波の分散（信頼度）算出
        for(int i=0; i<n2; i++){
            gxs_1[num2]+=sq((float)gx1[num2][i]-(float)avgx_1[num2]);
            gys_1[num2]+=sq((float)gy1[num2][i]-(float)avgy_1[num2]);
            gzs_1[num2]+=sq((float)gz1[num2][i]-(float)avgz_1[num2]);
        }
        gxs_1[num2]=sqrt((float)gxs_1[num2]/num3);
        gys_1[num2]=sqrt((float)gys_1[num2]/num3);
        gzs_1[num2]=sqrt((float)gys_1[num2]/num3);
        sgx_1[num2]=0;
        sgy_1[num2]=0;
        sgz_1[num2]=0;                     //合計リセット
        num3=0;                            //波リセット
        num2++;                            //波切り替え
        
        //num3=0の時の値保存
        if(num2<n1){
            gx1[num2][num3]=gx;
            gy1[num2][num3]=gy;
            gz1[num2][num3]=gz;
            sgx_1[num2]+=gx;
            sgy_1[num2]+=gy;
            sgz_1[num2]+=gz;
        }
  
        //第二フェーズ
        if(num2==n1){
  
            //必要データ取得
            for(int j=0; j<n1; j++){
              
                if(gxs_1[j]==0){
                  gxs_1[j]=0.01;
                }
                
                a1[j]=1/gxs_1[j];
                
                if(gys_1[j]==0){
                  gys_1[j]=0.01;
                }
                
                a2[j]=1/gys_1[j];
                
                if(gzs_1[j]==0){
                  gzs_1[j]=0.01;
                }
                
                a3[j]=1/gzs_1[j];
                S1+=a1[j];
                S2+=a2[j];
                S3+=a3[j];
            }

            //平均波記憶
            for(int i=0; i<n2; i++){
                for(int j=0; j<n1; j++){
                    avgx1[i]+=gx1[j][i]*a1[j];
                    avgy1[i]+=gy1[j][i]*a2[j];
                    avgz1[i]+=gz1[j][i]*a3[j];
                }
                avgx1[i]/=S1;
                avgy1[i]/=S2;
                avgz1[i]/=S3;
            }
          num3=0;      //波リセット
          }
      }
  
    //第三フェーズ
    //平均波、平均ドリフトで引く
    if(num3<n2&&num2==n1){
        gx2=gx-(float)avgx1[num3];
        gy2=gy-(float)avgy1[num3];
        gz2=gz-(float)avgz1[num3];
          
        //波形保存
        gx1[n1][num3]=gx2;
        gy1[n1][num3]=gy2;
        gz1[n1][num3]=gz2;
        sgx_1[n1]+=gx2;
        sgy_1[n1]+=gy2;
        sgz_1[n1]+=gz2;
        num1++;           //タイム加算
    }
    
    //第四フェーズ
    if(num2==n1 && num3==n2){
    
        //平均算出
        avgx_1[n1]=sgx_1[n1]/num3;
        avgy_1[n1]=sgy_1[n1]/num3;
        avgz_1[n1]=sgz_1[n1]/num3;
       
        //合計リセット
        sgx_1[n1]=0;
        sgy_1[n1]=0;
        sgz_1[n1]=0;
       
        //分散算出
        for(int i=0; i<n2; i++){
            gxs_1[n1]+=sq((float)gx1[n1][i]);
            gys_1[n1]+=sq((float)gy1[n1][i]);
            gzs_1[n1]+=sq((float)gy1[n1][i]);
        }
   
        gxs_1[n1]=sqrt((float)gxs_1[n1]/num3);
        gys_1[n1]=sqrt((float)gys_1[n1]/num3);
        gzs_1[n1]=sqrt((float)gzs_1[n1]/num3);
    
        //記憶フェーズ
        //g値保存
        for(int i=0; i<n2; i++){
            for(int j=0; j<n1; j++){
                gx1[j][i]=gx1[j+1][i];
                gy1[j][i]=gy1[j+1][i];
                gz1[j][i]=gz1[j+1][i];
            }
        }

    
        //平均、分散保存
        for(int i=0; i<n1; i++){
            gxs_1[i]=gxs_1[i+1];
            gys_1[i]=gys_1[i+1];
            gzs_1[i]=gzs_1[i+1];
            avgx_1[i]=avgx_1[i+1];
            avgy_1[i]=avgy_1[i+1];
            avgz_1[i]=avgz_1[i+1];
        }
           
        //平均波更新
        for(int j=0; j<n1; j++){
            
            if(gxs_1[j]==0){
                  gxs_1[j]=0.01;
            }
            
            a1[j]=1/gxs_1[j];
            
            if(gys_1[j]==0){
                gys_1[j]=0.01;
            }
            
            a2[j]=1/gys_1[j];
            
            if(gzs_1[j]==0){
                gzs_1[j]=0.01;
            }
            
            a3[j]=1/gzs_1[j];
            S1+=a1[j];
            S2+=a2[j];
            S3+=a3[j];
        }
       
        S4=k1*S1;
        S5=k1*S2;
        S6=k1*S3;
        S7=S1+S4;
        S8=S2+S5;
        S9=S3+S6;
    
        for(int i=0; i<n2; i++){
            avgx1[i]+=avgx1[i]*S4;
            avgy1[i]+=avgy1[i]*S5;
            avgz1[i]+=avgz1[i]*S6;
            for(int j=0; j<n1; j++){
                avgx1[i]+=gx1[j][i]*a1[j];
                avgy1[i]+=gy1[j][i]*a2[j];
                avgz1[i]+=gz1[j][i]*a3[j];
            }
            avgx1[i]/=S7;
            avgy1[i]/=S8;
            avgz1[i]/=S9;
        }
        num1++;               //安定タイム加算
        num3=0;               //波リセット
      }
  
  /*if(num>1){                       ///////////////////////////////////////////////////////////////////////
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
    }                              //////////////////////////////////////////////////////////////////////*/
    /*if(num>=200){
    gxt+=gx1;
    gyt+=gy1;
    gzt+=gz1;
    }
  gx1-=avgx;
  gy1-=avgy;
  gz1-=avgz;*/
  if(num1>=250){
        x+=gx;
        y+=gy;
        z+=gz;
        x2+=gx2;
        y2+=gy2;
        z2+=gz2;
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    }
  background(250);
  testGraph1.graphDraw1(gx2*1000, gy2*1000, gz2*1000);
  testGraph2.graphDraw2(gx*1000, gy*1000, gz*1000);
  testGraph3.graphDraw3(x2, y2, z2);
  testGraph4.graphDraw4((float)x, (float)y, (float)z);
  /*px=x;
  py=y;
  pz=z;*/
  /*pgx=gx;
  pgy=gy;
  pgz=gz;*/
  num3++;
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

import processing.serial.*;
float pi=3.141592;
float gx, gy, gz, ax, ay, az;
float sgx=0,sgy=0,sgz=0,avgx=0,avgy=0,avgz=0,x=0,y=0,z=0;
float dtx=0,dty=0,dtz=0;
float K=0.95,k=0.05;
float roll=0,pitch=0;
float r=0,p=0,R,P;
float pgx=0, pgy=0, pgz=0;
float mx, my, mz,Mx, My, Mz;
float rangex, rangey, rangez;
int n=0, m=0;
int serialTimer;
int num=0,numt=0,numav=0;
Serial myPort;
graphMonitor1 testGraph1;
graphMonitor2 testGraph2;

void setup() {
  /*size(500, 500);*/
  size(1920, 1080, P3D);
  frameRate(100);
  smooth();
  testGraph1 = new graphMonitor1("g", 100, 50, 1000, 400);
  testGraph2=  new graphMonitor2("a", 100, 590, 1000,400);
  myPort = new Serial(this, "COM4", 57600);
}

void draw() {
    num+=1;
  if(num>=500){
    numav+=1;
    numt+=1;
  }
  if (millis()-serialTimer > 50) {
    serialTimer = millis();
    byte[] inBuf = new byte[14];
    println(myPort.available());
    if (myPort.available() == 14) {
      myPort.readBytes(inBuf);
      if (inBuf[0]=='s'&&inBuf[13]=='e') {
        gx = (inBuf[1]<<8)+(inBuf[2]&0xff);
        gy = (inBuf[3]<<8)+(inBuf[4]&0xff);
        gz = (inBuf[5]<<8)+(inBuf[6]&0xff);
        ax = (inBuf[7]<<8)+(inBuf[8]&0xff);
        ay = (inBuf[9]<<8)+(inBuf[10]&0xff);
        az = (inBuf[11]<<8)+(inBuf[12]&0xff);
        gx/=100.0;
        gy/=100.0;
        gz/=100.0;
        ax/=100.0;
        ay/=100.0;
        az/=100.0;
        gx+=4.60;
        gy+=0.26;
        gz-=0.23;
        ax+=-0.08;
        ay+=-0.03;
        az+=-0.05;
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
    if(gx>pgx&&n==0){
    n=1;
  }else if(gx<pgx&&n==0){
    n=2;
  }
  if(n==1){
    if(gx>pgx&&m==0){
      mx=pgx;
      rangex=Mx-mx;
      m=1;
    }else if(gx<pgx&&m==1){
      Mx=pgx;
      rangex=Mx-mx;
      m=0;
    }
  }else if(n==2){
    if(gx<pgx&&m==0){
      mx=pgx;
      rangex=Mx-mx;
      m=1;
    }else if(gx>pgx&&m==1){
      Mx=pgx;
      rangex=Mx-mx;
      m=0;
    }
  }
  
    if(num>=100){
    numt+=1;
    sgx+=gx;
    sgy+=gy;
    sgz+=gz;
    avgx=sgx/num;   
    avgy=sgy/num;
    avgz=sgz/num;

    x=gx-avgx;
    y=gy-avgy;
    z=gz-avgz;
  }
  
  if(num>=1000){
    dtx+=x;
    dty+=y;
    dtz+=z;
  }
  
  if(numt==10){
    numt=0;
  }
  
  if(ax>=1){
    ax=1;
  }else if(ay>=1){
    ay=1;
  }else if(az>=1){
    az=1;
  }else{
  }
  
  roll=atan(ay/az);
  pitch=-atan(ax/sqrt(ay*ay+az*az));
  
  R=(roll-r)*10000*pi/180;
  P=(pitch-p)*10000*pi/180;
  
  r=roll;
  p=pitch;
  
  gx=K*gx+k*R;
  gy=K*gy+k*P;
  
  text(nf(rangex, 0, 2), 80, 530);
  
  background(250);
  testGraph1.graphDraw(gx, dty, dtz);
  testGraph2.graphDraw(0,0,rangex);
  pgx=gx;
  pgy=gy;
  pgz=gz;
}

void plint_tex(){
  text("gx:", 10, 50);
  text("gy:", 10, 80);
  text("gz:", 10, 110);
  text("ax:", 10, 140);
  text("ay:", 10, 170);
  text("az:", 10, 200);
}
/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
class graphMonitor1 {                                                                              /*graph1*/
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

    void graphDraw(float _y1, float _y2, float _y3) {
      y1[X_LENGTH - 1] = _y1;
      y2[X_LENGTH - 1] = _y2;
      y3[X_LENGTH - 1] = _y3;
      for (int i = 0; i < X_LENGTH - 1; i++) {
        y1[i] = y1[i + 1];
        y2[i] = y2[i + 1];
        y3[i] = y3[i + 1];
      }
      maxRange = 0.01;
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
      text(gz,1500,30);
      text(gy,1500,60);
      text(gz,1500,90);
    }
}
/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
class graphMonitor2 {                                                                                /*graph2*/
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

    void graphDraw(float _y1, float _y2, float _y3) {
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

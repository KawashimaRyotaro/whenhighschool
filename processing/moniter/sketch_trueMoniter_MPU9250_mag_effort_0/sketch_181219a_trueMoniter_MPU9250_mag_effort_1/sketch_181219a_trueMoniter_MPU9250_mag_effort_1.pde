import processing.serial.*;
float gx, gy, gz, ax, ay, az, mx, my, mz;
float pmx1, pmy1, pmz1, pmx2, pmy2, pmz2; 
float Mx, My, Mz, mix, miy, miz; 
float x=0, y=0, z=0;
float x1, y1, z1;
int num=0, num1=0, n=40, num2=0, i=0;
int serialTimer;
Serial myPort;

void setup() {
  size(740, 660, P3D);
  myPort = new Serial(this, "COM4", 57600);
}

void draw() {
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
        gy+=-0.01;
        gz+=0.01;
        ax/=100.0;
        ay/=100.0;
        az/=100.0;
        mx/=100.0;
        my/=100.0;
        mz/=100.0;
        mx=(mx+1)/39;
        my=(my-10.5)/37.5;
        mz=(mz-27)/39;
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
  if(ax>=100){
    ax=100;
  }else if(ax<=-100){
    ax=-100;
  }else if(ay>=100){
    ay=100;
  }else if(ay<=-100){
    ay=-100;
  }else if(az>=100){
    az=100;
  }else if(az<=-100){
    az=-100;
  }
  
  if(i==0){
    Mx=mx;
    My=my;
    Mz=mz;
    mix=mx;
    miy=my;
    miz=mz;
    i++;
  }
  
  if(mx>Mx){
    Mx=mx;
  }
  if(my>My){
    My=my;
  }
  if(mz>Mz){
    Mz=mz;
  }
  if(mx<mix){
    mix=mx;
  }
  if(my<miy){
    miy=my;
  }
  if(mz<miz){
    miz=mz;
  }
  
  if(num2>=1000){
    x+=gx;
    y+=gy;
    z+=gz;
  }
  
  background(0);
  fill(240);
  textSize(24);
  plint_tex();
  text(nf(gx*10000, 0, 2), 50, 50);
  text(nf(gy*10000, 0, 2), 50, 80);
  text(nf(gz*10000, 0, 2), 50, 110);
  text(nf(ax, 0, 2), 50, 140);
  text(nf(ay, 0, 2), 50, 170);
  text(nf(az, 0, 2), 50, 200);
  text(nf(mx, 0, 2), 50, 230);
  text(nf(my, 0, 2), 50, 260);
  text(nf(mz, 0, 2), 50, 290);
  text(nf(x, 0, 2), 50, 320);
  text(nf(y, 0, 2), 50, 350);
  text(nf(z, 0, 2), 50, 380);
  text(nf(mix, 0, 2), 70, 500);
  text(nf(miy, 0, 2), 70, 530);
  text(nf(miz, 0, 2), 70, 560);
  text(nf(Mx, 0, 2), 50, 590);
  text(nf(My, 0, 2), 50, 620);
  text(nf(Mz, 0, 2), 50, 650);
  num++;
  num2++;
}

void plint_tex(){
  text("gx:", 10, 50);
  text("gy:", 10, 80);
  text("gz:", 10, 110);
  text("ax:", 10, 140);
  text("ay:", 10, 170);
  text("az:", 10, 200);
  text("mx:", 10, 230);
  text("my:", 10, 260);
  text("mz:", 10, 290);
  text("x:", 10, 320);
  text("y:", 10, 350);
  text("z:", 10, 380);
  text("x1:", 10, 410);
  text("y1:", 10, 440);
  text("z1:", 10, 470);
  text("mix:", 10, 500);
  text("miy:", 10, 530);
  text("miz:", 10, 560);
  text("Mx:", 10, 590);
  text("My:", 10, 620);
  text("Mz:", 10, 650);
}

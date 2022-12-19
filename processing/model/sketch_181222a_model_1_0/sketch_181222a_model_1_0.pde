import processing.serial.*;
import processing.opengl.*;
float pi=3.141592;
float gx, gy, gz, ax, ay, az;
float sgx=0,sgy=0,sgz=0,avgx=0,avgy=0,avgz=0,psgx=0,psgy=0,psgz=0;
float pgx=0,pgy=0,pgz=0;
float a1,a2,a3;
float K=0.95,k=0.05;
float roll=0,pitch=0;
float r=0,p=0,R,P;
int serialTimer;
int num=0,numt=0,numav=0;
Serial myPort;
int t1=0,t2=0;

void setup() {
  myPort = new Serial(this, "COM4", 57600);
  size(1000,1000,OPENGL);
  frameRate(60);
  fill(0,130,130);
  stroke(255);
  rectMode(CENTER);
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
        ax+=0.039-0.07;
        ay+=0;
        az-=0.19;
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
  
  if(ax>=1){
    ax=1;
  }else if(ay>=1){
    ay=1;
  }else if(az>=1){
    az=1;
  }else if(ax<=-1){
    ax=-1;
  }else if(ay<=-1){
    ay=-1;
  }else if(az<=-1){
    az=-1;
  }
  
  roll=atan(ay/az);
  pitch=-atan(ax/sqrt(ay*ay+az*az));
  
  R=(roll-r)*10000*pi/180;
  P=(pitch-p)*10000*pi/180;
  
  r=roll;
  p=pitch;
  
  gx=K*gx+k*R;
  gy=K*gy+k*P;
     
  background(255);
  translate(width/2,height/2);
    
  pushMatrix();
    
  rotateX(-pitch);
  rotateZ(-roll);
  
  /*stroke(255,0,0);//red z
  line(0,0,0,0,0,100);
  stroke(0,0,255);//blue y
  line(0,-100,0,0,0,0);
  stroke(0,255,0);//green x
  line(0,0,0,100,0,0);*/
  
  stroke(0,90,90);
  fill(0,130,130);
  box(300,10,200);
  
  stroke(0);
  fill(80);
  
  translate(60,-10,90);
  box(170,20,10);
  
  translate(-20,0,-180);
  box(210,20,10);
  
  popMatrix();
  
  translate(-width/2,-height/2);
  
  fill(0);
  textSize(24);
  text("gx:"+nf(gx, 0, 2), 50, 50);
  text("gy:"+nf(gy, 0, 2), 50, 80);
  text("gz:"+nf(gz, 0, 2), 50, 110);
  text("ax:"+nf(ax, 0, 2), 50, 140);
  text("ay:"+nf(ay, 0, 2), 50, 170);
  text("az:"+nf(az, 0, 2), 50, 200);
  text("roll:"+nf(degrees(roll), 0, 2), 50, 230);
  text("pitch:"+nf(degrees(pitch), 0, 2), 50, 260);
  text("num:", 50, 290);
  text("avgx:", 50, 320);
  text("avgy:", 50, 350);
  text("avgz:", 50, 380);
  text(nf(numt, 0, 2), 120, 290);
  text(nf(avgx, 0, 2), 120, 320);
  text(nf(P, 0, 2), 120, 350);
  text(nf(R, 0, 2), 120, 380);
}

void drawArduino()
{
  stroke(0,90,90);
  fill(0,130,130);
  box(300,10,200);
  
  stroke(0);
  fill(80);
  
  translate(60,-10,90);
  box(170,20,10);
  
  translate(-20,0,-180);
  box(210,20,10);
}

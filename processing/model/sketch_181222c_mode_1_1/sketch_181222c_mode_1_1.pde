import processing.serial.*;
import processing.opengl.*;
float gx, gy, gz, ax, ay, az, mx, my, mz;
int serialTimer;
Serial myPort;

void setup() {
  myPort = new Serial(this, "COM4", 57600);
  size(1000,1000,OPENGL);
  frameRate(60);
  fill(0,130,130);
  stroke(255);
  rectMode(CENTER);
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
                ax/=100.0;
                ay/=100.0;
                az/=100.0;
                mx/=100.0;
                my/=100.0;
                mz/=100.0;
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
  
  float roll=atan(ay/az);
  float pitch=-atan(ax/sqrt(ay*ay+az*az));
  
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
  
  /*background(0);
  fill(240);
  textSize(24);
  text("gx:"+nf(gx, 0, 2), 50, 50);
  text("gy:"+nf(gy, 0, 2), 50, 80);
  text("gz:"+nf(gz, 0, 2), 50, 110);
  text("ax:"+nf(ax, 0, 2), 50, 140);
  text("ay:"+nf(ay, 0, 2), 50, 170);
  text("az:"+nf(az, 0, 2), 50, 200);
  text("roll:"+nf(degrees(roll), 0, 2), 50, 230);
  text("pitch:"+nf(degrees(pitch), 0, 2), 50, 260);
  delay(100);*/
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

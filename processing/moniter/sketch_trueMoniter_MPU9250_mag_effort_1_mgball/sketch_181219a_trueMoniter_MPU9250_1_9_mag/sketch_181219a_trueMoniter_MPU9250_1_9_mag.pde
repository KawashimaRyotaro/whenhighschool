import processing.serial.*;
float gx, gy, gz, ax, ay, az;
float th,th3;
float mx,my,mz;
float[] pmx,pmy,pmz;
float pmx1, pmy1, pmz1, pmx2, pmy2, pmz2; 
float Mx, My, Mz, mix, miy, miz; 
float x=0, y=0, z=0;
float x1, y1, z1;
float a,b,c,d;
float ROLL, PITCH, YAW;
float th1, th2;
int num=0, num1=0, n=40, num2=0, i=0;
int serialTimer;
Serial myPort;

void setup() {
  pmx=new float[100000];
  pmy=new float[100000];
  pmz=new float[100000];
  size(1920, 1080, P3D);
  background(255);
  noFill();
  strokeWeight(2);
  translate(width/2, height/2);
  rotateX(45);
  rotateY(45);
  //rotateZ(45);
  stroke(255,0,0);
  line(-1000,0,0,1000,0,0);
  stroke(0,255,0);
  line(0,-1000,0,0,1000,0);
  stroke(125,0,0);
  line(0,0,-1000,0,0,1000);
  myPort = new Serial(this, "COM4", 57600);
}

void draw() {
    if(i<100000){
      pmx[i]=mx;
      pmy[i]=my;
      pmz[i]=mz;
    }
    a=map(mouseY,0,height,HALF_PI,-HALF_PI);
    b=map(mouseX,0,width,-HALF_PI,HALF_PI);
    pushMatrix();
    background(255);
    translate(width/2, height/2);
    rotateX(a);
    rotateY(b);
    //rotateZ(45);
    stroke(255,0,0);
    line(-1000,0,0,1000,0,0);
    stroke(0,255,0);
    line(0,-1000,0,0,1000,0);
    stroke(125,0,0);
    line(0,0,-1000,0,0,1000);
    if (millis()-serialTimer > 50) {
        serialTimer = millis();
        byte[] inBuf = new byte[26];
        println(myPort.available());
        if (myPort.available() == 26) {
            myPort.readBytes(inBuf);
            if (inBuf[0]=='s'&&inBuf[25]=='e') {
                ROLL  = (inBuf[1]<<8)+(inBuf[2]&0xff);
                PITCH = (inBuf[3]<<8)+(inBuf[4]&0xff);
                YAW   = (inBuf[5]<<8)+(inBuf[6]&0xff);
                gx = (inBuf[13]<<8)+(inBuf[14]&0xff);
                gy = (inBuf[15]<<8)+(inBuf[16]&0xff);
                gz = (inBuf[17]<<8)+(inBuf[18]&0xff);
                ax = (inBuf[7]<<8)+(inBuf[8]&0xff);
                ay = (inBuf[9]<<8)+(inBuf[10]&0xff);
                az = (inBuf[11]<<8)+(inBuf[12]&0xff);
                mx = (inBuf[19]<<8)+(inBuf[20]&0xff);
                my = (inBuf[21]<<8)+(inBuf[22]&0xff);
                mz = (inBuf[23]<<8)+(inBuf[24]&0xff);
                ROLL/=100.0;
                PITCH/=100.0;
                YAW/=100.0;
                gx/=100.0;
                gy/=100.0;
                gz/=100.0;
                gx+=0.01;
                gy+=-0.01;
                gz+=0.01;
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
  if(i==10){
    th=degrees(atan(my/mx));
    th3=degrees(atan(my/mz));
  }
  th1=degrees(atan(my/mx));
  th2=degrees(atan(my/mz));
  th1-=th;
  th2-=th3;
    
  for(int j=0;j<=i;j++){
    point(pmx[j],pmz[j],pmy[j]);
  }
  
  /*if(i==0){
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
  }*/
  
  if(num2>=1000){
    x+=gx;
    y+=gy;
    z+=gz;
  }
  
 /*background(0);*/
  fill(0);
  textSize(24);
  text(nf(th1, 0, 2), 0,50, 320);
  text(nf(th2, 0, 2), 0,50, 350);
  plint_tex();
  text(nf(gx*10000, 0, 2), 50, 50);
  text(nf(gy*10000, 0, 2), 50, 80);
  text(nf(gz*10000, 0, 2), 50, 110);
  text(nf(ax, 0, 2), 50, 140);
  text(nf(ay, 0, 2), 50, 170);
  text(nf(az, 0, 2), 50, 200);
  text(nf(mx, 0, 2), 0,50, 230);
  text(nf(my, 0, 2), 0,50, 260);
  text(nf(mz, 0, 2), 0,50, 290);
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
  popMatrix();
  i++;
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

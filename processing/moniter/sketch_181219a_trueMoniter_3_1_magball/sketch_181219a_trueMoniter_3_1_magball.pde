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
float cR,sR,cP,sP,cY,sY;
float ccR,csR,ccP,csP,ccY,csY;
float pP,pR,pY;
int num=0, num1=0, n=40, num2=0, i=0, k=0;
int serialTimer;
Serial myPort;

void setup() {
  pmx=new float[100000];
  pmy=new float[100000];
  pmz=new float[100000];
  size(1920, 1080, P3D);
  strokeWeight(2);
  myPort = new Serial(this, "COM3", 57600);
}

void draw() {
      background(255);
      textSize(24);
      fill(0);
  
      read();
      
      if(i>0&&(PITCH<=0.05&&PITCH>=-0.05)&&(pP>0.03||pP<-0.03)){
            PITCH=pP;
      }
      if(i>0&&(ROLL<=0.055&&ROLL>=-0.055)&&(pR>0.055||pR<-0.055)){
            ROLL=pR;
      }
  
      ROLL=ROLL*3.1415/180;
      PITCH=PITCH*3.1415/180;
  
      if(i>0&&(PITCH<=0.03&&PITCH>=-0.03)&&(pP>0.06||pP<-0.06)){
            PITCH=pP;
      }
      if(i>0&&(PITCH<=0.001&&PITCH>=-0.001)&&(pP>0.03||pP<-0.03)){
            PITCH=pP;
      }
      if(i>0&&(ROLL<=0.055&&ROLL>=-0.055)&&(pR>0.07||pR<-0.07)){
            ROLL=pR;
      }
      if(i>0&&(ROLL<=0.001&&ROLL>=-0.001)&&(pR>0.055||pR<-0.055)){
            ROLL=pR;
      }
      if(i>0&&ROLL==0){
            ROLL=pR;
      }
      
      
      cR=cos(-ROLL);
      sR=sin(-ROLL);
      cP=cos(-PITCH);
      sP=sin(-PITCH);
      ccR=cos(ROLL);
      csR=sin(ROLL);
      ccP=cos(PITCH);
      csP=sin(PITCH);
      
      float   q=my*ccR-mz*csR;
      float  q1=mz*ccR+my*csR;//ROLL補正
  
      float q_1=mx*ccP+mz*csP;
             q1=-mx*csP+mz*ccP;//PITCH 補正*/
  
      if(i<100000){
            pmx[i]=q_1;
            pmz[i]=q1;
            pmy[i]=q;
      }
      
      YAW=atan2(q_1,q);
      
      cY=cos(-YAW);
      sY=sin(-YAW);
      ccY=cos(YAW);
      csY=sin(YAW);
      
      mouse_rotate();
  
      pushMatrix();
    
      make_field(a,b);
        
      for(int j=0;j<=i;j++){
            point(pmx[j]*10,-pmy[j]*10,pmz[j]*10);
      }
        
      line(0,0,0,q_1*10,-q*10,0);
      
      plint();
      plint_tex();
  
      //translate(width/2,height/2);
      rotateX(-PI/2);
      applyMatrix(cY,0,-sY,0,0,1,0,0,sY,0,cY,0,0,0,0,1);
      applyMatrix(ccR,csR,0,0,-csR,ccR,0,0,0,0,1,0,0,0,0,1);     //pitch(z軸回転）-R
      applyMatrix(1,0,0,0,0,ccP,csP,0,0,-csP,ccP,0,0,0,0,1);   //roll(x軸回転）-P
     // applyMatrix(cY,0,-sY,0,0,1,0,0,sY,0,cY,0,0,0,0,1);
        
      draw_arduino();
  
      plint();
      plint_tex();
  
      popMatrix();
      
      pushMatrix();
      moniter();
      popMatrix();
      
      i++;
      pP=PITCH;
      pR=ROLL;
      pY=YAW;
}






void mouse_rotate(){
      a=map(mouseY,0,height,HALF_PI,-HALF_PI);
      b=map(mouseX,0,width,-HALF_PI,HALF_PI);
}






void make_field(float a,float b){
      translate(width/2, height/2);
      rotateX(PI/2);
      rotateX(a);
      rotateZ(-b);
      
      stroke(255,0,0);
      line(-1000,0,0,1000,0,0);
      for(int p=-1000;p<=1000;p+=10){
        line(p,-5,0,p,5,0);
        line(p,0,-5,p,0,5);
      }
      text("x(+)",500,0,0);
      text("x(-)",-500,0,0);
      
      stroke(0,255,0);
      line(0,-1000,0,0,1000,0);
      for(int p=-1000;p<=1000;p+=10){
        line(-5,p,0,5,p,0);
        line(0,p,-5,0,p,5);
      }
      text("y(-)",0,500,0);
      text("y(+)",0,-500,0);
      
      stroke(125,0,0);
      line(0,0,-1000,0,0,1000);
      for(int p=-1000;p<=1000;p+=10){
        line(-5,0,p,5,0,p);
        line(0,-5,p,0,5,p);
      }
      text("z(+)",0,0,500);
      text("z(-)",0,0,-500);
}






void read(){
      if (millis()-serialTimer > 50) {
            serialTimer = millis();
            byte[] inBuf = new byte[26];
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
                        mx=mx+6;
                        my=my-2;
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
}






void a(){
  
}






void draw_arduino(){
      stroke(0,90,90);
      fill(0,130,130);
      box(300,10,200);
  
      stroke(0);
      fill(80);
  
      translate(60,-10,90);
      box(170,20,10);
  
      translate(-20,0,-180);
      box(210,20,10);
      fill(0);
}






void plint(){
      textSize(24);
      text(nf(PITCH/PI*180, 0, 2), 0,50, 320);
      text(nf(ROLL/PI*180, 0, 2), 0,80, 320);
      text(nf(YAW/PI*180, 0, 2), 0,110, 320);
      text(nf(x, 0, 2), 0,140, 320);
      text(nf(z, 0, 2), 0,170, 320);
      text(nf(y, 0, 2), 0,200, 320);
      text(nf(mx, 0, 2), 0,230, 320);
      text(nf(mz, 0, 2), 0,260, 320);
      text(nf(my, 0, 2), 0,290, 320);
      text(nf(my*cR-mz*sR, 0, 2), 0,320, 320);
}






void plint_tex(){
      text("PITCH:", -100, 50, 320);
      text("ROLL:", -100, 80, 320);
      text("YAW:", -100, 110, 320);
      text("x:", -40, 140, 320);
      text("z:", -40, 170, 320);
      text("y:", -40, 200, 320);
      text("mx:", -40, 230, 320);
      text("mz:", -40, 260, 320);
      text("my:", -40, 290, 320);
}






void moniter(){
      fill(120);
      textSize(10);
      rect(0,0,3*width/5,height/5);
      translate(100,100);
      fill(255);
      
      stroke(255,0,0);
      line(-90,0,0,90,0,0);
      stroke(0,255,0);
      line(0,-90,0,0,90,0);
      text("x(+)",90,0,0);
      text("x(-)",-90,0,0);
      text("y(-)",0,90,0);
      text("y(+)",0,-90,0);
      stroke(0);
      line(0,0,mx*2,-my*2);
      
      translate(width/5,0);
      stroke(255,0,0);
      line(-90,0,0,90,0,0);
      stroke(125,0,0);
      line(0,-90,0,0,90,0);
      text("x(+)",90,0,0);
      text("x(-)",-90,0,0);
      text("z(-)",0,90,0);
      text("z(+)",0,-90,0);
      stroke(0);
      line(0,0,mx*2,-mz*2);
      
      translate(width/5,0);
      stroke(0,255,0);
      line(-90,0,0,90,0,0);
      stroke(125,0,0);
      line(0,-90,0,0,90,0);
      text("y(+)",90,0,0);
      text("y(-)",-90,0,0);
      text("z(-)",0,90,0);
      text("z(+)",0,-90,0);
      stroke(0);
      line(0,0,my*2,-mz*2);
}

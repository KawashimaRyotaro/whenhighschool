import processing.serial.*;
float gx, gy, gz, ax, ay, az;
int serialTimer;
Serial myPort;

void setup() {
  size(500, 500);
  myPort = new Serial(this, "COM4", 57600);
}

void draw() {
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
  
  float roll=atan(ay/az);
  float pitch=-atan(ax/sqrt(ay*ay+az*az));
  
  background(0);
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
  delay(100);
}

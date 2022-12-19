import processing.serial.*;
float gx, gy, gz, ax, ay, az;
int serialTimer;
Serial myPort;
graphMonitor testGraph;

void setup() {
  /*size(500, 500);*/
  size(1920, 1080, P3D);
  frameRate(100);
  smooth();
  testGraph = new graphMonitor("graphTitle", 100, 50, 1000, 400);
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
  
  background(250);
  testGraph.graphDraw(gx, gy, gz);
  
  /*background(0);
  fill(240);
  textSize(24);
  plint_tex();
  text(nf(gx, 0, 2), 50, 50);
  text(nf(gy, 0, 2), 50, 80);
  text(nf(gz, 0, 2), 50, 110);
  text(nf(ax, 0, 2), 50, 140);
  text(nf(ay, 0, 2), 50, 170);
  text(nf(az, 0, 2), 50, 200);*/
}

void plint_tex(){
  text("gx:", 10, 50);
  text("gy:", 10, 80);
  text("gz:", 10, 110);
  text("ax:", 10, 140);
  text("ay:", 10, 170);
  text("az:", 10, 200);
}

class graphMonitor {
    String TITLE;
    int X_POSITION, Y_POSITION;
    int X_LENGTH, Y_LENGTH;
    float [] y1, y2, y3;
    float maxRange;
    graphMonitor(String _TITLE, int _X_POSITION, int _Y_POSITION, int _X_LENGTH, int _Y_LENGTH) {
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

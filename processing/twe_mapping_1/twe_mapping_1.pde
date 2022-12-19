import processing.serial.*;
Serial myport;
float lqi1=0,lqi2=0,lqi3=0;
float PB=pow(10,2.5/10),PR=pow(10,9.19/10);
float G=width*2;

void setup(){
  size(1000,900);
  myport=new Serial(this,"COM3",115200);
}

void draw(){
  background(255);
  textSize(24);
  fill(0);
  int j=0;
  byte[] recv = new byte[5];
  byte[] gavage = new byte[100];
  j=myport.available();
  if(j==5){
    myport.readBytes(recv);
    myport.readBytes(gavage);
    if(recv[0]==0x01&&recv[4]==0x03){
      lqi1=(float)recv[1];
      lqi2=(float)recv[2];
      lqi3=(float)recv[3];
      if(lqi1<0){
        lqi1+=256;
      }
      if(lqi2<0){
        lqi2+=256;
      }
      if(lqi3<0){
        lqi3+=256;
      }
      println("lqi1:"+lqi1+"  lqi2:"+lqi2+"  lqi3:"+lqi3);
      println((byte)0x88);
      for(int k=0;k<j;k++)print(k+":"+recv[k]+" ");
      println();
    } else {
      while (myport.available()>0)myport.read();
      println("missMatch");
    }
  }else if(j!=0){
    for(int k=0;k<j;k++)print(gavage[k]);
    println();
    println("error");
    while (myport.available()>0)myport.read();
  }
  
  float C=lqi1;
  float B=lqi3;
  float A=lqi2;
  A=abs(A);
  B=abs(B);
  C=abs(C);
  
  fill(0,255,0);
  text("lqi1:",50,100);
  text(C,100,100);
  fill(255,0,0);
  text("lqi2:",50,130);
  text(A,100,130);
  fill(0,0,255);
  text("lqi3:",50,160);
  text(B,100,160);
  
  C=(7*C-1970)/20;
  B=(7*B-1970)/20;
  A=(7*A-1970)/20;
  
  fill(0,255,0);
  text("lqi1:",350,100);
  text(C,500,100);
  fill(255,0,0);
  text("lqi2:",350,130);
  text(A,500,130);
  fill(0,0,255);
  text("lqi3:",350,160);
  text(B,500,160);
  
  C=pow(10,C/10)*100000000;
  B=pow(10,B/10)*100000000;
  A=pow(10,A/10)*100000000;
  
  C=5000*sqrt((22*sqrt(PR/5))/(31*C));
  B=5000*sqrt((22*sqrt(PR/5))/(31*B));
  A=5000*sqrt((22*sqrt(PB/5))/(31*A));
  
  fill(0,255,0);
  text("lqi1:",600,100);
  text(C,650,100);
  fill(255,0,0);
  text("lqi2:",600,130);
  text(A,650,130);
  fill(0,0,255);
  text("lqi3:",600,160);
  text(B,650,160);
  
  float K=C;
  
  C=C/K*G;
  B=B/K*G;
  A=A/K*G;
  
  fill(0,255,0);
  text(C/G,800,100);
  fill(255,0,0);
  text(A/G,800,130);
  fill(0,0,255);
  text(B/G,800,160);
  
  pushMatrix();
  translate(width/4,height/2);
  mk();
  strokeWeight(20);
  stroke(255,0,0);
  text("host",0,10);
  point(0,0);
  stroke(0,255,0);
  text("terminal1",C,10);
  point(C,0);
  stroke(0,0,255);
  text("terminal2",(sq(A)+sq(C)-sq(B))/(2*C),sqrt((2*sq(A)*sq(B)+2*sq(B)*sq(C)+2*sq(C)*sq(A))/(4*sq(C)))+10);
  point((sq(A)+sq(C)-sq(B))/(2*C),sqrt((2*sq(A)*sq(B)+2*sq(B)*sq(C)+2*sq(C)*sq(A))/(4*sq(C))));
  text("terminal2",(sq(A)+sq(C)-sq(B))/(2*C),-sqrt((2*sq(A)*sq(B)+2*sq(B)*sq(C)+2*sq(C)*sq(A))/(4*sq(C)))+10);
  point((sq(A)+sq(C)-sq(B))/(2*C),-sqrt((2*sq(A)*sq(B)+2*sq(B)*sq(C)+2*sq(C)*sq(A))/(4*sq(C))));
  strokeWeight(5);
  stroke(0);
  line(0,0,C,0);
  line(0,0,(sq(A)+sq(C)-sq(B))/(2*C),sqrt((2*sq(A)*sq(B)+2*sq(B)*sq(C)+2*sq(C)*sq(A))/(4*sq(C))));
  line(0,0,(sq(A)+sq(C)-sq(B))/(2*C),-sqrt((2*sq(A)*sq(B)+2*sq(B)*sq(C)+2*sq(C)*sq(A))/(4*sq(C))));
  line(C,0,(sq(A)+sq(C)-sq(B))/(2*C),sqrt((2*sq(A)*sq(B)+2*sq(B)*sq(C)+2*sq(C)*sq(A))/(4*sq(C))));
  line(C,0,(sq(A)+sq(C)-sq(B))/(2*C),-sqrt((2*sq(A)*sq(B)+2*sq(B)*sq(C)+2*sq(C)*sq(A))/(4*sq(C))));
  popMatrix();
}

void mk(){
  strokeWeight(2);
  stroke(125,125,0);
  line(-width/4,0,(width*3)/4,0);
  for(int l=-250;5*l<750;l++)line(5*l,5,5*l,-5);
  for(int l=-20;50*l<750;l++)line(50*l,10,50*l,-10);
  stroke(0,125,125);
  line(0,height/2,0,-height/2);
  for(int l=-90;5*l<450;l++)line(5,5*l,-5,5*l);
  for(int l=-9;50*l<450;l++)line(10,50*l,-10,50*l);
}
  
    

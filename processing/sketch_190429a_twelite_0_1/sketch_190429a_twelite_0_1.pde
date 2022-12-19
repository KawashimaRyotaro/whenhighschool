import processing.serial.*;
Serial myPort;

int aa=0;
String data,data12="",data11="",a11="",a12="",a21="",a22="";
int A11=0,A12=0,A21=0,A22=0;

void setup(){
  size(2000,500);
  frameRate(60);
  println(Serial.list());
  myPort=new Serial(this,"COM5",115200);
}
void draw(){
  
  if ( myPort.available() > 0) {
    background(0,0,0);              // 画面クリア
    data = myPort.readString(); // 文字列を受信
    aa=data.length();
    if(aa==51){
      if(data.substring(1,3).equals("0A")){
        fill(255,0,0);                  // 文字色
        textSize(50);                   // 文字サイズ
        text("A"+data, 100, 100);           // 画面に文字表示
        text("A"+aa,100,300);
        text("B"+data12, 100, 200);           // 画面に文字表示
        data11=data;
      }else if(data.substring(1,3).equals("78")){
        fill(255,0,0);                  // 文字色
        textSize(50);                   // 文字サイズ
        text("B"+data, 100, 200);           // 画面に文字表示
        text("B"+aa,100,300);
        text("A"+data11, 100, 100);           // 画面に文字表示
        data12=data;
      }
    }else{
      fill(255,0,0);                  // 文字色
      textSize(50);                   // 文字サイズ
      text("A"+data11, 100, 100);           // 画面に文字表示
      text("B"+data12, 100,200);
      text("e",100,300);
    }
  }
  if(aa==51){
    if(data.substring(1,3).equals("0A")){
      a11=data.substring(9,11);
      a12=data.substring(37,39);
      A11=toDEC(a11);
      A12=toDEC(a12);
    }else if(data.substring(1,3).equals("78")){
      a21=data.substring(9,11);
      a22=data.substring(37,39);
      A21=toDEC(a11);
      A22=toDEC(a12);
    }
  }
  text("A:"+a11+":"+A11,100,400);
  text("A:"+a12+":"+A12,100,500);
  text("B:"+a21+":"+A21,500,400);
  text("B:"+a22+":"+A22,500,500);
}


int toDEC(String a){
  String a3;
  String a4;
  int b,c;
  int aaa;
  a3=a.substring(0,1);
  a4=a.substring(1,2);
  b=judge(a3);
  c=judge(a4);
  aaa=c+16*b;
  return aaa;
}

int judge(String k){
  int l;
  if(k.equals("A")){
    l=10;
  }else if(k.equals("B")){
    l=11;
  }else if(k.equals("C")){
    l=12;
  }else if(k.equals("D")){
    l=13;
  }else if(k.equals("E")){
    l=14;
  }else if(k.equals("F")){
    l=15;
  }else{
    l=int(k);
  }
  return l;
}

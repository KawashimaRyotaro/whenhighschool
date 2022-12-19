import processing.serial.*;
import java.io.File;
import java.io.FileReader;
import java.io.BufferedReader;
import java.io.FileWriter;
import java.io.BufferedWriter;
import java.io.PrintWriter;
import java.io.FileNotFoundException;
import java.io.IOException;

Serial myport;
float lqi1=0,lqi2=0,lqi3=0;
float PB=.000178,PR=0.0083;
float G=width*2;
float h1=0.05,h2=0.05,g=pow(10,(2/10));
int num=0, num1=0, n=40, num2=0, i=0, n1=0, n2=0;

void setup(){
  
  fl f = new fl(true);
  while(f.exFile(new File("C:\\Users\\ryout\\OneDrive\\デスクトップ\\programming\\processing-3.4-windows32\\csv\\test_"+n1+"_"+n2+".text"))){
    n2++;
    if(n2==50){
       n2=0;
       n1++;
    }
  }
  File file = new File("C:\\Users\\ryout\\OneDrive\\デスクトップ\\programming\\processing-3.4-windows32\\csv\\test_"+n1+"_"+n2+".text");
  File directory = new File("C:\\Users\\ryout\\OneDrive\\デスクトップ\\programming\\processing-3.4-windows32\\csv");
  f.mkFile(file);
  f.chDirectory(directory);
  
  f.printlnFile(file,"lqi1,lqi2,D1,D2",true);
  
  size(1000,900);
  myport=new Serial(this,"COM3",115200);
}

void draw(){
  fl f = new fl(false);
  File file = new File("C:\\Users\\ryout\\OneDrive\\デスクトップ\\programming\\processing-3.4-windows32\\text\\test_"+n1+"_"+n2+".text");
  File directory = new File("C:\\Users\\ryout\\OneDrive\\デスクトップ\\programming\\processing-3.4-windows32\\text");
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
  
  f.printFile(file,lqi1+","+lqi2,true);
  
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
  
  C=pow(10,C/10);
  B=pow(10,B/10);
  A=pow(10,A/10);
  
  C=1000*sqrt((88*h1*h2*sqrt(g*PR))/(125*C));
  B=1000*sqrt((88*h1*h2*sqrt(g*PR))/(125*B));
  A=1000*sqrt((88*h1*h2*sqrt(g*PB))/(125*A));
  
  f.printlnFile(file,C+","+A,true);
  
  fill(0,255,0);
  text("C:",600,100);
  text(C,650,100);
  fill(255,0,0);
  text("A:",600,130);
  text(A,650,130);
  fill(0,0,255);
  text("B:",600,160);
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
  
  float X=(sq(A)+sq(C)-sq(B))/(2*C);
  float Y1=2*sq(A)*sq(B)+2*sq(B)*sq(C)+2*sq(C)*sq(A)-A*A*A*A-B*B*B*B-C*C*C*C;
  
  if(Y1<=0){
    Y1=0;
  }
  
  float Y=sqrt(Y1)/(2*C);
  
  pushMatrix();
  translate(width/4,height/2);
  mk();
  strokeWeight(20);
  stroke(255,0,0);
  text("host",10,-10);
  point(0,0);
  stroke(0,255,0);
  text("terminal1",C,-10);
  point(C,0);
  stroke(0,0,255);
  text("terminal2",X,Y+30);
  point(X,Y);
  text("terminal2",X,-Y-30);
  point(X,-Y);
  strokeWeight(5);
  stroke(0);
  line(0,0,C,0);
  line(0,0,X,Y);
  line(0,0,X,-Y);
  line(C,0,X,Y);
  line(C,0,X,-Y);
  print(X);
  print("   ,");
  println(Y);
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


class fl{

    fl(boolean a){
          if(a==true){
              System.out.println("[class flを作ります]");
          }
    }    

    File def_newFile(int n1,int n2){                    //textファイル定義メゾット
        File newfile;
        newfile = new File("C:\\Users\\ryout\\OneDrive\\デスクトップ\\programming\\visual sututio code\\java\\text\\test_"+n1+"_"+n2+".text"); //作成ファイル
        return newfile;
    }

    void mkFile(File file){                             //ファイル作成メゾット
        try{
            if(file.createNewFile()){                          
                System.out.println("ファイルの作成に成功しました");
            }else{                                               
                System.out.println("ファイルの作成に失敗しました"); 
            }
        }catch(IOException e){
            System.out.println(e);    //エラー
        }   
    }

    void chDirectory(File directory){                   //ディレクトリ確認メゾット
        System.out.println(directory.getAbsolutePath());
        File filelist[] = directory.listFiles();                   //フォルダ内容の格納
        for(int i=0;i<filelist.length;i++){                         //フォルダチェック
            if(filelist[i].isFile()){                               //
                System.out.println("[F]"+filelist[i].getName());    //
            }else if(filelist[i].isDirectory()){                    //
                System.out.println("[D]"+filelist[i].getName());    //
            }else{                                                  //
                System.out.println("[?]"+filelist[i].getName());    //
            }
        }
    }

    void dlFile(File file){                             //ファイル消去メゾット
        if(file.exists()){
            if(file.delete()){
                System.out.println("ファイルを削除しました");
            }else{
                System.out.println("ファイルの削除に失敗しました");
            }
        }else{
            System.out.println("ファイルが見つかりません");
        }
    }

    void reFile(File file){                             //ファイル読み込みメゾット
        try{
            
            if(exFile(file)){
                
                FileReader filereader = new FileReader(file);

                int ch;
                while((ch = filereader.read()) != -1){
                    System.out.print((char)ch);
                }
                filereader.close();
            }else{
                System.out.println("ファイルが見つからないか開けられません");
            }

        }catch(FileNotFoundException e){
            System.out.println(e);
        }catch(IOException e){
            System.out.println(e);
        }
    }

    void lireFile(File file){                           //ファイル行読み込みメゾット
        try{
            
            if(exFile(file)){

                BufferedReader bf = new BufferedReader(new FileReader(file));
                String str = bf.readLine();
                
                while(str != null){
                    System.out.println(str);

                    str = bf.readLine();
                }
                bf.close();
            }else{
                System.out.println("ファイルが見つからないか開けられません");
            }

        }catch(FileNotFoundException e){
            System.out.println(e);
        }catch(IOException e){
            System.out.println(e);
        }
    }

    void wrFile(File file,String text){                 //ファイル書き込みメゾット
        try{
            
            if(exFile(file)){

                FileWriter filewriter = new FileWriter(file);
                
                filewriter.write(text);

                filewriter.close();
            }else{
                System.out.println("指定したファイルは存在していないか、読み取り専用か、ファイルではありません");
            }
        }catch(IOException e){
            System.out.println(e);
        }
    }

    void wrFile(File file,String text,boolean a){       //ファイル書き込みメゾット(前後付け)
        try{
            
            if(exFile(file)){

                FileWriter filewriter = new FileWriter(file,a);
                
                filewriter.write(text);

                filewriter.close();
            }else{
                System.out.println("指定したファイルは存在していないか、読み取り専用か、ファイルではありません");
            }
        }catch(IOException e){
            System.out.println(e);
        }
    }

    void liwrFile(File file, String text) {             // ファイル行書き込み
        try{

            if(exFile(file)){
                
                BufferedWriter bw = new BufferedWriter(new FileWriter(file));

                bw.write(text);
                bw.newLine();

                bw.close();
            }else{
                System.out.println("指定したファイルは存在していないか、読み取り専用か、ファイルではありません");
            }
        }catch(IOException e){
            System.out.println(e);
        }
    }

    void liwrFile(File file, String text,boolean a) {   // ファイル行書き込み(前後付け)
        try{

            if(exFile(file)){
                
                BufferedWriter bw = new BufferedWriter(new FileWriter(file,a));

                bw.write(text);
                bw.newLine();

                bw.close();
            }else{
                System.out.println("指定したファイルは存在していないか、読み取り専用か、ファイルではありません");
            }
        }catch(IOException e){
            System.out.println(e);
        }
    }

    void printlnFile(File file,String text){            //改行ありファイルプリント(文字列)
        try{

            if(exFile(file)){
                PrintWriter pw = new PrintWriter(new BufferedWriter(new FileWriter(file)));
                
                pw.println(text);

                pw.close();
            }else{
                System.out.println("指定したファイルは存在していないか、読み取り専用か、ファイルではありません");
            }
        }catch(IOException e){
            System.out.println(e);
        }
    }

    void printFile(File file,String text){              //改行無しファイルプリント(文字列)
        try{

            if(exFile(file)){
                PrintWriter pw = new PrintWriter(new BufferedWriter(new FileWriter(file)));
                
                pw.print(text);

                pw.close();
            }else{
                System.out.println("指定したファイルは存在していないか、読み取り専用か、ファイルではありません");
            }
        }catch(IOException e){
            System.out.println(e);
        }
    }

    void printlnFile(File file,int i){                  //改行ありファイルプリント(int)
        try{

            if(exFile(file)){
                PrintWriter pw = new PrintWriter(new BufferedWriter(new FileWriter(file)));
                
                pw.println(i);

                pw.close();
            }else{
                System.out.println("指定したファイルは存在していないか、読み取り専用か、ファイルではありません");
            }
        }catch(IOException e){
            System.out.println(e);
        }
    }

    void printFile(File file,int i){                    //改行無しファイルプリント(int)
        try{

            if(exFile(file)){
                PrintWriter pw = new PrintWriter(new BufferedWriter(new FileWriter(file)));
                
                pw.print(i);

                pw.close();
            }else{
                System.out.println("指定したファイルは存在していないか、読み取り専用か、ファイルではありません");
            }
        }catch(IOException e){
            System.out.println(e);
        }
    }

    void printlnFile(File file,float i){                  //改行ありファイルプリント(float)
        try{

            if(exFile(file)){
                PrintWriter pw = new PrintWriter(new BufferedWriter(new FileWriter(file)));
                
                pw.println(i);

                pw.close();
            }else{
                System.out.println("指定したファイルは存在していないか、読み取り専用か、ファイルではありません");
            }
        }catch(IOException e){
            System.out.println(e);
        }
    }

    void printFile(File file,float i){                    //改行無しファイルプリント(float)
        try{

            if(exFile(file)){
                PrintWriter pw = new PrintWriter(new BufferedWriter(new FileWriter(file)));
                
                pw.print(i);

                pw.close();
            }else{
                System.out.println("指定したファイルは存在していないか、読み取り専用か、ファイルではありません");
            }
        }catch(IOException e){
            System.out.println(e);
        }
    }

    void printlnFile(File file,String text,boolean a){          //改行ありファイルプリント(文字列,後付け)
        try{

            if(exFile(file)){
                PrintWriter pw = new PrintWriter(new BufferedWriter(new FileWriter(file,a)));
                
                pw.println(text);

                pw.close();
            }else{
                System.out.println("指定したファイルは存在していないか、読み取り専用か、ファイルではありません");
            }
        }catch(IOException e){
            System.out.println(e);
        }
    }

    void printFile(File file,String text,boolean a){            //改行無しファイルプリント(文字列,後付け)
        try{

            if(exFile(file)){
                PrintWriter pw = new PrintWriter(new BufferedWriter(new FileWriter(file,a)));
                
                pw.print(text);

                pw.close();
            }else{
                System.out.println("指定したファイルは存在していないか、読み取り専用か、ファイルではありません");
            }
        }catch(IOException e){
            System.out.println(e);
        }
    }

    void printlnFile(File file,int i,boolean a){                //改行ありファイルプリント(int,後付け)
        try{

            if(exFile(file)){
                PrintWriter pw = new PrintWriter(new BufferedWriter(new FileWriter(file,a)));
                
                pw.println(i);

                pw.close();
            }else{
                System.out.println("指定したファイルは存在していないか、読み取り専用か、ファイルではありません");
            }
        }catch(IOException e){
            System.out.println(e);
        }
    }

    void printFile(File file,int i,boolean a){                  //改行無しファイルプリント(int,後付け)
        try{

            if(exFile(file)){
                PrintWriter pw = new PrintWriter(new BufferedWriter(new FileWriter(file,a)));
                
                pw.print(i);

                pw.close();
            }else{
                System.out.println("指定したファイルは存在していないか、読み取り専用か、ファイルではありません");
            }
        }catch(IOException e){
            System.out.println(e);
        }
    }

    void printlnFile(File file,float i,boolean a){                //改行ありファイルプリント(float,後付け)
        try{

            if(exFile(file)){
                PrintWriter pw = new PrintWriter(new BufferedWriter(new FileWriter(file,a)));
                
                pw.println(i);

                pw.close();
            }else{
                System.out.println("指定したファイルは存在していないか、読み取り専用か、ファイルではありません");
            }
        }catch(IOException e){
            System.out.println(e);
        }
    }

    void printFile(File file,float i,boolean a){                  //改行無しファイルプリント(float,後付け)
        try{

            if(exFile(file)){
                PrintWriter pw = new PrintWriter(new BufferedWriter(new FileWriter(file,a)));
                
                pw.print(i);

                pw.close();
            }else{
                System.out.println("指定したファイルは存在していないか、読み取り専用か、ファイルではありません");
            }
        }catch(IOException e){
            System.out.println(e);
        }
    }

    boolean exFile(File file){                          //ファイル安否確認メゾット
        if(file.exists()){
            if(file.isFile() && file.canRead()){
                return true;
            }
        }
        return false;
    }
}

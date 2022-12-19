import processing.serial.*;
import java.io.File;
import java.io.FileReader;
import java.io.BufferedReader;
import java.io.FileWriter;
import java.io.BufferedWriter;
import java.io.PrintWriter;
import java.io.FileNotFoundException;
import java.io.IOException;
Serial myPort;
float gx, gy, gz, ax, ay, az;
float th,th3;
float mx,my,mz;
float[] pmx,pmy,pmz;
float pmx1, pmy1, pmz1, pmx2, pmy2, pmz2; 
float Mx, My, Mz, mix, miy, miz; 
float x=0, y=0, z=0;
float x_1=0, y_1=0, z_1=0;
float a,b,c,d;
float ROLL, PITCH, YAW;
float k=0,j=0,l=0,m=0;
float cR,sR,cP,sP,cY,sY;
float ccR,csR,ccP,csP,ccY,csY;
float pP,pR,pY;
float a_1,a_2,a_3;
int num=0, num1=0, n=40, num2=0, i=0, n1=0, n2=0;
int serialTimer;
String data,data1="",a1="",a2="";
int A1=0,A2=0;
boolean mn=false;

void setup(){
  fl f = new fl(true);
      while(f.exFile(new File("C:\\Users\\ryout\\OneDrive\\デスクトップ\\programming\\processing-3.4-windows32\\text\\test_"+n1+"_"+n2+".text"))){
            n2++;
            if(n2==50){
              n2=0;
              n1++;
            }
      }
      File file = new File("C:\\Users\\ryout\\OneDrive\\デスクトップ\\programming\\processing-3.4-windows32\\text\\test_"+n1+"_"+n2+".text");
      File directory = new File("C:\\Users\\ryout\\OneDrive\\デスクトップ\\programming\\processing-3.4-windows32\\text");
      f.mkFile(file);
  size(2000,500);
  frameRate(60);
  println(Serial.list());
  myPort=new Serial(this,"COM5",115200);
  f.chDirectory(directory);
}
void draw(){
  fl f = new fl(false);
  File file = new File("C:\\Users\\ryout\\OneDrive\\デスクトップ\\programming\\processing-3.4-windows32\\text\\test_"+n1+"_"+n2+".text");
  File directory = new File("C:\\Users\\ryout\\OneDrive\\デスクトップ\\programming\\processing-3.4-windows32\\text");
  
  if ( myPort.available() > 0) {
    background(0,0,0);              // 画面クリア
    data = myPort.readString(); // 文字列を受信
    a=data.length();
    if(a==51){
      fill(255,0,0);                  // 文字色
      textSize(50);                   // 文字サイズ
      text(data, 100, 100);           // 画面に文字表示
      text(a,100,200);
      data1=data;
    }else{
      fill(255,0,0);                  // 文字色
      textSize(50);                   // 文字サイズ
      text(data1, 100, 100);           // 画面に文字表示
      text("e",100,200);
    }
  }
  if(a==51){
    a1=data.substring(9,11);
    a2=data.substring(37,39);
    A1=toDEC(a1);
    A2=toDEC(a2);
  }
  text(a1+":"+A1,100,300);
  text(a2+":"+A2,100,400);
  
  if(mn){
    textSize(20);
    f.printFile(file,"st",true);
    f.printFile(file,A1,true);
    f.printFile(file,"q",true);
    f.printFile(file,A2,true);
    f.printFile(file,"q",true);
    f.printFile(file,num,true);
    f.printlnFile(file,"ed",true);
    text("running"+"     st"+A1+"q"+A2+"q"+num+"ed",500,200);
    if(num1==10){
      text(num,500,400);
      num=0;
    }
    text("C:\\Users\\ryout\\OneDrive\\デスクトップ\\programming\\processing-3.4-windows32\\text\\test_"+n1+"_"+n2+".text",500,300);
    num++;
    num1++;
  }
}

int toDEC(String a){
  String a3;
  String a4;
  int b,c;
  int aa;
  a3=a.substring(0,1);
  a4=a.substring(1,2);
  b=judge(a3);
  c=judge(a4);
  aa=c+16*b;
  return aa;
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

void mousePressed(){
  mn=true;
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

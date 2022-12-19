import processing.serial.*;
import java.io.File;
import java.io.FileReader;
import java.io.BufferedReader;
import java.io.FileWriter;
import java.io.BufferedWriter;
import java.io.PrintWriter;
import java.io.FileNotFoundException;
import java.io.IOException;


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
Serial myPort;


void setup() {
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
      pmx=new float[100000];
      pmy=new float[100000];
      pmz=new float[100000];
      size(1900, 1000, P3D);
      strokeWeight(2);
      myPort = new Serial(this, "COM3", 57600);
      f.chDirectory(directory);
}


void draw() {
      fl f = new fl(false);
      File file = new File("C:\\Users\\ryout\\OneDrive\\デスクトップ\\programming\\processing-3.4-windows32\\text\\test_"+n1+"_"+n2+".text");
      File directory = new File("C:\\Users\\ryout\\OneDrive\\デスクトップ\\programming\\processing-3.4-windows32\\text");
  
      background(255);
      textSize(24);
      fill(0);
  
      read();
      
      f.printFile(file,"ss",true);
      f.printFile(file,ROLL,true);
      f.printFile(file,"gg",true);
      f.printFile(file,PITCH,true);
      f.printFile(file,"gg",true);
      f.printFile(file,ax,true);
      f.printFile(file,"gg",true);
      f.printFile(file,ay,true);
      f.printFile(file,"gg",true);
      f.printFile(file,az,true);
      f.printFile(file,"gg",true);
      f.printFile(file,gx,true);
      f.printFile(file,"gg",true);
      f.printFile(file,gy,true);
      f.printFile(file,"gg",true);
      f.printFile(file,gz,true);
      f.printFile(file,"gg",true);
      f.printFile(file,mx,true);
      f.printFile(file,"gg",true);
      f.printFile(file,my,true);
      f.printFile(file,"gg",true);
      f.printFile(file,mz,true);
      f.printlnFile(file,"ee",true);
      
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
  
      YAW=atan2(q_1,q);
      
      cY=cos(-YAW);
      sY=sin(-YAW);
      ccY=cos(YAW);
      csY=sin(YAW);
      
      a_1=sP;
      a_3=ccP*ccR;
      a_2=csR;
      
      x=ax-a_1+0.005;
      y=ay-a_2-0.0055;
      z=az-a_3+0.03125;
      
      if(x>=-0.02&&x<=0.02){
            x=0;
      }
      if(y>=-0.02&&y<=0.02){
            y=0;
      }
      if(z>=-0.02&&z<=0.02){
            z=0;
      }
             
      if(i>=200){
            z_1+=z;
            x_1+=x;
            y_1+=y;
      }
      if(i==1000){
            x_1=0;
            y_1=0;
            z_1=0;
      }
           
      mouse_rotate();
  
      pushMatrix();
    
      make_field(a,b);
      
      plint();
      plint_tex();
  
      rotateX(-PI/2);
      applyMatrix(cY,0,-sY,0,0,1,0,0,sY,0,cY,0,0,0,0,1);   //yaw(y軸回転)-Y
      applyMatrix(ccR,csR,0,0,-csR,ccR,0,0,0,0,1,0,0,0,0,1);   //pitch(z軸回転）-R
      applyMatrix(1,0,0,0,0,ccP,csP,0,0,-csP,ccP,0,0,0,0,1);   //roll(x軸回転）-P
        
      draw_arduino();
  
      plint();
      plint_tex();
  
      popMatrix();
      
      pushMatrix();
      moniter(q_1,q,q1);
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
                        gx/=10000.0;
                        gy/=10000.0;
                        gz/=10000.0;
                        gx+=0.01;
                        gy+=-0.01;
                        gz+=0.01;
                        ax/=10000.0;
                        ay/=10000.0;
                        az/=10000.0;
                        mx/=100.0;
                        my/=100.0;
                        mz/=100.0;
                        ax-=0;
                        ay-=0;
                        az+=0;
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
      text(nf(y, 0, 2), 0,170, 320);
      text(nf(z, 0, 2), 0,200, 320);
      text(nf(mx, 0, 2), 0,230, 320);
      text(nf(mz, 0, 2), 0,260, 320);
      text(nf(my, 0, 2), 0,290, 320);
      text(nf(mz, 0, 2), 0,320, 320);
      text(nf(a_1, 0, 2), 0,350, 320);
      text(nf(a_2, 0, 2), 0,380, 320);
      text(nf(a_3, 0, 2), 0,410, 320);
      text(nf(ax, 0, 2), 0,440, 320);
      text(nf(ay, 0, 2), 0,470, 320);
      text(nf(az, 0, 2), 0,500, 320);
      text(nf(x_1, 0, 2), 0,530, 320);
      text(nf(y_1, 0, 2), 0,560, 320);
      text(nf(z_1, 0, 2), 0,590, 320);
}






void plint_tex(){
      text("PITCH:", -100, 50, 320);
      text("ROLL:", -100, 80, 320);
      text("YAW:", -100, 110, 320);
      text("x:", -40, 140, 320);
      text("y:", -40, 170, 320);
      text("z:", -40, 200, 320);
      text("mx:", -40, 230, 320);
      text("mz:", -40, 260, 320);
      text("my:", -40, 290, 320);
      text("mz:", -40, 320, 320);
      text("ax:", -40, 350, 320);
      text("ay:", -40, 380, 320);
      text("az:", -40, 410, 320);
      text("ax':", -40, 440, 320);
      text("ay':", -40, 470, 320);
      text("az':", -40, 500, 320);
      text("x1':", -40, 530, 320);
      text("y1':", -40, 560, 320);
      text("z1':", -40, 590, 320);
}






void moniter(float q_1,float q,float q1){
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
      line(0,0,q_1*2,q*2);
      
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
      line(0,0,q_1*2,q1*2);
      
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
      line(0,0,q*2,q1*2);
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

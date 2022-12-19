import processing.serial.*;
import java.io.File;
import java.io.FileReader;
import java.io.BufferedReader;
import java.io.FileWriter;
import java.io.BufferedWriter;
import java.io.PrintWriter;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;
import java.nio.charset.Charset;
import java.nio.file.Files;
import java.nio.file.Paths;

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
String R="",P="";
String xx="",yy="",zz="";
float k=0,j=0,l=0,m=0;
float cR,sR,cP,sP,cY,sY;
float ccR,csR,ccP,csP,ccY,csY;
float pP,pR,pY;
float a_1,a_2,a_3;
int f=0;
int num=0, num1=0, n=40, num2=0, i=0, n1=0, n2=0;
int serialTimer;
int qqqq=0;
int ipu=0;
int jj,e;
List<String> val=new ArrayList<String>();;
Serial myPort;


void setup() {
      fl f = new fl(true);
      
      File file = new File("D:\\DATALOG1.txt");
      File directory = new File("D:");
      
      try{
            val=Files.readAllLines(Paths.get("D:\\DATALOG1.txt"));
            /*for (String s : val) {
                System.out.println(s);
            }*/
      }catch(IOException e){
            e.printStackTrace();
      }

      size(1900, 1000, P3D);
      strokeWeight(2);
      f.chDirectory(directory);
}


void draw() {      
      background(255);
      textSize(24);
      fill(0);
     
      String u=val.get(qqqq);
      //System.out.println(qqqq);
      //System.out.println(u);
      
      
      if(u.substring(0,2).equals("s:")){
            for(jj=0,e=0;e!=1;jj++){
                  String r=u.substring(int(jj+2),int(jj+3));
                  if(r.equals(",")){
                        e++;
                  }else{
                        R+=r;
                  }
            }
            //System.out.println("rj"+R);
      
            for(e=0;e!=1;jj++){
                  String pq=u.substring(int(jj+2),int(jj+3));
                  if(pq.equals(",")){
                        e++;
                  }else{
                        P+=pq;
                  }
            }
            //System.out.println("pj"+P);
            
            for(int e=0;e!=1;jj++){
                  String xt=u.substring(int(jj+2),int(jj+3));
                  if(xt.equals(",")){
                        e++;
                  }else{
                        xx+=xt;
                  }
            }
            //System.out.println("xj"+xx);
            
            for(int e=0;e!=1;jj++){
                  String yt=u.substring(int(jj+2),int(jj+3));
                  if(yt.equals(",")){
                        e++;
                  }else{
                        yy+=yt;
                  }
            }
            //System.out.println("yj"+yy);
            
            for(int e=0;e!=1;jj++){
                  String zt=u.substring(int(jj+2),int(jj+3));
                  if(zt.equals(":")){
                        e++;
                  }else{
                        zz+=zt;
                  }
            }
            //System.out.println("zj"+zz);
            
            ROLL=Float.parseFloat(R);
            PITCH=Float.parseFloat(P);
            mx=Float.parseFloat(xx);
            my=Float.parseFloat(yy);
            mz=Float.parseFloat(zz);
            R="";
            P="";
            xx="";
            yy="";
            zz="";
      }
      /*System.out.println("R"+ROLL);
      System.out.println("P"+PITCH);
      System.out.println("x"+mx);
      System.out.println("y"+my);
      System.out.println("z"+mz);*/
      jj=0;
      
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
                       
      mouse_rotate();
  
      pushMatrix();
    
      make_field(a,b);
  
      rotateX(-PI/2);
      applyMatrix(cY,0,-sY,0,0,1,0,0,sY,0,cY,0,0,0,0,1);   //yaw(y軸回転)-Y
      applyMatrix(ccR,csR,0,0,-csR,ccR,0,0,0,0,1,0,0,0,0,1);   //pitch(z軸回転）-R
      applyMatrix(1,0,0,0,0,ccP,csP,0,0,-csP,ccP,0,0,0,0,1);   //roll(x軸回転）-P
        
      draw_arduino();
  
      popMatrix();
      
      pushMatrix();

      popMatrix();
      
      qqqq++;
      pP=PITCH;
      pR=ROLL;
      pY=YAW;
      delay(f);
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
      text("x(+)",500,0,0);
      text("x(-)",-500,0,0);
      
      stroke(0,255,0);
      line(0,-1000,0,0,1000,0);
      text("y(-)",0,500,0);
      text("y(+)",0,-500,0);
      
      stroke(125,0,0);
      line(0,0,-1000,0,0,1000);
      text("z(+)",0,0,500);
      text("z(-)",0,0,-500);
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
}

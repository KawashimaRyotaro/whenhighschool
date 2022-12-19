import processing.opengl.*;

float rot=0;
void setup(){
    size(400,400,OPENGL);
    frameRate(60);
    fill(63,127,255);
    stroke(255);
    //rectMode(CENTER);
}

void draw(){
    background(0);
    translate(width/2,height/2);
    
    rotateX(rot);
    rotateY(rot);
    rotateZ(rot);
    stroke(255,0,0);//red z
    line(0,0,0,0,0,100);
    stroke(0,0,255);//blue y
    line(0,-100,0,0,0,0);
    stroke(0,255,0);//green x
    line(0,0,0,100,0,0);
    rot += 0.01;
}

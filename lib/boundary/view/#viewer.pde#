float[][] data;
float[][] lattice;
int data_size;
int ScreenX=700,ScreenY=500;
int $scale=100;
float CX=ScreenX/2.0,CY=ScreenY*2.0/3.0;

void DrawArrow(int cx, int cy, int len, float angle){
  pushMatrix();
  translate(cx, cy);
  rotate(radians(angle));
  line(0,0,len, 0);
  line(len, 0, len - 8, -8);
  line(len, 0, len - 8, 8);
  popMatrix();
}
void DrawAxis(){
  stroke(0,0,0);
  pushMatrix();
  translate(CX,CY);
  DrawArrow(-220,0,440,0);
  DrawArrow(0,220,440,-90);
  popMatrix();
}

void DrawRect(float x1, float y1, float x2, float y2, float theta){
  pushMatrix();
 //   fill(255,0);
  translate(CX,CY);
  scale(1,-1);
  rotate(theta);
  rectMode(CORNERS);
  rect(x1*$scale,y1*$scale,x2*$scale,y2*$scale);
  popMatrix();
}

void DrawCircle(float x1, float y1, float radius){
  pushMatrix();
  translate(CX,CY);
  scale(1,-1);
  ellipseMode(CENTER);
  ellipse(x1*$scale,y1*$scale,radius,radius);
  popMatrix();
}

void settings(){
  size(ScreenX,ScreenY);
}  
void setup() {
  background(255,255,255);
  String[] stuff = loadStrings("POSCAR.txt"); 
  lattice = new float[3][];
  for (int i=0;i<3;i++){
        lattice[i]=float(split(stuff[2+i],','));
  }
  data_size=int( stuff[5]);
  println(data_size);
  data = new float[data_size][];
  for (int i=0;i<data_size;i++){
    data[i]=float(split(stuff[7+i],','));
    float[]  pos = { 0.0, 0.0, 0.0};
    //    data[i][0]-=0.5;
    for (int j =0;j<3;j++){
      for (int k =0;k<3;k++){
        pos[k]+=data[i][j]*lattice[j][k];
      }
    }
    println(" ");
    for (int j=0;j<3;j++){
      println(data[i][j]);
      println(pos[j]);
      data[i][j]=pos[j];
    }
  }
  noLoop(); // don't loop in draw()
}

void draw() {
  background(255);
  stroke(0);

  stroke(0,0,255);
  stroke(0,255,255);
  //    DrawRect(0,0,2,2,atan(1.0/3.0)); //1/4
  float s1=0.1;
  float a=lattice[0][0]*s1,b=lattice[1][1]*s1;
    
    DrawRect( -a/2.0,0.0, a/2.0,b ,0); //1/4

  stroke(255,0,0);
  //  /*
  for (int i=0;i<data_size;i++){
    if (data[i][2]>=0.3){
      stroke(128,0,0);  
      DrawCircle(data[i][0]*s1,data[i][1]*s1,10.0);
    } else {
      stroke(255,0,0);  
      DrawCircle(data[i][0]*s1,data[i][1]*s1,15.0);
    }      
  }
  /*
  for (int i=0;i<data_size;i++){
   fill(255,0);
    stroke(128,0,0);  
    DrawCircle(data[i][0]*s1,data[i][1]*s1,5+data[i][2]*3);
  }
  */
  DrawAxis();
  saveFrame("test.png");
 // exit(); //for perfect drawing
}


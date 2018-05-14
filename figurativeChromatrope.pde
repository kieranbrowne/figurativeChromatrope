import controlP5.*;

ControlP5 cp5;
//Slider frame;

ArrayList<Point> points1 = new ArrayList<Point>();
ArrayList<Point> points2 = new ArrayList<Point>();

int scene = 0;
int savedFrames = 0;
int frame = 0;
boolean preview = false;

PGraphics slide1;
PGraphics slide2;

void setup () {
  size(400,400);
  
  cp5 = new ControlP5(this);
  cp5.addSlider("frame")
     .setPosition(10,10)
     .setRange(0,17)
     .setNumberOfTickMarks(18)
     ;
  cp5.addToggle("preview")
     .setPosition(10,30)
     .setSize(20,20)
     ;
  
  slide1 = createGraphics(width,height);
  slide2 = createGraphics(width,height);

}

void draw () {
  background(255);
  
  for(float i=0; i<400; i++) {
    fill(0);
    //ellipse(random(width),random(height),30,40);
    ellipse(width/2 + sin(i/400*TWO_PI)*240, height/2 +cos((i/400)*TWO_PI)*240,85,85);
  }
  
  if(!preview) {
    savedFrames = 0;
    //background(0);
    drawSlide(slide1,points1,0,true);
    drawSlide(slide2,points2,0,true);
    
    blendMode(DARKEST);
    
    pushMatrix();
    translate(width/2,height/2);
    rotate(radians((360/18)*frame));
    image(slide1, -width/2, -height/2); 
    popMatrix();
    
    pushMatrix();
    translate(width/2,height/2);
    rotate(-radians((360/18)*frame));
    image(slide2, -width/2, -height/2); 
    popMatrix();
    
    
  } else {
    blendMode(DARKEST);
    
    drawSlide(slide1,points1,0,true);
    drawSlide(slide2,points2,0,true);
    

    
    // slide 1
    pushMatrix();
    translate(width/2,height/2);
    rotate(radians(frameCount));
    image(slide1, -width/2, -height/2); 
    popMatrix();
    
    // slide 2
    pushMatrix();
    translate(width/2,height/2);
    rotate(radians(-frameCount));
    image(slide2, -width/2, -height/2); 
    popMatrix();


    if(savedFrames == 0) frameCount=0;
    
    if(savedFrames < 360) {
      saveFrame("frame-#####.png");
      savedFrames++;
    }
  }
  blendMode(NORMAL);

}

void drawSlide(PGraphics slide,ArrayList<Point> content, int offset, boolean clear) {
  slide.beginDraw();
  if(clear) slide.background(0);
  //slide.translate(width/2,height/2);
  
  for (Point p : content) {
    p.display(slide);
  }
  slide.endDraw();
}

void drawSlide(PGraphics slide,ArrayList<Point> content, int offset) {
  drawSlide(slide,content,offset,false);
}

void drawSlide(PGraphics slide,ArrayList<Point> content) {
  drawSlide(slide,content,0,false);
}

void mousePressed() {
  if(!preview) {
    PVector p = new PVector(mouseX-width/2, mouseY-height/2);
    p.rotate(-radians((360/18)*frame));
    points1.add(new Point(p.x,p.y));
    p.rotate(radians((360/18)*frame));
    p.rotate(radians((360/18)*frame));
    points2.add(new Point(p.x,p.y));
  }
  //println(points1);
  println(frame);
}

void keyPressed() {
  scene++;
}

class Point {
  float x;
  float y;
  Point(float x, float y) {
    this.x = x;
    this.y = y;
  }
  void display(PGraphics pg) {
    pg.noStroke();
    pg.fill(255);
    pg.ellipse(width/2 + this.x, height/2 + this.y, 3, 3);
  } 
}
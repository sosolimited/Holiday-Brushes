/* MOUSE
 * press               : draw with brush
 * 
 * KEYS
 * Delete/Backspace    : clear display
 * s                   : save png
 * e                   : hold to erase
 */
 
import java.util.Calendar;

color white = color(255, 255, 255);
 
//declare array for baubles
PImage baubles[] = new PImage[3];
PImage jcBauble;
 
float x, y;
float easing = 0.09;
float lineLength = 25;    
float angle = 0.0;
int digit = 0;
int c = 255;
boolean erase = false;

void setup(){
  size(displayWidth, displayHeight);
  smooth();
  background(white);
  frameRate(60);
  x = mouseX;
  y = mouseY;
  cursor(CROSS);
  
  //Fill bauable array with image files
  for (int i = 0; i < baubles.length; i++) {
     String imageName ="ornament_" + nf((i+1), 2) + ".png";
     baubles[i] = loadImage(imageName);
   }
   
   //Load the jc bauble 
  jcBauble = loadImage("ornament_jc.png");
}
  

void draw() {
  float targetX = mouseX;
  float dx = (targetX-x);
  float targetY = mouseY;
  float dy = (targetY-y);
  
  // Random number generated for variation in color of branch
  int branchR = int(random(10, 60));
  
  // Tie stroke weight of branch to speed of mouse movement
  float weight = dist(mouseX, mouseY, pmouseX, pmouseY);
  float branchWeight = constrain(weight, 15, 35);
  strokeWeight(branchWeight/3);
  
  if (mousePressed && erase != true) {
    float x2 = x + dx;
    float y2 = y + dy;
    float d = dist(x, y, mouseX, mouseY);
    float steps = d/random(12,15);
    
    // Draw the branch 
    stroke(208-branchR, 158-branchR, 25-branchR); //set shaded branch color
    line(mouseX, mouseY, pmouseX, pmouseY); //draw branch stroke
    
    // Draw the needles
    if (d > 10) {
      float angle = atan2(mouseY-y, mouseX-x); 
  
      for (int i = 0; i <= steps; i += 1) {
        float t = i/steps;
        float cx = lerp(x, x2, t); //get fractional positions
        float cy = lerp(y, y2, t); //get fractional positions
        drawNeedle(cx, cy, angle, d, weight, "left"); //draw needles on left side of branch
        drawNeedle(cx, cy, angle, d, weight, "right"); //draw needles on right side of branch
      }

      x  = mouseX;
      y  = mouseY; 
    }
    
    //draw the baubles
    float baubleDiameter = random(55,65);
    float chance = random(1,10);
    digit++; 
    if (digit >= 3){digit = 0;}
    if (d > 35) {
      float baubleTilt = random(0, TWO_PI);
      pushMatrix();
        translate(x,y);
        rotate(baubleTilt);
        
        //Draw with array of alternating baubles
        //image(baubles[digit], 0 + random(-80,10), 0 + random(-60,10), .8*baubleDiameter, .8*baubleDiameter);
        
        //Draw single bauble
        //if (chance >= 4){
        //  image(jcBauble, 0 + random(-80,30), random(-20,10), baubleDiameter, baubleDiameter);
        //}
      popMatrix();
    }
    
  }
  
  // enable eraser 
  else if (mousePressed && erase == true) {
    noStroke();
    fill(c);
    ellipseMode(CENTER);
    ellipse(mouseX, mouseY, 100, 100);
  }

  else {
    x = targetX;
    y = targetY;
  }
}

void keyPressed() {
  // save a png
  if (key == 's' || key == 'S') {
    saveFrame(timestamp()+".png");
  }
  
  // clear canvas
  if (key == DELETE || key == BACKSPACE){ 
    background(white);
  }
  
  // enable eraser on key press
  if (key == 'e') {
    erase = true;
  }
}

//disable eraser on key release
void keyReleased() {
    if (key == 'e') {
    erase = false;
  }
}


void drawNeedle(float passCx, float passCy, float passAngle, float passD, float passWeight, String side) {
  int needleR = int(random(0, 70));
  float needleWeight = constrain(passWeight, 35, 50);
  float needleLength;
  float maxNeedleLength = random(90,100);
  float needleTilt = random (.6, 1.7);
  
  needleLength = lineLength*random(0.95,1.0)*passD/15;
  //constrain the needle length
  float cNeedleLength = constrain(needleLength, 10, maxNeedleLength);
    
  if (side == "left") {
    pushMatrix();
    translate(passCx,passCy);
    rotate(passAngle - needleTilt);
    noStroke();
    fill(0+needleR, 94+needleR, 78+needleR); //dynamic color
    ellipseMode(CORNER);
    ellipse(-7, 0, needleWeight/5, cNeedleLength);
    popMatrix();
  } else if (side == "right") {
    pushMatrix();
    translate(passCx,passCy);
    rotate(passAngle + needleTilt);
    noStroke();
    fill(0+needleR, 94+needleR, 78+needleR); //dynamic color
    ellipseMode(CORNER);
    ellipse(-8, 3, needleWeight/5, -cNeedleLength);
    popMatrix();
  }
}




// timestamp
String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}
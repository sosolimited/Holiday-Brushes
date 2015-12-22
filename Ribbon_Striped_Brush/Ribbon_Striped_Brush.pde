/* MOUSE
 * press               : draw with brush
 * 
 * KEYS
 * Delete/Backspace    : clear display
 * s                   : save png
 * e                   : hold to erase
 */
 

import java.util.Calendar;

color hotpink = color(235, 28, 108);
color lime = color(202, 210, 37);
color lime2 = color(172, 180, 10);
color turquoise = color(89, 221, 219);
color medturq = color(61, 183, 197);
color teal = color(37, 209, 166);
color purple1 = color(120, 131, 235);
color purple2 = color(102, 102, 204);
color purple3 = color(156, 102, 195);
color tangerine = color(248, 178, 25);
color white = color(255, 255, 255);

PImage sketch;
float x, y;
float easing = 0.09;
float diameter = 70;
float angle = 5.50;
boolean erase = false;
float currentDistance = 0;

void setup(){
  size(displayWidth, displayHeight);
  smooth();
  background(white);
  noStroke();
  cursor(CROSS);
}


void draw() {
  float targetX = mouseX;
  float dx = (targetX-x) * easing;
  float targetY = mouseY;
  float dy = (targetY-y) * easing;
  
  if (mousePressed && erase != true) {
    
    float x2 = x + dx;
    float y2 = y + dy;
    float steps = 28;
    for (int i = 0; i <= steps; i += 1) {
      float t = i/steps;
      float cx = lerp(x, x2, t); //get fractional positions
      float cy = lerp(y, y2, t); //get fractional positions
      pushMatrix();
      translate (cx, cy);
      rotate(angle);
      
      //Draw the ribbon
      
      strokeCap(SQUARE);
      strokeWeight(3);
      
      stroke(purple1);
      line(-50, 0, -30, 0);
      line(30, 0, 50, 0);
      line(-12, 0, 12, 0);
      
      stroke(purple2);
      line(-30, 0, -12, 0);
      line(12, 0, 30, 0);
      
      popMatrix();
    }
    x = x2;
    y = y2;
    
  // enable eraser 
  } else if (mousePressed && erase == true) {
    fill(white);
    stroke(white);
    ellipse(mouseX, mouseY, diameter*1.7, diameter*1.7);
  }

  else {
    x = targetX;
    y = targetY;
  }
}

float clamp(float x, float low, float high) {
  if (x <= low) {
    return low;
  } else if (x >= high){
    return high;
  }
  return x;
}

void keyPressed() {
  if (key == 's' || key == 'S') {
    saveFrame(timestamp()+".png");
  }
  if (key == DELETE || key == BACKSPACE){ 
    background(white);
  }
  if (key == 'e') {
    erase = true;
  }
}

void keyReleased() {
    if (key == 'e') {
    erase = false;
  }
}

// timestamp
String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}
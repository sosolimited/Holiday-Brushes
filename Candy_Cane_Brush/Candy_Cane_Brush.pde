/* MOUSE
 * press               : draw with brush
 * 
 * KEYS
 * Up                  : make brush larger
 * Down                : make brush smaller
 * Delete/Backspace    : clear display
 * s                   : save a png
 * e                   : hold to erase
 */


import java.util.Calendar;

PShape s;
float x, y;
float easing = 0.09;
float diameter = 52;
float angle = 0.0;
color white = color(255);
boolean erase = false;

void setup(){
  size(displayWidth, displayHeight);
  smooth();
  frameRate(70);
  cursor(CROSS);
  background(white);
  noStroke();
  
  //Load the circular candy svg
  s = loadShape("candy-cane-hotpinkturq.svg"); //more shape colors in data folder
}

void draw() {
  float targetX = mouseX;
  float dx = (targetX-x) * easing;
  float targetY = mouseY;
  float dy = (targetY-y) * easing;
  float d = dist(x, y, mouseX, mouseY);
  
  if (mousePressed && erase != true) {
    float x2 = x + dx;
    float y2 = y + dy;
    
    // Draw additional circles between frames for smooth brushstrokes
    float steps = 18;
    for (int i = 0; i <= steps; i += 1) {
      float t = i/steps;
      float cx = lerp(x, x2, t); //get fractional x positions
      float cy = lerp(y, y2, t); //get fractional y positions
      pushMatrix();
      translate (cx, cy);
      rotate(angle);
      
      //Draw the circular candy piece
      shape(s, -(diameter/2), -(diameter/2), diameter, diameter);
      
      // Rotation linked to distance moved
      angle += d*.0018/steps;
      
      // Rotation independent of distance moved
      // angle += .007;
      
      popMatrix();
    }
    x = x2;
    y = y2;
    
  // Enable eraser 
  } else if (mousePressed && erase == true) {
    fill(white);
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
  // save a png
  if (key == 's' || key == 'S') {
    saveFrame(timestamp()+".png");
  }
  
  // clear canvas
  if (key == DELETE || key == BACKSPACE){ 
    background(white);
  }
  
  // increase brush diameter
  if (keyCode == UP) {
    diameter +=2;
    angle -= .03;
  }
  
  // decrease brush diameter
  if (keyCode == DOWN) {
    diameter -=2;
    angle += .03;
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

// timestamp
String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}
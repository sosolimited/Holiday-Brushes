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

ArrayList<PShape> scoops = new ArrayList<PShape>();
ArrayList<PShape> cherryScoops = new ArrayList<PShape>();

PShape cone;

float x, y;
float prevX = -99999;
float prevY = -99999;

float diameter = 50;
float baseDiameter = 50;
float s = diameter / baseDiameter; // Scale factor

int count = 0;

// Cone and scoop diameters when scale factor == 1
float coneWidth = 23;
float coneHeight = 106;

float scoopWidth = 59;
float scoopHeight = 73;

boolean firstScoop = true;
boolean placedCone = false;

boolean mouseDragged = false;

float angle = 0.0;
boolean erase = false;

color bColor = color(255);

void setup() {
  //size(displayWidth, displayHeight);
  size(900, 900);
  smooth();
  frameRate(70);
  cursor(CROSS);
  background(bColor);
  noStroke();

  // Load scoop shapes of every color
  for (int i = 1; i < 4; i++) {

    PShape scoop = loadShape("icecream-scoop-" + i + ".svg");
    PShape cherry = loadShape("icecream-scoop-cherry-" + i + ".svg");

    scoops.add(scoop);
    cherryScoops.add(cherry);
  }

  // Create Triangle shape for cone
  cone = createShape();
  cone.beginShape(TRIANGLE_STRIP);
  cone.vertex(-44, 10);
  cone.vertex(0, 140);
  cone.vertex(44, 10);
  cone.vertex(0, 10);
  cone.endShape();

  cone.setFill(color(206, 133, 77));
}


void draw() {

  float targetX = mouseX;
  float targetY = mouseY;

  float d = dist(x, y, mouseX, mouseY);
  float delta = dist(x, y, prevX, prevY);
  float thresh = 30 * s - d;

  if (mousePressed && erase != true && mouseDragged) {

    if (delta >= thresh) {

      pushMatrix();
      translate (x, y);

      // Compute header angle
      // Which way should the scoop lean?
      float heading = atan2((prevY - y), (prevX-x));
      rotate(heading - PI/2.0); 

      // If we haven't yet drawn a cone, draw it
      if (!placedCone) {
        shape(cone, 0, 0, s * coneWidth, s * coneHeight);  
        placedCone = true;
      }

      int index = count%3;

      // Draw a scoop of the next flavor
      shape(scoops.get(index), -(s * scoopWidth/2), -(s * scoopHeight/2), s * scoopWidth, s * scoopHeight);  

      prevX = x;
      prevY = y;

      popMatrix();
      count++;
    }

    // Enable eraser
  } else if (mousePressed && erase == true) {
    fill(bColor);
    ellipse(mouseX, mouseY, diameter*1.7, diameter*1.7);
  }

  if (!firstScoop) {
    x = targetX;
    y = targetY;
  }

  firstScoop = false;
}

float clamp(float x, float low, float high) {
  if (x <= low) {
    return low;
  } else if (x >= high) {
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
  if (key == DELETE || key == BACKSPACE) { 
    background(bColor);
  }

  // increase brush diameter
  if (keyCode == UP) {
    diameter +=2;
    s = diameter / baseDiameter;

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

void mousePressed() {

  prevX = mouseX;
  prevY = mouseY;
}


void mouseReleased() {

  if (placedCone) {

    pushMatrix();
    translate (x, y);

    // Compute header angle
    float heading = atan2((prevY - y), (prevX-x));
    rotate(heading - PI/2.0); 

    // Draw a scoop with a cherry on top!
    int index = count%3;    
    shape(cherryScoops.get(index), -(s * scoopWidth/2), -(s * scoopHeight/2), s * scoopWidth, s * scoopHeight);

    prevX = x;
    prevY = y;

    popMatrix();
    count++;
  }

  placedCone = false;
  mouseDragged = false;
}


void mouseDragged() {
  mouseDragged = true;
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
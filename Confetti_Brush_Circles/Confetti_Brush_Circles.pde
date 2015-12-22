/* MOUSE
 * press               : draw with brush
 * 
 * KEYS
 * Delete/Backspace    : clear display
 * s                   : save png
 * e                   : hold to erase
 */


import java.util.Calendar;

//color palette
color tangerine = color(248, 178, 25);
color tangerineB = color (218, 136, 1);
color hotpink = color(235, 28, 108);
color hotpinkB = color(196, 2, 70);
color lime = color(202, 210, 37);
color limeB = color(162, 170, 7);
color turquoise = color(79, 204, 222);
color turquoiseB = color(62, 178, 202);
color lightpink = color(255, 145, 213);
color lightpinkB = color(215, 105, 173);
color medturq = color(61, 183, 197);
color medturqB = color(22, 115, 121);
color teal = color(37, 209, 166);
color tealB = color(4, 169, 126);
color purple = color(120, 131, 235);
color purpleB = color(102, 102, 204);
color purpleC = color(62, 62, 164);
color white = color(255, 255, 255);

float x, y;
float easing = 0.2;
float angle = 5.50;
boolean erase = false;
int digit = 0;
float diameter = 70;

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
    
    x = x2;
    y = y2;
    
    //draw the confetti
    float confettiDiameter = random(8,25);
    float chance = random(1,10);
    digit++; 
    if (digit > 4){digit = 0;}
    if (chance > 6) {
      float angle = random(0, HALF_PI);
      //delay(100);
      pushMatrix();
        translate(x,y);
        rotate(angle);
        noStroke();
        float xpos= random(-130,10);
        float ypos= random(-130,10);
        
        if (digit ==0){
          drawConfetti(hotpink, hotpinkB, xpos, ypos, confettiDiameter);
        }
        else if (digit ==1){
          drawConfetti(purpleB, purpleC, xpos, ypos, confettiDiameter);
        }
        else if (digit ==2){
          drawConfetti(medturq, medturqB, xpos, ypos, confettiDiameter);
        }
        else if (digit ==3){
          drawConfetti(lime, limeB, xpos, ypos, confettiDiameter);
        }
        else if (digit ==4){
          drawConfetti(purple, purpleB, xpos, ypos, confettiDiameter);
        }
      popMatrix();
    }
    
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

void drawConfetti(color color1, color color2, float passXpos, float passYpos, float passConfettiDiameter){
  fill(color2);
  ellipse(1 + passXpos, 1 + passYpos, passConfettiDiameter, passConfettiDiameter);
  fill(color1);
  ellipse(passXpos, passYpos, passConfettiDiameter, passConfettiDiameter);
};

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
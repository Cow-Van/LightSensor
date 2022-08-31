import processing.serial.*;
import cc.arduino.*;

import java.util.ArrayList;
import java.util.ListIterator;

Arduino arduino;
float lightIntensity;
int lightIntensityClamped;
boolean isHappy;
ArrayList tearDrops = new ArrayList();
int tearDropsCooldown = 0;

public void setup() {
  arduino = new Arduino(this, Arduino.list()[1], 57600);
  
  noStroke();
  size(400, 400);
}

public void draw() {
  /* --------------------- Update Varibles ---------------------- */  
  lightIntensity = arduino.analogRead(5);
  
  lightIntensityClamped = (int) (lightIntensity * 0.07);
  
  if (lightIntensityClamped > 10) {
    lightIntensityClamped = 10;
  }
  
  isHappy = lightIntensityClamped >= 5;
  
  tearDropsCooldown--;
  /* --------------------- Update Varibles End ---------------------- */
  
  background(lightIntensity);
  
  fill(255, 129, 203); // Ears
  
  stroke(255, 255, 255);
  strokeWeight(10);
  
  arc(100 - 45, 100 + 20, 200, 100, PI/1.2 - PI + PI/6, PI/1.2 - PI/6, OPEN);
  arc(151 - 45, 145 + 20, 200, 100, PI/1.2 + PI/6, PI/1.2 + PI - PI/6, OPEN);
  
  arc(100 + 240, 100 + 19, 200, 100, PI/1.2 - PI + PI/3 + PI/6, PI/1.2 + PI/3 - PI/6, OPEN);
  arc(51 + 240, 143 + 20, 200, 100, PI/1.2 + PI/3 + PI/6, PI/1.2 + PI + PI/3 - PI/6, OPEN);
  
  noStroke();
  
  fill(255, 203, 163);
  
  ellipse(200, 200, 225, 250); // Face
  
  fill(0, 0, 0); // Outer eyes
  
  ellipse(150, 175, 30, 30);
  ellipse(250, 175, 30, 30);
  
  fill(255, 255, 255); // Inner eyes
  
  ellipse(150 + 5 - lightIntensityClamped, 175, 15, 15);
  ellipse(250 + 5 - lightIntensityClamped, 175, 15, 15);
  
  fill(255, 129, 203); // Nose
  
  ellipse(200, 225, 50, 30);
  
  // Mouth
  if (isHappy) {
    arc(200, 275, 75, 50, 0, PI, OPEN);
  } else {
    arc(200, 275 + 25, 75, 50, PI, TWO_PI, OPEN);
    if (tearDropsCooldown <= 0) {
      if (Math.random() < 0.5) {
        tearDrops.add(new TearDrop(150, 175 + 30, 500));
      } else {
        tearDrops.add(new TearDrop(250, 175 + 30, 500));
      }
      
      tearDropsCooldown = 20 + (int) (Math.random() * 20);
    }
  }
  
  fill(255, 255, 255); // Hair
  
  pushMatrix();
  scale(1.25);
  translate(-40, 0);
  ellipse(200 - 25, 75, 70, 70);
  ellipse(200, 75, 40, 40);
  ellipse(200 + 30, 75, 50, 50);
  ellipse(200 + 70, 75 + 20, 20, 20);
  ellipse(200 + 60, 75, 40, 40);
  ellipse(200 + 70, 75 - 15, 20, 20);
  ellipse(200 + 50, 75 - 20, 40, 40);
  ellipse(200 + 25, 75 - 10, 50, 50);
  ellipse(200, 75 - 10, 40, 40);
  ellipse(200 - 50, 75 - 20, 50, 50);
  ellipse(200 - 70, 75 - 10, 30, 30);
  ellipse(200 - 60, 75 + 10, 40, 40);
  popMatrix();
  
  ListIterator tearDropsIterator = tearDrops.listIterator();
  
  // Update TearDrops
  while (tearDropsIterator.hasNext()) {
    TearDrop tearDrop = (TearDrop) tearDropsIterator.next();
    if(tearDrop.update()) {
      tearDrops.remove(tearDrop);
      try {
        tearDropsIterator = tearDrops.listIterator(tearDropsIterator.nextIndex());
      } catch (IndexOutOfBoundsException e) {
        break;
      }
    }
  }
}

public class TearDrop {
  float x;
  float y;
  float deleteY;
  
  public TearDrop(float x, float y, float deleteY) {
    this.x = x;
    this.y = y;
    this.deleteY = deleteY;
  }
  
  public boolean update() {
    y += 3;
    
    if (y > deleteY) {
      return true;
    }
    
    draw();
    
    return false;
  }
  
  public void draw() {
    fill(#BEE9D7);
    arc(x, y, 20, 20, 0, PI);
    triangle(x - 10, y, x + 10, y, x, y - 30);
  }
}

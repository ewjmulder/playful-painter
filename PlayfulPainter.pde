import java.util.*;

EffectType DISTORT = new EffectType("Distort");

PImage img;
List<PImage> imgs;
String imgName;
int imgWidth = 700;
int imgHeight = 500;
int maxX = imgWidth - 1;
int maxY = imgHeight - 1;
int glowWidth = 20;
int glowHeight = 20;

boolean playing = false;
int imgFrameCount = 1;
int imgFrameRate = 10;

void setup() {
  size(1000, 800);
  frameRate(30);
  
  img = loadImage("dorse.jpg");
  imgName = "Dorse";
  imgs = new ArrayList<PImage>();
}

void draw() {
  background(0);
  
  image(img, 0, 0);
  drawPlayer();
  //drawGlow();
  drawStatus();
  
/*  
  if (exportCounter == 0) {
    exportAnimatedGif.addFrame("AnimatedGifShop", 50);
  } else if (exportCounter < 50) {
    stroke(0);
    line(0, 0, random(100), random(100));
    exportAnimatedGif.addFrame("AnimatedGifShop", 50);
  } else if (exportCounter == 50) {
    exportAnimatedGif.export();
  }  
  exportCounter++;
*/
}

void drawPlayer() {
  // draw record button
  fill(255, 0, 0);
  stroke(255);
  strokeWeight(1);
  ellipseMode(CORNER);
  ellipse(0 + 2, imgHeight + 2, 20, 20);
  
  //draw play button
  fill(255);
  noStroke();
  triangle(20 + 5, imgHeight + 2, 20 + 5 + 25, imgHeight + 2 + 10, 20 + 5, imgHeight + 2 + 20);

}

void drawGlow() {
  for (int y = 0; y < imgHeight; y++) {
    for (int x = 0; x < glowWidth; x++) {
      color c = getColor(maxX - x, y);
      set(imgWidth + x, y, addAlpha(c, (int) map(x, 0, glowWidth - 1, 255, 100)));
    }
  }
}

void drawStatus() {
  int marginLeft = 50;
  int marginTop = 50;
  
  PFont font = createFont("Arial", 16, true);
  fill(255);
  textFont(font, 24);
  text("Animated GIF Shop!", imgWidth + marginLeft, marginTop);
  text(imgName, imgWidth + marginLeft, marginTop + 20);
  text("#frames: " + imgFrameCount, imgWidth + marginLeft, marginTop + 20 + 20);

}

void mouseDragged() {
  if (mouseX < imgWidth && mouseY < imgHeight) {
    img.loadPixels();
    int range = 20;
    for (int y = 0; y < imgHeight; y++) {
      for (int x = 0; x < imgWidth; x++) {
        if (dist(x, y, mouseX, mouseY) <= range) {
          color c = getColor(x, y);
          color newColor = distort(c, 25);
          setColor(x, y, newColor);
        }
      }
    }
    
    img.updatePixels();
  }

}

//TODO: move stuff below to some kind of util

// Get the pixel value of the current image 'img' at the given x and y position.
// This method assumes the pixel values in the pixels array are up to date (update by calling img.loadPixels()).
color getColor(int x, int y) {
  return img.pixels[y * imgWidth + x];
}

void setColor(int x, int y, color c) {
  img.pixels[y * imgWidth + x] = c;
}

color addAlpha(color c, int a) {
  return color(red(c), green(c), blue(c), a);
}

color distort(color c, int magnitude) {
  return color(distortColorValue((int) red(c), magnitude), distortColorValue((int) green(c), magnitude), distortColorValue((int) blue(c), magnitude));
}

int distortColorValue(int colorValue, int magnitude) {
  int newColorValue = colorValue + (int) random(-magnitude, magnitude);
  if (newColorValue < 0) newColorValue = 0;
  if (newColorValue > 255) newColorValue = 255;
  return newColorValue;
}



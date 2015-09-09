import java.util.*;

EffectType DISTORT = new EffectType("Distort");

PImage imgBackground;
int backgroundWidth = 1000;
int backgroundHeight = 800;
PImage cursorBrush;
PImage imgPainting;
String imgName;
int imgX = 30;
int imgY = 88;
int imgWidth = 503;
int imgHeight = 583;

int controlsX = 600;
int controlsY = 400;
int controlsWidth = 350;
int controlsHeight = 350;


void setup() {
  size(backgroundWidth, backgroundHeight);
  frameRate(60);

  cursorBrush = loadImage("cursorBrush.png");

  imgBackground = loadImage("background-cutout.png");
  imgBackground.loadPixels();

  imgPainting = loadImage("dorse-cutout.jpg");
  imgName = "Dorse";
}

void draw() {
  image(imgPainting, imgX, imgY);
  image(imgBackground, 0, 0);
  drawPaletteEffects();
  drawControls();
  
  if (onPainting(mouseX, mouseY)) {
    cursor(cursorBrush, 0, 0);
  } else {
    cursor(ARROW);
  }
}

boolean onPainting(int x, int y) {
  return alpha(imgBackground.pixels[y * backgroundWidth + x]) == 0;
}

void drawPaletteEffects() {
  ellipseMode(CORNER);
  stroke(255);
  strokeWeight(2);
  fill(255, 0, 255, 150);
  ellipse(568, 154, 60, 60); // white
  ellipse(593, 88, 60, 60);  // black
  ellipse(673, 83, 60, 60);  // gray
  ellipse(651, 250, 60, 60); // red
  ellipse(745, 260, 60, 60); // green
  ellipse(840, 255, 60, 60); // blue
  ellipse(905, 207, 60, 60); // yellow
  ellipse(871, 142, 60, 60); // brown
}

void drawControls() {
  noStroke();
  fill(0, 0, 0, 100);
  rect(controlsX, controlsY, controlsWidth, controlsHeight);
  
  PFont font = createFont("Arial", 16, true);
  fill(255);
  textFont(font, 24);
  text(imgName, controlsX + 50, controlsY + 50);

}

void mouseDragged() {
  if (mouseX < imgWidth && mouseY < imgHeight) {
    imgPainting.loadPixels();
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
    
    imgPainting.updatePixels();
  }

}

//TODO: move stuff below to some kind of util

// Get the pixel value of the current image 'img' at the given x and y position.
// This method assumes the pixel values in the pixels array are up to date (update by calling img.loadPixels()).
color getColor(int x, int y) {
  return imgPainting.pixels[y * imgWidth + x];
}

void setColor(int x, int y, color c) {
  imgPainting.pixels[y * imgWidth + x] = c;
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



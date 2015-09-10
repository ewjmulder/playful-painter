import java.util.*;
import processing.video.*;
import static javax.swing.JOptionPane.*;

EffectType DISTORT = new EffectType("Distort");

Capture cam;
boolean cameraRunning = false;
PImage cursorCamera;
int CAM_INDEX = 11;

PImage[] images = new PImage[6];
int CAMERA_IMAGE_INDEX = 5;
PImage imgBackground;
PImage imgBackgroundStart;
int backgroundWidth = 1000;
int backgroundHeight = 800;
PImage cursorBrush;
PImage imgPainting;
int imgX = 30;
int imgY = 88;
int imgWidth = 503;
int imgHeight = 583;

int controlsX = 580;
int controlsY = 380;
int controlsWidth = 400;
int controlsHeight = 400;

PImage buttonNew, buttonOpen, buttonSave, buttonQuit;
int buttonMargin = 5;
int buttonY = 390;
int buttonNewX = 599, buttonNewY = buttonY, buttonNewWidth = 85, buttonNewHeight = 40;
int buttonOpenX = buttonNewX + buttonNewWidth + buttonMargin, buttonOpenY = buttonY, buttonOpenWidth = 93, buttonOpenHeight = 40;
int buttonSaveX = buttonOpenX + buttonOpenWidth + buttonMargin, buttonSaveY = buttonY, buttonSaveWidth = 86, buttonSaveHeight = 40;
int buttonQuitX = buttonSaveX + buttonSaveWidth + buttonMargin, buttonQuitY = buttonY, buttonQuitWidth = 83, buttonQuitHeight = 40;

boolean showLibrary = false;
int libraryTopLeftX = 599;
int libraryTopLeftY = 462;
int libraryImageMargin = 10;
int libraryImageWidth = 114;
int libraryImageHeight = 132;

void setup() {
  size(backgroundWidth, backgroundHeight);
  frameRate(60);
  
  cursorCamera = loadImage("cursorCamera.png");
  String[] cameras = Capture.list();
  cam = new Capture(this, cameras[CAM_INDEX]);

  cursorBrush = loadImage("cursorBrush.png");

  imgBackgroundStart = loadImage("background.png");
  imgBackground = loadImage("background-cutout.png");
  imgBackground.loadPixels();

  images[0] = loadImage("dorse-cutout.jpg");
  images[1] = loadImage("dorse-cutout.jpg");
  images[2] = loadImage("dorse-cutout.jpg");
  images[3] = loadImage("dorse-cutout.jpg");
  images[4] = loadImage("dorse-cutout.jpg");
  images[CAMERA_IMAGE_INDEX] = null; // Reserved for camera image
  
  buttonNew = loadImage("buttonNew.png");
  buttonOpen = loadImage("buttonOpen.png");
  buttonSave = loadImage("buttonSave.png");
  buttonQuit = loadImage("buttonQuit.png");
}

void draw() {
  pickCursor();
  if (cameraRunning) {
    if (cam.available() == true) {
      cam.read();
    }
    set(0, 0, cam);
    noFill();
    stroke(132, 34, 224);
    strokeWeight(3);
    rectMode(CENTER);
    rect(mouseX, mouseY, imgWidth, imgHeight, 7);
  } else {
    if (imgPainting != null) {
      image(imgPainting, imgX, imgY);
      image(imgBackground, 0, 0);
    } else {
      image(imgBackgroundStart, 0, 0);
    }      
    drawPaletteEffects();
    drawControls();
  }
}

void pickCursor() {
  if (cameraRunning) {
    cursor(cursorCamera);
  } else if (onPainting(mouseX, mouseY)) {
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
  rectMode(CORNER);
  rect(controlsX, controlsY, controlsWidth, controlsHeight);
  
  PFont font = createFont("Arial", 16, true);
  fill(255);
  textFont(font, 24);
//  text(imgName, controlsX + 50, controlsY + 50);

  image(buttonNew, buttonNewX, buttonNewY);
  image(buttonOpen, buttonOpenX, buttonOpenY);
  image(buttonSave, buttonSaveX, buttonSaveY);
  image(buttonQuit, buttonQuitX, buttonQuitY);

  if (showLibrary) {
    for (int gridY = 0; gridY <= 1; gridY++) {
      for (int gridX = 0; gridX <= 2; gridX++) {
        int index = gridY * 3 + gridX;
        if (images[index] != null) {
          image(images[index], libraryTopLeftX + gridX * (libraryImageMargin + libraryImageWidth), libraryTopLeftY + gridY * (libraryImageMargin + libraryImageHeight), libraryImageWidth, libraryImageHeight);
        }
      }
    }
  }

}

void mouseDragged() {
  if (paintingLoaded() && onPainting(mouseX, mouseY)) {
    imgPainting.loadPixels();
    int range = 20;
    for (int y = 0; y < imgHeight; y++) {
      for (int x = 0; x < imgWidth; x++) {
        int screenX = imgX + x;
        int screenY = imgY + y;
        if (dist(screenX, screenY, mouseX, mouseY) <= range) {
          color c = getColor(x, y);
          color newColor = distort(c, 25);
          setColor(x, y, newColor);
        }
      }
    }
    
    imgPainting.updatePixels();
  }
}

void mousePressed() {
  if (cameraRunning) {
    images[CAMERA_IMAGE_INDEX] = cam.get(mouseX - (imgWidth / 2), mouseY - (imgHeight / 2), imgWidth, imgHeight);
    imgPainting = images[CAMERA_IMAGE_INDEX];
    showLibrary = false;
    cam.stop();
    cameraRunning = false;
  } else {
    if (mouseX >= buttonNewX && mouseX <= buttonNewX + buttonNewWidth && mouseY >= buttonNewY && mouseY <= buttonNewY + buttonNewHeight) {
      cam.start();
      cameraRunning = true;
    } else if (mouseX >= buttonOpenX && mouseX <= buttonOpenX + buttonOpenWidth && mouseY >= buttonOpenY && mouseY <= buttonOpenY + buttonOpenHeight) {
      showLibrary = true;
    } else if (mouseX >= buttonSaveX && mouseX <= buttonSaveX + buttonSaveWidth && mouseY >= buttonSaveY && mouseY <= buttonSaveY + buttonSaveHeight) {
      if (imgPainting != null) {
        String filename = "playful-painter-" + year() + "-" + month() + "-" + day() + "_" + hour() + "-" + minute() + "-" + second() + ".jpg";
        imgPainting.save(filename);
        showMessageDialog(null, "Your painting has been saved on disk with the name: '" + filename + "'.", "Save",  INFORMATION_MESSAGE);
      }
    } else if (mouseX >= buttonQuitX && mouseX <= buttonQuitX + buttonQuitWidth && mouseY >= buttonQuitY && mouseY <= buttonQuitY + buttonQuitHeight) {
      exit();
    }
    
    if (showLibrary) {
      for (int gridY = 0; gridY <= 1; gridY++) {
        for (int gridX = 0; gridX <= 2; gridX++) {
          int currentX = libraryTopLeftX + gridX * (libraryImageMargin + libraryImageWidth);
          int currentY = libraryTopLeftY + gridY * (libraryImageMargin + libraryImageHeight);
          if (mouseX >= currentX && mouseX <= currentX + libraryImageWidth && mouseY >= currentY && mouseY <= currentY + libraryImageHeight) {
            int index = gridY * 3 + gridX;
            if (images[index] != null) {
              imgPainting = images[index];
              showLibrary = false;
            }
          }
        }
      }
    }
  }
}

boolean paintingLoaded() {
  return imgPainting != null;
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



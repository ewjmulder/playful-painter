import java.util.*;
import processing.video.*;
import static javax.swing.JOptionPane.*;

EffectType BLACK_WHITE = new EffectType("Black & White", 568, 154);
EffectType GRAYSCALE = new EffectType("Grayscale", 593, 88);
EffectType TINT = new EffectType("Tint", 673, 83);
EffectType ORIGINAL = new EffectType("Original", 651, 250);
EffectType SHARPEN = new EffectType("Sharpen", 745, 260);
EffectType BLUR = new EffectType("Blur", 840, 255);
EffectType EDGE_DETECT = new EffectType("Edge Detect", 905, 207);
EffectType SHAPES = new EffectType("Circles", 871, 142);

EffectType[] effects = new EffectType[] {
  BLACK_WHITE, GRAYSCALE, TINT, ORIGINAL, SHARPEN, BLUR, EDGE_DETECT, SHAPES
};

EffectType selectedEffect = ORIGINAL;

float[][] sharpenMatrix = { { -1, -1, -1 },
                            { -1,  9, -1 },
                            { -1, -1, -1 } }; 

float[][] blurMatrix =    { { 1.0/9, 1.0/9, 1.0/9 },
                            { 1.0/9, 1.0/9, 1.0/9 },
                            { 1.0/9, 1.0/9, 1.0/9 } }; 

PImage cursorPipette;

Capture cam;
boolean cameraRunning = false;
PImage cursorCamera;
int CAM_INDEX = 11;

PImage[] originalImages = new PImage[6];
PImage[] images = new PImage[6];
int CAMERA_IMAGE_INDEX = 5;
PImage imgBackground;
PImage imgBackgroundStart;
int backgroundWidth = 1000;
int backgroundHeight = 800;
PImage cursorBrush;
PImage imgPainting;
int paintingIndex;
int imgX = 30;
int imgY = 88;
int imgWidth = 503;
int imgHeight = 583;

int controlsX = 580;
int controlsY = 380;
int controlsWidth = 400;
int controlsHeight = 400;

int sliderTitleX = 599;
int sliderWidth = 250;
int sliderX = 710;
int slider0Y = 460;
int slider1Y = 500;
int slider2Y = 540;
int slider3Y = 580;
int slider4Y = 620;

HScrollbar brushSizeSlider = new HScrollbar(new SliderData("Brush", 1, 50), sliderX, slider0Y, sliderWidth, 20, 16, 20);

HScrollbar blackWhiteThresholdSlider = new HScrollbar(new SliderData("Threshold", 0, 255), sliderX, slider1Y, sliderWidth, 20, 16, 127);

HScrollbar tintRedSlider = new HScrollbar(new SliderData("Red", 0, 255), sliderX, slider1Y, sliderWidth, 20, 16, 200);
HScrollbar tintGreenSlider = new HScrollbar(new SliderData("Green", 0, 255), sliderX, slider2Y, sliderWidth, 20, 16, 100);
HScrollbar tintBlueSlider = new HScrollbar(new SliderData("Blue", 0, 255), sliderX, slider3Y, sliderWidth, 20, 16, 200);
HScrollbar tintStrengthSlider = new HScrollbar(new SliderData("Strength", 0, 1), sliderX, slider4Y, sliderWidth, 20, 16, 0.5);

HScrollbar edgeDetectStrengthSlider = new HScrollbar(new SliderData("Strength", 0.5, 2), sliderX, slider1Y, sliderWidth, 20, 16, 1.5);

HScrollbar sharpenStrengthSlider = new HScrollbar(new SliderData("Strength", 1, 9), sliderX, slider1Y, sliderWidth, 20, 16, 7);

HScrollbar blurStrengthSlider = new HScrollbar(new SliderData("Strength", 1, 1.0/9), sliderX, slider1Y, sliderWidth, 20, 16, 0.2);

HScrollbar shapesRadiusSlider = new HScrollbar(new SliderData("Size", 1, 25), sliderX, slider1Y, sliderWidth, 20, 16, 8);

int effectRadius = 30;
int effectDiameter = effectRadius * 2;

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
  cursorPipette = loadImage("cursorPipette.png");

  imgBackgroundStart = loadImage("background.png");
  imgBackground = loadImage("background-cutout.png");
  imgBackground.loadPixels();

  images[0] = loadImage("Mick.jpg");
  images[1] = loadImage("Marco.jpg");
  images[2] = loadImage("Matt.jpg");
  images[3] = loadImage("dorse-cutout.jpg");
  images[4] = loadImage("sunflower.jpg");
  images[CAMERA_IMAGE_INDEX] = null; // Reserved for camera image

  BLACK_WHITE.setIcon(loadImage("effect_black_white.png"));
  GRAYSCALE.setIcon(loadImage("effect_grayscale.png"));
  TINT.setIcon(loadImage("effect_tint.png"));
  ORIGINAL.setIcon(loadImage("effect_original.png"));
  SHARPEN.setIcon(loadImage("effect_sharpen.png"));
  BLUR.setIcon(loadImage("effect_blur.png"));
  EDGE_DETECT.setIcon(loadImage("effect_edge_detect.png"));
  SHAPES.setIcon(loadImage("effect_circles.png"));

  BLACK_WHITE.addSlider(blackWhiteThresholdSlider);

  TINT.addSlider(tintRedSlider);
  TINT.addSlider(tintGreenSlider);
  TINT.addSlider(tintBlueSlider);
  TINT.addSlider(tintStrengthSlider);

  SHARPEN.addSlider(sharpenStrengthSlider);

  BLUR.addSlider(blurStrengthSlider);

  EDGE_DETECT.addSlider(edgeDetectStrengthSlider);

  SHAPES.addSlider(shapesRadiusSlider);
  
  // Make a copy of all initial image states and safe them as original images, to be used as brush.
  for (int i = 0; i < CAMERA_IMAGE_INDEX; i++) {
    originalImages[i] = images[i].get();
  }
  
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
    if (onPainting(mouseX, mouseY)) {
      pushMatrix();
      translate(mouseX, mouseY);
      stroke(0);
      strokeWeight(1);
      dashedCircle(brushSizeSlider.getValue(), 4, 6);
      popMatrix();
    }
    drawPaletteEffects();
    drawControls();
    for (EffectType effect : effects) {
      if (dist(mouseX, mouseY, effect.getIconX() + effectRadius, effect.getIconY() + effectRadius) <= effectRadius) {
        PFont font = createFont("Arial Italic", 20, true);
        fill(255);
        textFont(font, 20);
        textAlign(RIGHT, BOTTOM);
        text(effect.getName(), mouseX, mouseY);
      }
    }
  }
  
}
 
void pickCursor() {
  if (cameraRunning) {
    cursor(cursorCamera);
  } else if (onPainting(mouseX, mouseY)) {
    cursor(cursorBrush, 0, 0);
  } else {
    cursor(ARROW);
    for (EffectType effect : effects) {
      if (dist(mouseX, mouseY, effect.getIconX() + effectRadius, effect.getIconY() + effectRadius) <= effectRadius) {
        //cursor(cursorPipette, 0, 0);
      }
    }
  }
}

boolean onPainting(int x, int y) {
  return x >= 0 && x < backgroundWidth && y >= 0 && y < backgroundHeight && alpha(imgBackground.pixels[y * backgroundWidth + x]) == 0;
}

void drawPaletteEffects() {
  ellipseMode(CORNER);
  strokeWeight(2);
  
  for (EffectType effect : effects) {
    if (effect.getIcon() != null ) {
      image(effect.getIcon(), effect.getIconX(), effect.getIconY());
      noFill();
    } else {
      fill(255, 0, 255, 150);
    }
    if (effect == selectedEffect) {
      stroke(255, 0, 0);
    } else {
      stroke(255);
    }
    ellipse(effect.getIconX(), effect.getIconY(), effectDiameter, effectDiameter);  
  }
}

void drawControls() {
  noStroke();
  fill(0, 0, 0, 100);
  rectMode(CORNER);
  rect(controlsX, controlsY, controlsWidth, controlsHeight);
  
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
  } else {
    // Always show brush size slider
    showSlider(brushSizeSlider);
    for (HScrollbar slider : selectedEffect.getSliders()) {
      showSlider(slider);
    }
  }
}

void showSlider(HScrollbar slider) {
  PFont font = createFont("Arial Bold", 20, true);
  fill(255);
  textFont(font, 20);
  textAlign(LEFT, TOP);
  text(slider.getName() + ":", sliderTitleX, slider.ypos);
//  text(slider.getValue(), sliderTitleX, slider.ypos);
  slider.update();
  slider.display();
}

void mouseDragged() {
  if (paintingLoaded() && onPainting(mouseX, mouseY)) {
    imgPainting.loadPixels();
    // TODO: more efficient: only loop over 'box' around circle.
    for (int y = 0; y < imgHeight; y++) {
      for (int x = 0; x < imgWidth; x++) {
        int screenX = imgX + x;
        int screenY = imgY + y;
        if (dist(screenX, screenY, mouseX, mouseY) <= brushSizeSlider.getValue()) {
          performEffect(selectedEffect, x, y);
        }
      }
    }
    imgPainting.updatePixels();
  }
}

void mousePressed() {
  if (cameraRunning) {
    images[CAMERA_IMAGE_INDEX] = cam.get(mouseX - (imgWidth / 2), mouseY - (imgHeight / 2), imgWidth, imgHeight);
    originalImages[CAMERA_IMAGE_INDEX] = images[CAMERA_IMAGE_INDEX].get();
    imgPainting = images[CAMERA_IMAGE_INDEX];
    paintingIndex = CAMERA_IMAGE_INDEX;
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
    
    for (EffectType effect : effects) {
      if (dist(mouseX, mouseY, effect.getIconX() + effectRadius, effect.getIconY() + effectRadius) <= effectRadius) {
//        System.out.println("Selected effect: " + effect.getName());
        selectedEffect = effect;
      }
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
              paintingIndex = index;
              showLibrary = false;
            }
          }
        }
      }
    }
  }
}

void performEffect(EffectType effect, int x, int y) {
  if (effect == BLACK_WHITE) {
    performBlackWhite(x, y);
  } else if (effect == GRAYSCALE) {
    performGrayScale(x, y);
  } else if (effect == TINT) {
    performTint(x, y);
  } else if (effect == ORIGINAL) {
    performOriginal(x, y);
  } else if (effect == SHARPEN) {
    performSharpen(x, y);
  } else if (effect == BLUR) {
    performBlur(x, y);
  } else if (effect == EDGE_DETECT) {
    performEdgeDetect(x, y);
  } else if (effect == SHAPES) {
    performShapes(x, y);
  }
    
}

void performDistort(int x, int y) {
  color c = getColor(x, y);
  color newColor = distort(c, 25);
  setColor(x, y, newColor);
}

void performBlackWhite(int x, int y) {
  color c = getColor(x, y);
  color newColor = decideBlackWhite(c, blackWhiteThresholdSlider.getValue());
  setColor(x, y, newColor);
}

void performGrayScale(int x, int y) {
  color c = getColor(x, y);
  color newColor = decideGrayScale(c);
  setColor(x, y, newColor);
}

// FIXME: Taking the original is a workaround for the problem that every mouseDragged will have overlapping regions that quickly become the tint color,
// for effects that are relative, because the effect is applied multiple times.
// This workaround only works on original areas of the painting. A full solution should probably include keeping track of every pixel that was tinted with the current brush.

void performTint(int x, int y) {
  color c = getOriginalColor(x, y);
  color newColor = decideTint(c, (int) tintRedSlider.getValue(), (int) tintGreenSlider.getValue(), (int) tintBlueSlider.getValue(), tintStrengthSlider.getValue());
  setColor(x, y, newColor);
}

void performOriginal(int x, int y) {
  color originalColor = getOriginalColor(x, y);
  setColor(x, y, originalColor);
}

void performSharpen(int x, int y) {
  color c = getOriginalColor(x, y);
  float[][] matrix = applyStrength(sharpenMatrix, sharpenStrengthSlider.getValue());
  color newColor = convolution(x, y, matrix, 3, originalImages[paintingIndex]);
  setColor(x, y, newColor);
}

void performBlur(int x, int y) {
  color c = getOriginalColor(x, y);
  float[][] matrix = applyStrength(blurMatrix, blurStrengthSlider.getValue());
  color newColor = convolution(x, y, matrix, 3, originalImages[paintingIndex]);
  setColor(x, y, newColor);
}

void performEdgeDetect(int x, int y) {
  color originalColor = getOriginalColor(x, y);
  color newColor = color(0);
  if (x > 0) {
    color colorLeft = getOriginalColor(x - 1, y);    
    // New color is difference between pixel and left neighbor
    float newColorValue = abs(brightness(originalColor) - brightness(colorLeft));
    newColorValue = newColorValue * edgeDetectStrengthSlider.getValue();
    if (newColorValue > 255) newColorValue = 255;
    newColor = color(newColorValue);
  }
  setColor(x, y, newColor);
}

void performShapes(int x, int y) {
  // Randomly decide if this point will be 'upgraded' to a shape.
  if (random(0, 1) > 0.998) {
    color originalColor = getOriginalColor(x, y);
    int radius = (int) shapesRadiusSlider.getValue();
    for (int shapeX = max(0, x - radius); shapeX < min(imgWidth, x + radius); shapeX++) {
      for (int shapeY = max(0, y - radius); shapeY < min(imgHeight, y + radius); shapeY++) {
        if (dist(x, y, shapeX, shapeY) < radius) {
          setColor(shapeX, shapeY, originalColor);
        }
      }
    }
  }
}

boolean paintingLoaded() {
  return imgPainting != null;
}

// Get the pixel value of the current image 'img' at the given x and y position.
// This method assumes the pixel values in the pixels array are up to date (update by calling img.loadPixels()).
color getColor(int x, int y) {
  return imgPainting.pixels[y * imgWidth + x];
}

color getOriginalColor(int x, int y) {
  return originalImages[paintingIndex].pixels[y * imgWidth + x];
}

void setColor(int x, int y, color c) {
  imgPainting.pixels[y * imgWidth + x] = c;
}

color addAlpha(color c, int a) {
  return color(red(c), green(c), blue(c), a);
}

float[][] applyStrength(float[][] matrix, float middleValue) {
  float otherValue = (1 - middleValue) / 8;
  return new float[][] { { otherValue, otherValue,  otherValue },
                         { otherValue, middleValue, otherValue },
                         { otherValue, otherValue,  otherValue } };
}

color distort(color c, int magnitude) {
  return color(distortColorValue((int) red(c), magnitude), distortColorValue((int) green(c), magnitude), distortColorValue((int) blue(c), magnitude));
}

color decideBlackWhite(color c, float threshold) {
  color bw = color(0);
  if (brightness(c) > threshold) {
    bw = color(255);
  }
  return bw;
}

color decideGrayScale(color c) {
  return color(brightness(c));
}

color decideTint(color c, int red, int green, int blue, float strength) {
  color tint = color(red, green, blue);
  return lerpColor(c, tint, strength);
}

int distortColorValue(int colorValue, int magnitude) {
  int newColorValue = colorValue + (int) random(-magnitude, magnitude);
  if (newColorValue < 0) newColorValue = 0;
  if (newColorValue > 255) newColorValue = 255;
  return newColorValue;
}

color convolution(int x, int y, float[][] matrix, int matrixsize, PImage img) {
  float rtotal = 0.0;
  float gtotal = 0.0;
  float btotal = 0.0;
  int offset = matrixsize / 2;
  // Loop through convolution matrix
  for (int i = 0; i < matrixsize; i++){
    for (int j = 0; j < matrixsize; j++){
      // What pixel are we testing
      int xloc = x+i-offset;
      int yloc = y+j-offset;
      int loc = xloc + img.width*yloc;
      // Make sure we have not walked off the edge of the pixel array
      loc = constrain(loc,0,img.pixels.length-1);
      // Calculate the convolution
      // We sum all the neighboring pixels multiplied by the values in the convolution matrix.
      rtotal += (red(img.pixels[loc]) * matrix[i][j]);
      gtotal += (green(img.pixels[loc]) * matrix[i][j]);
      btotal += (blue(img.pixels[loc]) * matrix[i][j]);
    }
  }
  // Make sure RGB is within range
  rtotal = constrain(rtotal,0,255);
  gtotal = constrain(gtotal,0,255);
  btotal = constrain(btotal,0,255);
  // Return the resulting color
  return color(rtotal,gtotal,btotal);
}

void dashedCircle(float radius, int dashWidth, int dashSpacing) {
    int steps = 200;
    int dashPeriod = dashWidth + dashSpacing;
    boolean lastDashed = false;
    for(int i = 0; i < steps; i++) {
      boolean curDashed = (i % dashPeriod) < dashWidth;
      if(curDashed && !lastDashed) {
        beginShape();
      }
      if(!curDashed && lastDashed) {
        endShape();
      }
      if(curDashed) {
        float theta = map(i, 0, steps, 0, TWO_PI);
        vertex(cos(theta) * radius, sin(theta) * radius);
      }
      lastDashed = curDashed;
    }
    if(lastDashed) {
      endShape();
    }
}


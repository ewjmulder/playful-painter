class HScrollbar {
  
  boolean jsMode = (""+2.0 == ""+2); 

  SliderData sliderData;
  int swidth, sheight;    // width and height of bar
  float xpos, ypos;       // x and y position of bar
  float spos, newspos;    // x position of slider
  float sposMin, sposMax, sposMaxSane; // max and min values of slider
  int loose;              // how loose/heavy
  boolean over;           // is the mouse over the slider?
  boolean locked;
  float ratio;
  
  MouseDownChecker mouseDownChecker;

  HScrollbar (SliderData sliderData, float xp, float yp, int sw, int sh, int l, float initialValue) {
    this.sliderData = sliderData;
    swidth = sw;
    sheight = sh;
    int widthtoheight = sw - sh;
    ratio = (float)sw / (float)widthtoheight;
    xpos = xp;
    ypos = yp-sheight/2;
//    spos = xpos + swidth/2 - sheight/2;
    float initialRatio = map(initialValue, sliderData.min, sliderData.max, 0, 1);
    spos = xpos + initialRatio * (swidth - sheight);
    newspos = spos;
    sposMin = xpos;
    sposMax = xpos + swidth - sheight;
    loose = l;
    
    if (jsMode) {
      mouseDownChecker = new BrowserMouseDownChecker();
    } else {
      mouseDownChecker = new DesktopMouseDownChecker();
    }    
  }

  void update() {
    if (over && overEvent() || !over && overEvent() && !mouseDownChecker.isMouseDown()) {
      over = true;
    } else {
      over = false;
    }
    if (mousePressed && over) {
      locked = true;
    }
    if (!mousePressed) {
      locked = false;
    }
    if (locked) {
      newspos = constrain(mouseX-sheight/2, sposMin, sposMax);
    }
    if (abs(newspos - spos) > 1) {
      spos = spos + (newspos-spos)/loose;
    }
  }
  
  float constrain(float val, float minv, float maxv) {
    return min(max(val, minv), maxv);
  }

  boolean overEvent() {
    if (mouseX > xpos && mouseX < xpos+swidth &&
       mouseY > ypos && mouseY < ypos+sheight) {
      return true;
    } else {
      return false;
    }
  }

  void display() {
    noStroke();
    fill(204);
    rect(xpos, ypos, swidth, sheight);
    if (over || locked) {
      fill(0, 0, 0);
    } else {
      fill(102, 102, 102);
    }
    rect(spos, ypos, sheight, sheight);
  }

  float getPos() {
    // Convert spos to be values between
    // 0 and the total width of the scrollbar
    return spos * ratio;
  }
  
  String getName() {
    return sliderData.name;
  }
  
  float getValue() {
    return map(spos, sposMin, sposMax, sliderData.min, sliderData.max);
  }
  
}

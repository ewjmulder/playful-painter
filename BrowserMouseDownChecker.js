function BrowserMouseDownChecker() {

  this.isMouseDown = function() {
    return mouseDown > 0;
  }
  
}


var mouseDown = 0;

var currentOnLoad = window.onload;
window.onload = function() {
  if (currentOnLoad != null) {
    currentOnLoad();
  }
  document.body.onmousedown = function() {
    ++mouseDown;
  }
  document.body.onmouseup = function() {
    --mouseDown;
  }
}


function BrowserVideo() {
  var video = document.createElement("video");
  video.setAttribute("style", "display:none;");
  video.setAttribute("id", "videoOutput");
  //video.setAttribute("width", "503px");
  //video.setAttribute("height", "583px");
  video.setAttribute("autoplay", "true");
  
  window.onload = function() {
    document.body.appendChild(video);
  }
  
  var stream;
  var hasVideoApi = true;
  var error = false;
  var ctx;
  
  this.initVideoJs = function() {
    if (navigator.webkitGetUserMedia) {
      navigator.webkitGetUserMedia({video: true}, gotStream, noStream);
    } else if (navigator.getUserMedia) {
      navigator.getUserMedia({video: true}, gotStream, noStream);
    } else {
      hasVideoApi = false;
    }
    var p = Processing.getInstanceById("PlayfulPainter");
    ctx = p.externals.context;
  
    return hasVideoApi;
  }
  
  function gotStream(aStream) {
    stream = aStream;
    video.src = URL.createObjectURL(stream);
    video.onerror = function () {
      stream.stop();
      streamError();
    };
  }
  
  this.stopVideoJs = function() {
    if (stream != null) {
      stream.stop();  
    }
  }
   
  function noStream() {
    error = true;
    alert('No camera available.');
  }
  
  function streamError() {
    error = true;
    alert('Camera error.');
  }
  
  var appWidth = 1000;
  var appHeight = 800;
  var appRatio = appWidth / appHeight;
  
  this.drawVideoJs = function() {
    if (error) return false;
    
    var videoWidth = video.videoWidth;
    var videoHeight = video.videoHeight;
    var videoRatio = videoWidth / videoHeight;
    
    var drawWidth, drawHeight;
    if (videoRatio >= appRatio) {
      drawWidth = appWidth;
      drawHeight = appWidth / videoRatio;
    } else {
      drawHeight = appHeight;
      drawWidth = appHeight * videoRatio;
    }
    
    ctx.drawImage(video, (appWidth - drawWidth) / 2, (appHeight - drawHeight) / 2, drawWidth, drawHeight);
    return true;
  }
}

function BrowserImageSaving() {
  
  this.saveImage = function() {
    var canvas = document.getElementById("PlayfulPainter");
    var dataURL = canvas.toDataURL();
    $.ajax({
      type: "POST",
      url: "/image/upload",
      data: { 
         imgBase64: dataURL
      }
    }).done(function(response) {
      alert("response: " + response);
    });
  }
  
}

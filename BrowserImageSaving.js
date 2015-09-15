function BrowserImageSaving() {
  
  this.saveImage = function() {
    var canvas = document.getElementById("PlayfulPainter");
    var dataURL = canvas.toDataURL("image/jpeg", 0.8);
    $.ajax({
      type: "POST",
      url: "/image/upload",
      data: { 
         imgBase64: dataURL
      }
    }).done(function(response) {
      var $newLink = $("<div><a href='" + response + "'>Download saved image</a> - " + new Date().toString() + "</div>");
      $("body").append($newLink);
      alert("Save completed, see link at the bottom of this page to download the image.");
    });
  }
  
}

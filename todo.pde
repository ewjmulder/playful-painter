/*
TODO / IDEAS:

Playful Painter:
- ezel + verfbord als achtergrond -> maken in paint shop pro (incl 'verfjes')! Als bg volledig image inladen.
- try to integrate some concepts that we learned, like sliders etc, maybe 'play' an image

See also: http://camanjs.com/examples/

UI: home made tabs, buttons, sliders (html5 / http://www.openprocessing.org/sketch/115256 / https://processing.org/examples/scrollbar.html / http://processingjs.org/learning/topic/scrollbar/)
http://processingjs.org/learning/topic/imagebutton/
http://processingjs.org/learning/topic/buttons/

http://processingjs.org/learning/topic/

https://processing.org/reference/blend_.html

Other kind of manipulation category: changes that 'loop' and create a certain behavior / effect

- Coming at you / moving away from you.
- Constant small changes  in pixels to create a sense of motion
- Swirl / draaikolk that suck up the images and at the end 'gives' them back
- 'loop' though color cycle / b/w , etc

- RECORD button and export as animated gif!


See also: https://processing.org/tutorials/pixels/

Further ideas:
- interaction with images: changing the effect based on the mouse position (esp transparency for a nice flashlight effect, or maybe focus and blur)
- edge detection -> including slider with threshold value (as many interactive sliders etc as possible
- blur, b/w, etc as a 'tail of the mouse', moving over the image
- screenshot possibility



Also see: https://processing.org/reference/lerpColor_.html


http://processingjs.org/reference/preload/ - preload images so they are fully available when starting manipulation

Doing a modification:
loadPixels() - update the pixels array of the image object
make changes in the pixels[] array
updatePixels() - update the image with the pixel values

// After that, display like normal (so display like normal in draw loop, do modification when buttons etc are pressed)
image(img, 0, 0)

Possible / supported modifications:
http://processingjs.org/reference/PImage_filter_/  - lots of build in possibilities
Also available: mask
- Blend 2 images together - define 'cut with mouse' (then distance from cut line defines how much of 1 image or the other
- Overlay - create live with mouse
- Lots of sliders to manually define influence (HTML sliders or processing library sliders) --> working LIVE, no click needed to activate!

Idea: only image processing, mouse handling etc in processing. Form based stuff in HTML5? - not that hard to create buttons yourself in Processing, did it for TIM already.








*/

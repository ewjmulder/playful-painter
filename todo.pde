/*
TODO / IDEAS:

Other custom mouse pointer when selecting a 'color'

Playful Painter:
- try to integrate some concepts that we learned, like sliders etc, maybe 'play' an image

!!! See also: https://processing.org/tutorials/pixels/ !!!

Always control: size of brush
effect to include / ideas:
- black-white. Controls: threshold to make something black/white
- grayscale? Controls?
- tint. Controls: transparency, red, green, blue
- edge detection. Controls: threshold
- sharpen. Contols: how 'hard'
- blur. Controls: how blurry
- contrast. Controls: increase/decrease scale
- pointillism (https://processing.org/tutorials/pixels/). Controls: how big to make the circles, maybe even shape of the points (circle, square, star)
- pattern overlay. Controls: type over overlay, size of pattern, style of pattern
- distort / noise. Controls: how 'hard'
(maybe google some more stuff, but this is probably enough)

Features: (requires keeping a copy of the original image)
- Reset image option (or reset effect)
- Apply effect to whole image
- Apply effect to original image / current state of image
- Preview effect on whole image! (with live slider update)

Optional sound:
- camera sound when taking a shot
- brush sound when brushing

Bij video maken:
Technisch / voorbereiding
- sketch ongeveer in midden beeld, zodat save popup in beeld komt
- Sketch folder beschikbaar via alt-tab en juist gepositioneerd.
- Geen andere exports in sketch folder laten staan
Inhoudelijk:
- Grappige intro (to the coast ...)
- Kort de buttons langs?
- Show all effects
- Overlay of effects
- Op zo'n manier uitproberen / voorbereiden dat een kunstig resultaat ontstaan. bijv: hoofd met bepaald effect, ogen met ander, etc


UI: home made tabs, buttons, sliders (html5 / http://www.openprocessing.org/sketch/115256 / https://processing.org/examples/scrollbar.html / http://processingjs.org/learning/topic/scrollbar/)
http://processingjs.org/learning/topic/
https://processing.org/reference/blend_.html

Other kind of manipulation category: changes that 'loop' and create a certain behavior / effect

- Coming at you / moving away from you.
- Constant small changes  in pixels to create a sense of motion
- Swirl / draaikolk that suck up the images and at the end 'gives' them back
- 'loop' though color cycle / b/w , etc

Further ideas:
- interaction with images: changing the effect based on the mouse position (esp transparency for a nice flashlight effect, or maybe focus and blur)
- edge detection -> including slider with threshold value (as many interactive sliders etc as possible
- blur, b/w, etc as a 'tail of the mouse', moving over the image

Also see: https://processing.org/reference/lerpColor_.html

http://processingjs.org/reference/preload/ - preload images so they are fully available when starting manipulation

Possible / supported modifications:
http://processingjs.org/reference/PImage_filter_/  - lots of build in possibilities
Also available: mask
- Blend 2 images together - define 'cut with mouse' (then distance from cut line defines how much of 1 image or the other
- Overlay - create live with mouse
- Lots of sliders to manually define influence (HTML sliders or processing library sliders) --> working LIVE, no click needed to activate!



*/

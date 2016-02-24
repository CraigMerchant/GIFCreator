# GIFCreator

Create a GIF in Swift without using lots of memory

```
let frameURL = NSBundle.mainBundle().URLForResource("1", withExtension: "png")
let images = [frameURL]

gifCreator = GIFCreator(imageURLS: images)
gifCreator.createGIF(gifURL)
```

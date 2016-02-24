# GIFCreator

Create a GIF in Swift without using lots of memory

```
let frameURL = NSBundle.mainBundle().URLForResource("1", withExtension: "png")
let imageurls = [frameURL]

gifCreator = GIFCreator(imageURLS: imageurls)
gifCreator.createGIF(gifURL)
```

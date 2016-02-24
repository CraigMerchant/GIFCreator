//
//  GIFCreator.swift
//  GIFCreator
//
//  Created by Craig Merchant on 24/02/2016.
//  Copyright © 2016 Craig Merchant. All rights reserved.
//

import UIKit
import MobileCoreServices
import ImageIO

class GIFCreator: NSObject {
    
    var fps: Double = 10
    var loopCount: Int = 0
    
    // Setting global color map to false will use a lot less memory when finalizing
    var globalColorMap: Bool = false
    
    private var images: [NSURL] = []
    private var imageDestination : CGImageDestinationRef!
    
    init(imageURLs:[NSURL])
    {
        self.images = imageURLs
    }
    
    func createGIF(destinationURL: NSURL) {

        imageDestination = CGImageDestinationCreateWithURL(destinationURL, kUTTypeGIF, Int(images.count), nil)
        CGImageDestinationSetProperties(imageDestination, gifProperties())
        
        for (_, imageURL) in images.enumerate()
        {
            autoreleasepool({
                if let path = imageURL.path {
                    if let img = UIImage(contentsOfFile: path) {
                        if let cg = img.CGImage {
                            let delay = 1 / fps
                            let properties = frameProperties(delay)
                            CGImageDestinationAddImage(imageDestination, cg, properties)
                        }
                    }
                }
            })
        }
        
        CGImageDestinationFinalize(imageDestination)
    }
    
    private func frameProperties(frameDelay:NSTimeInterval) -> CFDictionary
    {
        let dict : CFDictionary = [kCGImagePropertyGIFDelayTime as String :frameDelay]
        return [kCGImagePropertyGIFDictionary as String :dict]
    }
    
    private func gifProperties() -> CFDictionary
    {
        let dict : CFDictionary = [
            kCGImagePropertyGIFLoopCount as String : 0,
            kCGImagePropertyGIFHasGlobalColorMap as String: globalColorMap,
            kCGImagePropertyGIFLoopCount as String: loopCount
        ]
        return [kCGImagePropertyGIFDictionary as String:dict]
    }
}

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
    
    var completionHandler:(()->Void)?
    var progressHandler:((Float)->Void)?
    
    private var images: [NSURL] = []
    private var imageDestination : CGImageDestinationRef!
    
    init(imageURLs:[NSURL])
    {
        self.images = imageURLs
    }
    
    func createGIF(destinationURL: NSURL) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
        
            self.imageDestination = CGImageDestinationCreateWithURL(destinationURL, kUTTypeGIF, Int(self.images.count), nil)
            CGImageDestinationSetProperties(self.imageDestination, self.gifProperties())
            
            for (index, imageURL) in self.images.enumerate()
            {
                autoreleasepool({
                    if let path = imageURL.path {
                        if let img = UIImage(contentsOfFile: path) {
                            if let cg = img.CGImage {
                                let delay = 1 / self.fps
                                let properties = self.frameProperties(delay)
                                CGImageDestinationAddImage(self.imageDestination, cg, properties)
                            }
                        }
                    }
                })
                
                let progress: Float = Float(index+1) / Float(self.images.count)
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.progressHandler?(progress)
                }
            }
            
            CGImageDestinationFinalize(self.imageDestination)
            
            dispatch_async(dispatch_get_main_queue()) {
                self.completionHandler?()
            }
        }
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

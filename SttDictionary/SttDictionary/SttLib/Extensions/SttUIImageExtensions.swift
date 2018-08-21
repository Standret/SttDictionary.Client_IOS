//
//  SttUIImageExtensions.swift
//  SttLib
//
//  Created by Standret on 22.05.18.
//  Copyright © 2018 com.stndret.SttLib All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    func fixOrientation() -> UIImage? {
        
        guard let cgImage = self.cgImage else {
            return nil
        }
        
        if self.imageOrientation == UIImageOrientation.up {
            return self
        }
        
        let width  = self.size.width
        let height = self.size.height
        
        var transform = CGAffineTransform.identity
        
        switch self.imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: width, y: height)
            transform = transform.rotated(by: CGFloat.pi)
            
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: width, y: 0)
            transform = transform.rotated(by: 0.5 * CGFloat.pi)
            
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: height)
            transform = transform.rotated(by: -0.5*CGFloat.pi)
            
        case .up, .upMirrored:
            break
        }
        
        switch self.imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
            
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
            
        default:
            break;
        }
        
        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        guard let colorSpace = cgImage.colorSpace else {
            return nil
        }
        
        guard let context = CGContext(
            data: nil,
            width: Int(width),
            height: Int(height),
            bitsPerComponent: cgImage.bitsPerComponent,
            bytesPerRow: 0,
            space: colorSpace,
            bitmapInfo: UInt32(cgImage.bitmapInfo.rawValue)
            ) else {
                return nil
        }
        
        context.concatenate(transform);
        
        switch self.imageOrientation {
            
        case .left, .leftMirrored, .right, .rightMirrored:
            // Grr...
            context.draw(cgImage, in: CGRect(x: 0, y: 0, width: height, height: width))
            
        default:
            context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        }
        
        // And now we just create a new UIImage from the drawing context
        guard let newCGImg = context.makeImage() else {
            return nil
        }
        
        let img = UIImage(cgImage: newCGImg)        
        return img;
    }
    
    func jpegRepresentation() -> Data? {
        return autoreleasepool(invoking: { [weak self] () -> Data? in
            return UIImageJPEGRepresentation(self!, 0.8)
        })
    }
}

extension Data {
    func fixAdnConvertToImage() -> UIImage {
        return autoreleasepool { () -> UIImage in
            return UIImage(data: UIImagePNGRepresentation(UIImage(data: self)!)!)!.fixOrientation()!
        }
    }
}

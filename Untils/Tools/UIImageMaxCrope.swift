//
//  UIImageMaxCrope.swift
//  Touqiu
//
//  Created by Zhang on 2019/6/26.
//  Copyright © 2019 com.touqiu.touqiu. All rights reserved.
//

import UIKit

class UIImageMaxCroped: NSObject {
    class func cropeImage(image:UIImage, imageViewSize:CGSize) ->UIImage{
        let imageScral = String(format:"%.2f",image.size.width/image.size.height)
        let imageViewScral = String(format:"%.2f",imageViewSize.width/imageViewSize.height)
        if imageScral > imageViewScral {
            let cgrect = CGRect.init(x: (image.size.width - (image.size.height - 20) * imageViewSize.width / imageViewSize.height) / 2, y: 0, width: (image.size.height - 20) * imageViewSize.width / imageViewSize.height, height: (image.size.height - 20) * imageViewSize.width / imageViewSize.height / imageViewScral.cgFloat()!)
            
            return image.fixOrientation().cropped(to: cgrect)
        }else if imageViewScral ==  imageScral {
            return image
        }else{
            let cgrect = CGRect.init(x: 10, y: (image.size.height - (image.size.width - 20) * imageViewSize.height / imageViewSize.width) / 2, width: (image.size.width - 20), height: (image.size.width - 20) * imageViewSize.height / imageViewSize.width)
            return image.fixOrientation().cropped(to: cgrect)
        }
    }
    
    class func cropeImageWidth(image:UIImage, width:CGFloat){
//        let cgrect = CGRect.init(x: <#T##CGFloat#>, y: <#T##CGFloat#>, width: <#T##CGFloat#>, height: <#T##CGFloat#>)
    }
}


import UIKit

extension UIImage {
    // 修复图片旋转
    func fixOrientation() -> UIImage {
        if self.imageOrientation == .up {
            return self
        }
        
        var transform = CGAffineTransform.identity
        
        switch self.imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: self.size.height)
            transform = transform.rotated(by: .pi)
            break
            
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.rotated(by: .pi / 2)
            break
            
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: self.size.height)
            transform = transform.rotated(by: -.pi / 2)
            break
            
        default:
            break
        }
        
        switch self.imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
            break
            
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: self.size.height, y: 0);
            transform = transform.scaledBy(x: -1, y: 1)
            break
            
        default:
            break
        }
        
        let ctx = CGContext(data: nil, width: Int(self.size.width), height: Int(self.size.height), bitsPerComponent: self.cgImage!.bitsPerComponent, bytesPerRow: 0, space: self.cgImage!.colorSpace!, bitmapInfo: self.cgImage!.bitmapInfo.rawValue)
        ctx?.concatenate(transform)
        
        switch self.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx?.draw(self.cgImage!, in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(size.height), height: CGFloat(size.width)))
            break
            
        default:
            ctx?.draw(self.cgImage!, in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(size.width), height: CGFloat(size.height)))
            break
        }
        
        let cgimg: CGImage = (ctx?.makeImage())!
        let img = UIImage(cgImage: cgimg)
        
        return img
    }
}

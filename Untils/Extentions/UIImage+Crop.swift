//
//  UIImage+Crop.swift
//  Meet
//
//  Created by Zhang on 9/13/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import Foundation
import UIKit
import Accelerate
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

extension UIImage {
    
    ///对指定图片进行拉伸
    func resizableImage(_ name: String) -> UIImage {
        
        var normal = UIImage(named: name)!
        let imageWidth = normal.size.width * 0.5
        let imageHeight = normal.size.height * 0.5
        normal = self.resizableImage(withCapInsets: UIEdgeInsets(top: imageHeight, left: imageWidth, bottom: imageHeight, right: imageWidth))
        
        return normal
    }
    
    /**
     *  压缩上传图片到指定字节
     *
     *  image     压缩的图片
     *  maxLength 压缩后最大字节大小
     *
     *  return 压缩后图片的二进制
     */
//    func compressImage(_ image: UIImage, maxLength: Int) -> Data? {
//        
//        let newSize = self.scaleImage(image, imageLength: 300)
//        let newImage = self.resizeImage(image, newSize: newSize)
//        
//        var compress:CGFloat = 0.9
//        var data = UIImage.compressedData(image)
//                    
//        while data?.count > maxLength && compress > 0.01 {
//            compress -= 0.02
//            data = UIImageJPEGRepresentation(newImage, compress)
//        }
//        
//        return data
//    }
    
    /**
     *  通过指定图片最长边，获得等比例的图片size
     *
     *  image       原始图片
     *  imageLength 图片允许的最长宽度（高度）
     *
     *  return 获得等比例的size
     */
    func  scaleImage(_ image: UIImage, imageLength: CGFloat) -> CGSize {
        
        var newWidth:CGFloat = 0.0
        var newHeight:CGFloat = 0.0
        let width = image.size.width
        let height = image.size.height
        
        if (width > imageLength || height > imageLength){
            
            if (width > height) {
                
                newWidth = imageLength;
                newHeight = newWidth * height / width;
                
            }else if(height > width){
                
                newHeight = imageLength;
                newWidth = newHeight * width / height;
                
            }else{
                
                newWidth = imageLength;
                newHeight = imageLength;
            }
            
        }
        return CGSize(width: newWidth, height: newHeight)
    }
    
    /**
     *  获得指定size的图片
     *
     *  image   原始图片
     *  newSize 指定的size
     *
     *  return 调整后的图片
     */
    func resizeImage(_ image: UIImage, newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(newSize)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}

extension UIImage {
    /// 高斯模糊
    func gaussianBlur( blurAmount:CGFloat) -> UIImage {
        //高斯模糊参数(0-1)之间，超出范围强行转成0.5
        var blurAmount = blurAmount
        if (blurAmount < 0.0 || blurAmount > 1.0) {
            blurAmount = 0.5
        }
        
        var boxSize = Int(blurAmount * 40)
        boxSize = boxSize - (boxSize % 2) + 1
        
        let img = self.cgImage
        
        var inBuffer = vImage_Buffer()
        var outBuffer = vImage_Buffer()
        
        let inProvider =  img!.dataProvider
        let inBitmapData =  inProvider?.data
        
        inBuffer.width =  UInt(img!.width)
        inBuffer.height = UInt(img!.height)
        inBuffer.rowBytes = img!.bytesPerRow
        inBuffer.data = UnsafeMutableRawPointer(mutating: CFDataGetBytePtr(inBitmapData))
        
        //手动申请内存
        let pixelBuffer = malloc(img!.bytesPerRow * img!.height)
        
        outBuffer.width = vImagePixelCount(img!.width)
        outBuffer.height = vImagePixelCount(img!.height)
        outBuffer.rowBytes = img!.bytesPerRow
        outBuffer.data = pixelBuffer
        
        var error = vImageBoxConvolve_ARGB8888(&inBuffer,
                                               &outBuffer, nil, vImagePixelCount(0), vImagePixelCount(0),
                                               UInt32(boxSize), UInt32(boxSize), nil, vImage_Flags(kvImageEdgeExtend))
        if (kvImageNoError != error)
        {
            error = vImageBoxConvolve_ARGB8888(&inBuffer,
                                               &outBuffer, nil, vImagePixelCount(0), vImagePixelCount(0),
                                               UInt32(boxSize), UInt32(boxSize), nil, vImage_Flags(kvImageEdgeExtend))
            if (kvImageNoError != error)
            {
                error = vImageBoxConvolve_ARGB8888(&inBuffer,
                                                   &outBuffer, nil, vImagePixelCount(0), vImagePixelCount(0),
                                                   UInt32(boxSize), UInt32(boxSize), nil, vImage_Flags(kvImageEdgeExtend))
            }
        }
        
        let colorSpace =  CGColorSpaceCreateDeviceRGB()
        let ctx = CGContext(data: outBuffer.data,
                            width: Int(outBuffer.width),
                            height: Int(outBuffer.height),
                            bitsPerComponent: 8,
                            bytesPerRow: outBuffer.rowBytes,
                            space: colorSpace,
                            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
        
        let imageRef = ctx!.makeImage()
        
        //手动申请内存
        free(pixelBuffer)
        return UIImage.init(cgImage: imageRef!)
    }
}


extension UIImage {
   
    /// 通过图片url获取图片尺寸
    ///
    /// - Parameter url: 图片路径
    /// - Returns: 返回图片尺寸，有可能为zero
    class func getImageSizeWithURL(url:String?) -> CGSize {
        var imageSize:CGSize = .zero
        guard let imageUrlStr = url else { return imageSize }
        guard imageUrlStr != "" else {return imageSize}
        guard let imageUrl = URL(string: imageUrlStr) else { return imageSize }

        guard let imageSourceRef = CGImageSourceCreateWithURL(imageUrl as CFURL, nil) else {return imageSize}
        guard let imagePropertie = CGImageSourceCopyPropertiesAtIndex(imageSourceRef, 0, nil)  as? Dictionary<String,Any> else {return imageSize }
        imageSize.width = CGFloat((imagePropertie[kCGImagePropertyPixelWidth as String] as! NSNumber).floatValue)
        imageSize.height = CGFloat((imagePropertie[kCGImagePropertyPixelHeight as String] as! NSNumber).floatValue)
        return imageSize
    }
}



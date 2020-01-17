//
//  UIImageViewManger.swift
//  CatchMe
//
//  Created by Zhang on 19/11/2017.
//  Copyright © 2017 Zhang. All rights reserved.
//

import UIKit
import SDWebImage
import YYWebImage

typealias DownLoadImageCompletionBlock = (_ image:UIImage?, _ error:Error?, _ url:URL) -> Void
typealias ImageDownLoadImageCompletionBlock = (_ image:UIImage?, _ data:Data?,  _ error:Error?, _ ret:Bool) ->Void

let ImageRootURL = "https://\(OSS_BUCKET_PUBLIC).\(OSS_ENDPOINT)"


let normalImage = UIImage.init(named: "placeholder")

//func getholderImage(size:CGSize) ->UIImage{
//    UIImageViewManger.sd_downImage(url: "", placeholderImage: nil) { (image, data, error, ret) in
//        return image
//    }
//    return normalImage!
//}


class UIImageViewManger: NSObject {

    
    private static let _sharedInstance = UIImageViewManger()
    
    class func getSharedInstance() -> UIImageViewManger {
        return _sharedInstance
    }
    
    private override init() {} // 私有化init方法
    
    func appendImageUrl(url:String) ->String{
        return "\(ImageRootURL)\(url)"
    }
    
    func downloadImage(url:String, completedBlock:SDWebImage.SDWebImageDownloaderCompletedBlock? = nil){
        SDWebImageDownloader.shared.downloadImage(with: URL.init(string: url.contains("http") ? url : UIImageViewManger.getSharedInstance().appendImageUrl(url: url)), options: [.continueInBackground, .highPriority], progress: { (start, end, url) in
            
        }) { (image, data, error, ret) in
            if error == nil {
                SDImageCache.shared.store(image, imageData: data, forKey: url.contains("http") ? url : UIImageViewManger.getSharedInstance().appendImageUrl(url: url), toDisk: true, completion: {
                    
                })
                completedBlock!(image,data,error,ret)
            }
        }
    }
    
}

extension UIImageView {
    
    func sd_crope_imageView(url:String, imageView:UIImageView, placeholderImage:UIImage?, completedBlock:YYWebImageCompletionBlock?){
        let size = imageView.size
        var temp_placholderImage = placeholderImage
        //展位图缓存
        if temp_placholderImage == nil || size.width == 0 {
            var placholderImage = CacheManager.getSharedInstance().getPlacholderImage()
            if placholderImage == nil || placholderImage!.object(forKey: "\(size.width.int)\(size.height.int)") == nil {
                temp_placholderImage = normalImage!.yy_imageByResize(to: size, contentMode: UIView.ContentMode.scaleAspectFill)
                if placholderImage == nil {
                    placholderImage = NSMutableDictionary.init(dictionary: ["\(size.width.int)\(size.height.int)":temp_placholderImage as Any])
                }else{
                    placholderImage?.setValue(temp_placholderImage, forKey: "\(size.width.int)\(size.height.int)")
                }
                CacheManager.getSharedInstance().savePlacholderImage(point: placholderImage!)
            }else{
                if placholderImage?.object(forKey: "\(size.width.int)\(size.height.int)") is UIImage {
                    temp_placholderImage = (placholderImage?.object(forKey: "\(size.width.int)\(size.height.int)") as! UIImage)
                }
            }
        }
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            self.yy_setImage(with: URL.init(string:url.contains("http") ? url : UIImageViewManger.getSharedInstance().appendImageUrl(url: url)), placeholder:temp_placholderImage, options: [.setImageWithFadeAnimation, .progressiveBlur, .showNetworkActivity,.allowBackgroundTask], manager: nil, progress: { (start, end) in
                
            }, transform: { (image, url) -> UIImage? in
                return image.yy_imageByResize(to: size, contentMode: UIView.ContentMode.scaleAspectFill)
            }) { (image, url, type, state, error) in
                completedBlock!(image, url, type, state, error)
            }
        }
    }
    
    func sd_crope_imageView_withMaxWidth(url:String, imageSize:CGSize?, placeholderImage:UIImage?, completedBlock:SDExternalCompletionBlock?) {
        
        var temp_placholderImage = placeholderImage
        if temp_placholderImage == nil {
            if imageSize == nil {
                temp_placholderImage = normalImage
            }else{
                var placholderImage = CacheManager.getSharedInstance().getPlacholderImage()
                if placholderImage == nil || placholderImage!.object(forKey: "\(size.width.int)\(size.height.int)") == nil {
                    temp_placholderImage = normalImage!.yy_imageByResize(to: size, contentMode: UIView.ContentMode.scaleAspectFill)
                    if placholderImage == nil {
                        placholderImage = NSMutableDictionary.init(dictionary: ["\(size.width.int)\(size.height.int)":temp_placholderImage as Any])
                    }else{
                        placholderImage?.setValue(temp_placholderImage, forKey: "\(size.width.int)\(size.height.int)")
                    }
                    CacheManager.getSharedInstance().savePlacholderImage(point: placholderImage!)
                }else{
                    if placholderImage?.object(forKey: "\(size.width.int)\(size.height.int)") is UIImage {
                        temp_placholderImage = (placholderImage?.object(forKey: "\(size.width.int)\(size.height.int)") as! UIImage)
                    }else{
                        temp_placholderImage = normalImage
                    }
                    
                }
            }
        }
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            self.sd_setImage(with:  URL.init(string: url.contains("http") ? url : UIImageViewManger.getSharedInstance().appendImageUrl(url: url)), placeholderImage: temp_placholderImage, options: [.retryFailed, .avoidAutoSetImage, .highPriority]) { (image, error, cacheType, url) in
                completedBlock!(image,error,cacheType,url)
            }
        }
    }
    
    func sd_downImageTools(url:String, imageSize:CGSize?, placeholderImage:UIImage?, completedBlock: SDWebImage.SDWebImageDownloaderCompletedBlock? = nil) {
        
        var temp_placholderImage = placeholderImage
        if temp_placholderImage == nil {
            if imageSize == nil {
                temp_placholderImage = normalImage
            }else{
                var placholderImage = CacheManager.getSharedInstance().getPlacholderImage()
                if placholderImage == nil || placholderImage!.object(forKey: "\(size.width.int)\(size.height.int)") == nil {
                    temp_placholderImage = normalImage!.yy_imageByResize(to: size, contentMode: UIView.ContentMode.scaleAspectFill)
                    if placholderImage == nil {
                        placholderImage = NSMutableDictionary.init(dictionary: ["\(size.width.int)\(size.height.int)":temp_placholderImage as Any])
                    }else{
                        placholderImage?.setValue(temp_placholderImage, forKey: "\(size.width.int)\(size.height.int)")
                    }
                    CacheManager.getSharedInstance().savePlacholderImage(point: placholderImage!)
                }else{
                    temp_placholderImage = (placholderImage?.object(forKey: "\(size.width.int)\(size.height.int)") as! UIImage)
                }
            }
        }
        
        let cacheImage = SDImageCache.shared.imageFromDiskCache(forKey: url.contains("http") ? url : UIImageViewManger.getSharedInstance().appendImageUrl(url: url))
        if cacheImage != nil {
            completedBlock!(cacheImage,cacheImage?.jpegData(compressionQuality: 1), nil, true)
            return
        }
        
        SDWebImageDownloader.shared.downloadImage(with: URL.init(string: url.contains("http") ? url : UIImageViewManger.getSharedInstance().appendImageUrl(url: url)), options: [.continueInBackground, .highPriority], progress: { (start, end, url) in
            
        }) { (image, data, error, ret) in
            if error == nil {
                SDImageCache.shared.store(image, imageData: data, forKey: url.contains("http") ? url : UIImageViewManger.getSharedInstance().appendImageUrl(url: url), toDisk: true, completion: {
                    
                })
                completedBlock!(image,data,error,ret)
            }
        }
    }
    
    func sd_without_crope_image(url:String, completedBlock:SDExternalCompletionBlock?){
        self.sd_setImage(with:  URL.init(string: url.contains("http") ? url : UIImageViewManger.getSharedInstance().appendImageUrl(url: url)), placeholderImage: nil, options: [.retryFailed]) { (image, error, cacheType, url) in
            completedBlock!(image,error,cacheType,url)
        }
    }
}

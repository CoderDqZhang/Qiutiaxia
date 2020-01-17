//
//  BaseNetWorke.swift
//  LiangPiao
//
//  Created by Zhang on 28/10/2016.
//  Copyright © 2016 Zhang. All rights reserved.
//

import UIKit
import Alamofire
import ReactiveSwift
import MBProgressHUD

typealias SuccessClouse = (_ responseObject:AnyObject) -> Void
typealias FailureClouse = (_ responseError:AnyObject) -> Void

enum HttpRequestType {
    case post
    case get
    case delete
    case put
}

class BaseNetWorke : SessionManager {
    
    private static let _sharedInstance = BaseNetWorke()
    var sessionManager:SessionManager!
    class func getSharedInstance() -> BaseNetWorke {
        return _sharedInstance
    }
    
    private init() {
        super.init()
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        sessionManager = Alamofire.SessionManager.init(configuration: configuration, delegate: self.delegate, serverTrustPolicyManager: nil)
    } // 私有化init方法
    //加一个特使标识，首页请求失败
    /// getRequest
    /// - parameter url:        输入URL
    /// - parameter parameters: 参数
    ///
    /// - returns: 一个信号

    func getUrlWithString(_ url:String, parameters:AnyObject?) -> Signal<Any, NSError> {
        return Signal.init({ (subscriber, liftTime) in
            self.httpRequest(.get, url: url, parameters: parameters, success: { (responseObject) in
                ErrorCodeTools.getSharedInstance().errorCode(responseObject: (responseObject as! NSDictionary), fail: { (failer) in
                    
                }, sucess: { (dic) in
                    subscriber.send(value: dic)
                })
                subscriber.sendCompleted()
            }, failure: { (responseError) in
                if responseError is NSDictionary {
                    MainThreanShowErrorMessage(responseError)
                }else{
                    MainThreanShowNetWorkError(responseError)
                    subscriber.sendCompleted()
                }
                subscriber.sendCompleted()
            })
        })
    }
    /// postRequest
    /// - parameter url:        输入URL
    /// - parameter parameters: 参数
    ///
    /// - returns: 一个信号
    func postUrlWithString(_ url:String, parameters:AnyObject?) -> Signal<Any, NSError> {
        return Signal.init({ (subscriber, liftTime) in
            self.httpRequest(.post, url: url, parameters: parameters, success: { (responseObject) in
                ErrorCodeTools.getSharedInstance().errorCode(responseObject: (responseObject as! NSDictionary), fail: { (failer) in
                    
                }, sucess: { (dic) in
                    subscriber.send(value: dic)
                })
                subscriber.sendCompleted()
                }, failure: { (responseError) in
                    if responseError is NSDictionary {
                        MainThreanShowErrorMessage(responseError)
                    }else{
                        print(responseError)
                        MainThreanShowNetWorkError(responseError)
//                        subscriber.send(error: responseError as! NSError)
                    }
                subscriber.sendCompleted()
            })
        })
        
    }
    
    /// Putrequest
    /// - parameter url:        输入URL
    /// - parameter parameters: 参数
    ///
    /// - returns: 一个信号
    func putUrlWithString(_ url:String, parameters:AnyObject?) -> Signal<Any, NSError> {
        return Signal.init({ (subscriber, liftTime) in
            self.httpRequest(.put, url: url, parameters: parameters, success: { (responseObject) in
                ErrorCodeTools.getSharedInstance().errorCode(responseObject: (responseObject as! NSDictionary), fail: { (failer) in
                    
                }, sucess: { (dic) in
                    subscriber.send(value: dic)
                })
                subscriber.sendCompleted()
                }, failure: { (responseError) in
                    if responseError is NSDictionary {
                        MainThreanShowErrorMessage(responseError)
                    }else{
                        MainThreanShowNetWorkError(responseError)
                    }
                subscriber.sendCompleted()
            })
        })
    }
    
    /// 删除request
    ///
    /// - parameter url:        输入URL
    /// - parameter parameters: 参数
    ///
    /// - returns: 一个信号
    func deleteUrlWithString(_ url:String, parameters:AnyObject?) -> Signal<Any, NSError> {
        return Signal.init({ (subscriber, liftTime) in
            self.httpRequest(.delete, url: url, parameters: parameters, success: { (responseObject) in
                ErrorCodeTools.getSharedInstance().errorCode(responseObject: (responseObject as! NSDictionary), fail: { (failer) in
                    
                }, sucess: { (dic) in
                    subscriber.send(value: dic)
                })
                subscriber.sendCompleted()
                }, failure: { (responseError) in
                    if responseError is NSDictionary {
                        MainThreanShowErrorMessage(responseError)
                    }else{
                        MainThreanShowNetWorkError(responseError)
                    }
                subscriber.sendCompleted()
            })
        })
    }
    
    
    func uploadDataFile(_ url:String, parameters:NSDictionary?, images:NSDictionary?, hud:MBProgressHUD?) ->Signal<Any, NSError> {
        return Signal.init({ (subscriber, liftTime) in
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                if parameters != nil {
                    for i in 0...(parameters!).allValues.count - 1 {
                        multipartFormData.append((parameters!.allValues[i] as! String).data(using: String.Encoding.utf8, allowLossyConversion: true)!, withName: parameters!.allKeys[i] as! String)
                    }
                }
                
                if images != nil {
                    for j in 0...(images!).allValues.count - 1 {
                        multipartFormData.append(URL.init(fileURLWithPath: images?.allValues[j] as! String), withName: "file")
                    }
                }
                
            }, usingThreshold: 1, to: url, method: .post, headers: [
                "content-type": "multipart/form-data",
                "cache-control": "no-cache"
            ]) { (encodingResult) in
                print(encodingResult)
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseString(completionHandler: { (response) in
                        if response.response?.statusCode == 200 || response.response?.statusCode == 201 {
                            subscriber.send(value: response.result.value ?? "")
                        }else{
                            _ = Tools.shareInstance.showMessage(KWindow, msg: "上传失败", autoHidder: true)
                        }
                        if hud != nil {
                            Tools.shareInstance.hiddenLoading(hud: hud!)
                        }
                        subscriber.sendCompleted()
                    })
                case .failure(let encodingError):
                    print(encodingError)
                    if hud != nil {
                        Tools.shareInstance.hiddenLoading(hud: hud!)
                    }
                    _ = Tools.shareInstance.showMessage(KWindow, msg: "上传失败", autoHidder: true)
                    subscriber.sendCompleted()
                }
            }
        })
    }
    
    ///
    /// - parameter url:        输入URL
    /// - parameter parameters: 参数
    ///
    /// - returns: 一个信号
    func httpRequest(_ type:HttpRequestType,url:String, parameters:AnyObject?, success:@escaping SuccessClouse, failure:@escaping FailureClouse) {
        
        var methods:HTTPMethod
        switch type {
            case .post:
                methods = HTTPMethod.post
            case .get:
                methods = HTTPMethod.get
            case .delete:
                methods = HTTPMethod.delete
            default:
                methods = HTTPMethod.put
        }
//        let headers:HTTPHeaders?
//        if CacheManager.getSharedInstance().isLogin() {
//            headers =
//        }else{
//            headers = []
//        }
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        
        sessionManager.request(url, method: methods , parameters: parameters as? [String: Any], encoding: URLEncoding.default, headers: (self.header() )).responseJSON { (response) in
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            if response.result.error != nil{
                failure(response.result.error! as AnyObject)
            }else{
                if response.response?.statusCode == 200 || response.response?.statusCode == 201 {
                    success(response.value as! NSDictionary)
                }else{
                    failure(["message":(response.result.value! as! NSDictionary).object(forKey: "error")] as AnyObject)
                }
            }
        }
    }
    
    
    ///TransGoogle
    
    func googleTrans(url:String, parameters: AnyObject?, success:@escaping SuccessClouse, failure:@escaping FailureClouse){
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        
        Alamofire.request(url, method: .get , parameters: parameters as? [String: Any], encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            if response.result.error != nil{
                failure(response.result.error! as AnyObject)
            }else{
                if response.response?.statusCode == 200 || response.response?.statusCode == 201 {
                    success(response.value as! NSDictionary)
                }else{
                    failure(["message":(response.result.value! as! NSDictionary).object(forKey: "error")] as AnyObject)
                }
            }
        }
    }
    
    ///AliPayBankName
    
    func aliPayBankName(url:String, success:@escaping SuccessClouse, failure:@escaping FailureClouse){
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        Alamofire.request(url, method: .get , parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            if response.result.error != nil{
                failure(response.result.error! as AnyObject)
            }else{
                if response.response?.statusCode == 200 || response.response?.statusCode == 201 {
                    success(response.value as! NSDictionary)
                }else{
                    failure(["message":(response.result.value! as! NSDictionary).object(forKey: "error")] as AnyObject)
                }
            }
        }
    }
    
    func sportnanoApi(url:String, parameters: AnyObject?, success:@escaping SuccessClouse, failure:@escaping FailureClouse){
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        
        Alamofire.request(url, method: .get , parameters: parameters as? [String: Any], encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            if response.result.error != nil{
                failure(response.result.error! as AnyObject)
            }else{
                if response.response?.statusCode == 200 || response.response?.statusCode == 201 {
                    success(response.value as AnyObject)
                }else{
                    failure(["message":(response.result.value! as! NSDictionary).object(forKey: "error")] as AnyObject)
                }
            }
        }
    }
    
    func jsonStringToDic(_ dictionary_temp:String) ->NSDictionary {
        let data = dictionary_temp.data(using: String.Encoding.utf8)! as NSData
        let dictionary_temp_temp = try? JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions.mutableContainers)
        return dictionary_temp_temp as! NSDictionary
        
    }
    
    func dataToDic(_ dictionary_temp:Data) ->NSDictionary{
        let dictionary_temp_temp = try? JSONSerialization.jsonObject(with: dictionary_temp as Data, options: JSONSerialization.ReadingOptions.mutableContainers)
        if  dictionary_temp_temp is NSDictionary{
            return dictionary_temp_temp as! NSDictionary
        }
        return NSDictionary.init()
    }
    
    func header() ->HTTPHeaders{
        let app_v = versionCheck()
        let now = Date()
        let timeInterval:TimeInterval = now.timeIntervalSince1970
        let time = Int(timeInterval)
        let imei = UIDevice.current.identifierForVendor
        let os_v = UIDevice.current.systemVersion //iOS版本
        let str = "api_v=\(app_v)&imei=\(String(describing: imei!))&os=ios&os_v=\(os_v)&time=\(time)"
        let lock = NSString.aes128Encrypt(str, key:AESKey)
        let headers:HTTPHeaders?
        headers = (["sign":lock,"token":UserDefaults.init().object(forKey: CACHEMANAUSERTOKEN) ?? "","api_v":"\(app_v)","time":"\(time)", "imei": "\(String(describing: imei!))","os":"ios","os_v":"\(os_v)"] as! HTTPHeaders)
        return headers!
    }
}


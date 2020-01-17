//
//  Tools.swift
//  LiangPiao
//
//  Created by Zhang on 23/11/2016.
//  Copyright © 2016 Zhang. All rights reserved.
//

import UIKit
import MBProgressHUD
import YYImage

let HUDBackGroudColor = "000000"
let CustomViewWidth:CGFloat = 190
let CustomViewFont:UIFont = (IPHONE_VERSION > 9 ? UIFont.init(name: ".SFUIText-Medium", size: 17.0):UIFont.init(name: ".HelveticaNeueInterface-Bold", size: 17.0))!
let TextLabelMarger:CGFloat = 20

class HUDCustomView: UIView {
    class func customViewWidthMessage(_ message:String) -> AnyObject {
        let customView =  UIView(frame: CGRect.init(x: CGFloat(UIScreen.main.bounds.size.width - CustomViewWidth) / 2, y: (UIScreen.main.bounds.size.height - 60) / 2, width: CustomViewWidth, height: 54))
        let size: CGSize = message.size(withAttributes: [NSAttributedString.Key.font: CustomViewFont])
//        let messageHeight = message.nsString.height(with: CustomViewFont!, constrainedToWidth: CustomViewWidth - TextLabelMarger * 2)
        let messageHeight:CGFloat = size.height
        var frame = customView.frame
        if messageHeight > 54 {
            frame.size.height = messageHeight
            frame.origin.y = (UIScreen.main.bounds.size.height - messageHeight) / 2
        }else{
            frame.size.height = 54;
        }
        customView.frame = frame;
        customView.frame = CGRect.init(x: 0, y: 0, width: 270, height: SCREENHEIGHT)
        customView.addSubview(HUDCustomView.setUpLabel(frame, text: message))
        return customView;
    }
    
    class func setUpLabel(_ frame:CGRect, text:String) -> YYLabel{
        let textLabel = YYLabel(frame: CGRect.init(x: 0, y: 0, width: CustomViewWidth - TextLabelMarger * 2, height: frame.size.height))
        textLabel.font = CustomViewFont
        textLabel.numberOfLines = 0
        textLabel.textColor = UIColor.white
        textLabel.text = text
        textLabel.textAlignment = .center
        return textLabel;
        
    }
    
    class func getHudMinSize(_ msg:String) ->CGSize {
        let size: CGSize = msg.size(withAttributes: [NSAttributedString.Key.font: CustomViewFont])
        let minWidth:CGFloat = size.width + 67
        let minHeigth:CGFloat = size.height + 33
//        let minWidth = msg.nsString.width(with: CustomViewFont!, constrainedToHeight: 14) + 67
//        let minHeigth = (msg as NSString).height(with: CustomViewFont!, constrainedToWidth: minWidth) + 33
        return CGSize(width: minWidth, height: minHeigth)
    }
}

class Tools: NSObject {

    
    override init() {
        
    }
    
    static let shareInstance = Tools()
    
    func showLoading(_ view:UIView, msg:String?) -> MBProgressHUD {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = .indeterminate
        hud.bezelView.color = UIColor.init(hexString: HUDBackGroudColor, transparency: 0.6)!
        hud.bezelView.layer.cornerRadius = 10.0
        if msg != nil {
            hud.label.text = msg
            hud.label.numberOfLines = 0;
            hud.label.textColor = UIColor.white
            hud.label.font = CustomViewFont;
        }
        return hud
    }
    
    func showLoading(_ view:UIView) ->MBProgressHUD {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        let imageView = YYAnimatedImageView.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 50))
        imageView.image = YYImage.init(named: "loading.gif")
//        imageView.backgroundColor = .red
        hud.mode = .customView
        hud.bezelView.style = .solidColor
        hud.bezelView.color = .clear
        hud.backgroundView.color = .clear
        hud.customView = imageView
        hud.animationType = .fade
        hud.removeFromSuperViewOnHide = true
        hud.alpha = 1
        return hud
    }
    
    func hiddenLoading(hud:MBProgressHUD) {
        hud.hide(animated: true)
    }
    
    func showMessage(_ view:UIView, msg:String, autoHidder:Bool) -> MBProgressHUD {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = .customView
        hud.bezelView.backgroundColor = UIColor.init(hexString: HUDBackGroudColor, transparency: 0.6)
        hud.bezelView.layer.cornerRadius = 10.0
        hud.label.numberOfLines = 0;
        hud.label.textColor = UIColor.white
        hud.label.font = CustomViewFont;
        hud.minSize = HUDCustomView.getHudMinSize(msg)
        hud.label.text = msg;
        hud.bezelView.layer.frame = CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: SCREENHEIGHT)
        if autoHidder {
            hud.hide(animated: true, afterDelay: 2.0)
        }
        hud.removeFromSuperViewOnHide = true
        hud.margin = 10
        hud.isUserInteractionEnabled = false
        
        return hud
    }
    
    func showErrorMessage(_ errorDic:AnyObject) ->MBProgressHUD? {
        if (errorDic is NSDictionary) {
            if (errorDic as! NSDictionary).object(forKey: "message") != nil {
                return  self.showMessage(KWindow, msg: (errorDic as! NSDictionary).object(forKey: "message") as? String ?? "出现错误", autoHidder: true)
            }else{
                return self.showMessage(KWindow, msg:"网络服务错误" , autoHidder: true)
            }
        }else{
            return self.showMessage(KWindow, msg:"网络服务错误" , autoHidder: true)
        }
    }
    
    func showNetWorkError(_ error:AnyObject) ->MBProgressHUD {
        let netWorkError = (error as! NSError)
        print(netWorkError)
        return self.showMessage(KWindow, msg:netWorkError.localizedDescription , autoHidder: true)
    }
    
    func showAliPathError(_ error:String) ->MBProgressHUD {
        return self.showMessage(KWindow, msg: error, autoHidder: true)
    }
    
   
}

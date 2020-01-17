//
//  RealNameTools.swift
//  Touqiu
//
//  Created by Zhang on 2019/10/12.
//  Copyright © 2019 com.touqiu.touqiu. All rights reserved.
//

import UIKit

class RealNameTools: NSObject {

    private static let _sharedInstance = RealNameTools()
    
    class func getSharedInstance() -> RealNameTools {
        return _sharedInstance
    }
    
    private override init() {} // 私有化init方法
    
    func setRealNameCheck(controller:BaseViewController) ->Bool {
        let userInfo = CacheManager.getSharedInstance().getUserInfo()
        if userInfo?.isMember == "0" {
            UIAlertController.showAlertControl(controller, style: .alert, title: "提示", message: "《互联网跟帖评论服务管理规定》，明确注册用户需“后台实名”，否则不得跟帖评论、发布信息，您尚未实名认证，请完成实名认证后发帖讨论", cancel: "取消", doneTitle: "确定", cancelAction: {
                
            }, doneAction: {
                NavigationPushView(controller, toConroller: RealNameViewController())
            })
            return false
        }
        return true
    }
}

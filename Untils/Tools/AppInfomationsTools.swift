//
//  AppInfomationsTools.swift
//  Touqiu
//
//  Created by Zhang on 2019/7/18.
//  Copyright © 2019 com.touqiu.touqiu. All rights reserved.
//

import UIKit

class AppInfomationsTools: NSObject {

    private static let _sharedInstance = AppInfomationsTools()
    
    class func getSharedInstance() -> AppInfomationsTools {
        return _sharedInstance
    }
    
    private override init() {} // 私有化init方法
}

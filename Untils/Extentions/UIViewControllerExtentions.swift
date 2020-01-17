//
//  UIViewControllerExtentions.swift
//  Touqiu
//
//  Created by Zhang on 2019/6/27.
//  Copyright © 2019 com.touqiu.touqiu. All rights reserved.
//

import UIKit

extension UIViewController {
    
    class func current(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return current(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            return current(base: tab.selectedViewController)
        }
        if let presented = base?.presentedViewController {
            return current(base: presented)
        }
        return base
    }
}

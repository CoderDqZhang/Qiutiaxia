
//
//  UINavigationController.swift
//  Touqiu
//
//  Created by Zhang on 2019/10/8.
//  Copyright © 2019 com.touqiu.touqiu. All rights reserved.
//

extension UINavigationController {

    open override var childForStatusBarStyle: UIViewController? {
        return viewControllers.last
    }
}

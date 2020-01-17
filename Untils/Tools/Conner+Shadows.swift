//
//  Conner+Shadows.swift
//  Touqiu
//
//  Created by Zhang on 2019/5/9.
//  Copyright © 2019 com.touqiu.touqiu. All rights reserved.
//

import UIKit

func setMutiBorderRoundingCorners(_ view:AnyObject,corner:CGFloat,byRoundingCorners:UIRectCorner){
    
    let maskPath = UIBezierPath.init(roundedRect: view.bounds,
                                     byRoundingCorners: byRoundingCorners,
                                     cornerRadii: CGSize(width: corner, height: corner))
    let maskLayer = CAShapeLayer()
    maskLayer.frame = view.bounds
    maskLayer.path = maskPath.cgPath
    (view as! UIView).layer.mask = maskLayer
}

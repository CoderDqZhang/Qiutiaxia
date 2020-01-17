//
//  UITextFieldExtentions.swift
//  Touqiu
//
//  Created by Zhang on 2019/5/13.
//  Copyright © 2019 com.touqiu.touqiu. All rights reserved.
//

import Foundation
extension UITextField{
    
    //MARK:-设置暂位文字的颜色
    func setPlaceholder(str:String, font:UIFont, textColor:UIColor) {
        let attributed = NSAttributedString.init(string: str, attributes: [NSAttributedString.Key.font : font,NSAttributedString.Key.foregroundColor:textColor])
        self.attributedPlaceholder = attributed
    }
}


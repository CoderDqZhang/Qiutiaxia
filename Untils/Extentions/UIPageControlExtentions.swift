//
//  UIPageControlExtentions.swift
//  CatchMe
//
//  Created by Zhang on 27/12/2017.
//  Copyright © 2017 Zhang. All rights reserved.
//

import Foundation
import UIKit

extension UIPageControl {
    func setCurrentControl(image:UIImage?, size:CGSize){
        if image != nil {
            self.setValue(image, forKey: "currentPageImage")
        }
        let current = self.currentPage
        for i in 0...self.subviews.count - 1 {
            if i == current {
                let subView = self.subviews[i]
                subView.frame = CGRect.init(x: subView.frame.origin.x, y: subView.frame.origin.y, width: size.width, height: size.height)
            }
        }
    }
    
    func setNormalControl(image:UIImage?, size:CGSize){
        if image != nil {
            self.setValue(image, forKey: "pageImage")
        }
        let current = self.currentPage
        for i in 0...self.subviews.count - 1 {
            if i != current {
                let subView = self.subviews[i]
                subView.frame = CGRect.init(x: subView.frame.origin.x, y: subView.frame.origin.y, width: size.width, height: size.height)
            }
        }
    }
}

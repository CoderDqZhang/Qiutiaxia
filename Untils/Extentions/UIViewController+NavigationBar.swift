//
//  UIViewController+NavigationBar.swift
//  Meet
//
//  Created by Zhang on 7/1/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {

    func setNavigationItemBack(){
        let leftImage = UIImage.init(named: "back_bar")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(image: leftImage?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(UIViewController.backBtnPress(_:)))]
    }

    @objc func backBtnPress(_ sender:UIButton){
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    func setNavigationItemCleanButton(){
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: nil, style: .plain, target: nil, action: nil)
    }
    
}

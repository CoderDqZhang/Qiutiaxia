
//
//  StringExtentions.swift
//  Touqiu
//
//  Created by Zhang on 2019/7/16.
//  Copyright © 2019 com.touqiu.touqiu. All rights reserved.
//



extension String {
    func toDictionary() -> NSDictionary {
        let blankDict : NSDictionary = [:]
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
            } catch {
                print(error.localizedDescription)
            }
        }
        return blankDict
    }
}

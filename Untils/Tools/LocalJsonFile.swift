//
//  LocalJsonFile.swift
//  CatchMe
//
//  Created by Zhang on 01/12/2017.
//  Copyright © 2017 Zhang. All rights reserved.
//

import UIKit

class LocalJsonFile: NSObject {

    override init() {
        super.init()
    }
    
    func fileRead(fileName:String, type:String) -> NSDictionary?{
        let path = Bundle.main.path(forResource: fileName, ofType: type, inDirectory: nil)
        do {
            let str = try String.init(contentsOfFile: path!, encoding: String.Encoding.utf8)
            let dic = self.jsonStringToDic(str)
            return dic
        } catch  {
            print("出现错误")
        }
        return nil
    }
    
    func jsonStringToDic(_ dictionary_temp:String) ->NSDictionary? {
        let data = dictionary_temp.data(using: String.Encoding.utf8)! as NSData
        let dictionary_temp_temp = try? JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions.mutableContainers)
        return dictionary_temp_temp as? NSDictionary
        
    }
}

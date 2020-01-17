//
//  DateTools.swift
//  Touqiu
//
//  Created by Zhang on 2019/8/7.
//  Copyright © 2019 com.touqiu.touqiu. All rights reserved.
//

import UIKit


class DateTools: NSObject {

    private static let _sharedInstance = DateTools()
    
    class func getSharedInstance() -> DateTools {
        return _sharedInstance
    }
    
    private override  init()  {} // 私有化init方法
    
    func getFutureSevenDays() ->[String]{
        var date = Date.init()
        var daysStrs:[String] = []
        for _ in 0...6 {
            let dateMd = date.string(withFormat: "MM-dd")
            let week = date.dayName()
            var week_ch = ""
            if week.nsString.contains("星期"){
                week_ch = week.nsString.replacingOccurrences(of: "星期", with: "周")
            }else{
                switch (week){
                case "Monday":
                    week_ch = "周一"
                case "Tuesday":
                    week_ch = "周二"
                case "Wednesday":
                    week_ch = "周三"
                case "Thursday":
                    week_ch = "周四"
                case "Friday":
                    week_ch = "周五"
                case "Saturday":
                    week_ch = "周六"
                default:
                    week_ch = "周日"
                }
            }
            daysStrs.append("\(week_ch)\n\(dateMd)")
            date = date.tomorrow
        }
        return daysStrs
    }
    
    func intConvertStringWeek(str:String)->String{
        var week_ch = ""
        switch (str){
        case "1":
            week_ch = "周一"
        case "2":
            week_ch = "周二"
        case "3":
            week_ch = "周三"
        case "4":
            week_ch = "周四"
        case "5":
            week_ch = "周五"
        case "6":
            week_ch = "周六"
        default:
            week_ch = "周日"
        }
        return week_ch
    }
    
    func getPassSevenDays() ->[String]{
        var date = Date.init()
        var daysStrs:[String] = []
        for _ in 0...6 {
            let dateMd = date.string(withFormat: "MM-dd")
            let week = date.dayName()
             var week_ch = ""
            if week.nsString.contains("星期"){
                week_ch = week.nsString.replacingOccurrences(of: "星期", with: "周")
            }else{
                switch (week){
                case "Monday":
                    week_ch = "周一"
                case "Tuesday":
                    week_ch = "周二"
                case "Wednesday":
                    week_ch = "周三"
                case "Thursday":
                    week_ch = "周四"
                case "Friday":
                    week_ch = "周五"
                case "Saturday":
                    week_ch = "周六"
                default:
                    week_ch = "周日"
                }
            }
           
            
            daysStrs.append("\(week_ch)\n\(dateMd)")
            date = date.yesterday
        }
        return daysStrs
    }
    
    func getDateTime(str:String) ->String{
        let strs = str.components(separatedBy: "\n")
        let date = Date.init()
        return "\(date.year)\(strs[1].nsString.replacingOccurrences(of: "-", with: ""))"
    }
}

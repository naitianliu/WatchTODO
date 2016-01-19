//
//  SortActionItemListHelper.swift
//  WatchTODO
//
//  Created by Liu, Naitian on 1/18/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation
import DateTools

class SortActionItemListHelper {
    
    init() {
        
    }
    
    func getDateList() -> [NSDate] {
        var dateList: [NSDate] = []
        for (var i=0; i<7; i++) {
            let tempDate = NSDate().dateByAddingDays(i)
            dateList.append(tempDate)
        }
        return dateList
    }
    
    func getDateStringList() -> [String] {
        var dateNameList: [String] = []
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-DD"
        for date in self.getDateList() {
            let dateName = dateFormatter.stringFromDate(date)
            dateNameList.append(dateName)
        }
        return dateNameList
    }
    
    func getSectionKeyList() -> [String] {
        var sectionKeyList = self.getDateStringList()
        sectionKeyList.insert("overdue", atIndex: 0)
        sectionKeyList.append("weeklater")
        return sectionKeyList
    }
    
    func getSectionKeyTitleMappingDict() -> [String: String] {
        var keyTitleDict = Dictionary<String, String>()
        for sectionKey in self.getSectionKeyList() {
            if sectionKey == "overdue" {
                keyTitleDict[sectionKey] = "Overdue"
            } else if sectionKey == "weeklater" {
                keyTitleDict[sectionKey] = "More than one week"
            } else {
                let dateFormatter1 = NSDateFormatter()
                dateFormatter1.dateFormat = "YYYY-MM-DD"
                let todayString = dateFormatter1.stringFromDate(NSDate())
                let tomorrowString = dateFormatter1.stringFromDate(NSDate().dateByAddingDays(1))
                let dueDate: NSDate = dateFormatter1.dateFromString(sectionKey)!
                if sectionKey == todayString {
                    keyTitleDict[sectionKey] = "Today"
                } else if sectionKey == tomorrowString {
                    keyTitleDict[sectionKey] = "Tomorrow"
                } else {
                    let dateFormatter2 = NSDateFormatter()
                    dateFormatter2.dateFormat = "EEEE"
                    keyTitleDict[sectionKey] = dateFormatter2.stringFromDate(dueDate)
                }
            }
        }
        return keyTitleDict
    }
    
    func divideByDate(data: [[String: AnyObject]]) -> [String: [[String: AnyObject]]] {
        var newDateDictArray = Dictionary<String, [[String: AnyObject]]>()
        newDateDictArray["overdue"] = []
        newDateDictArray["weeklater"] = []
        for dateString in self.getDateStringList() {
            newDateDictArray[dateString] = []
        }
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-DD"
        for itemDict in data {
            let dueDateString: String = itemDict["dueDate"] as! String
            if newDateDictArray[dueDateString] != nil {
                newDateDictArray[dueDateString]?.append(itemDict)
            } else {
                let dueDate: NSDate = dateFormatter.dateFromString(dueDateString)!
                if dueDate.isEarlierThan(NSDate()) {
                    newDateDictArray["overdue"]?.append(itemDict)
                } else if dueDate.isLaterThan(NSDate().dateByAddingWeeks(1)) {
                    newDateDictArray["weeklater"]?.append(itemDict)
                }
            }
        }
        return newDateDictArray
    }
}
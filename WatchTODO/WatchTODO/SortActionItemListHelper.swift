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
    
    func getSectionKeyList(category: String?) -> [String] {
        if let _ = category {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-DD"
            let key = dateFormatter.stringFromDate(NSDate())
            let sectionKeyList = [key]
            return sectionKeyList
        } else {
            var sectionKeyList = self.getDateStringList()
            sectionKeyList.insert("overdue", atIndex: 0)
            sectionKeyList.append("weeklater")
            return sectionKeyList
        }
        
    }
    
    func getSectionKeyTitleMappingDict(category: String?) -> [String: String] {
        var keyTitleDict = Dictionary<String, String>()
        for sectionKey in self.getSectionKeyList(category) {
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
    
    func divideByDate(data: [[String: AnyObject]], category: String?) -> ([String: [[String: AnyObject]]], [String]) {
        var keyList: [String] = []
        var newDateDictArray = Dictionary<String, [[String: AnyObject]]>()
        newDateDictArray["overdue"] = []
        newDateDictArray["weeklater"] = []
        for dateString in self.getDateStringList() {
            newDateDictArray[dateString] = []
        }
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-DD"
        for itemDict in data {
            let dueDateEpoch: String = itemDict["dueDate"] as! String
            let dueDate: NSDate = DateTimeHelper().convertEpochToDate(dueDateEpoch)
            let dateString: String = dateFormatter.stringFromDate(dueDate)
            if newDateDictArray[dateString] != nil {
                newDateDictArray[dateString]?.append(itemDict)
            } else {
                let dueDate: NSDate = DateTimeHelper().convertEpochToDate(dueDateEpoch)
                let startOfToday = DateTimeHelper().getDateStartOfToday()
                if dueDate.isEarlierThan(startOfToday) {
                    newDateDictArray["overdue"]?.append(itemDict)
                } else if dueDate.isLaterThan(startOfToday.dateByAddingWeeks(1)) {
                    newDateDictArray["weeklater"]?.append(itemDict)
                }
            }
        }
        for dateString in self.getSectionKeyList(category) {
            if newDateDictArray[dateString]?.count != 0 {
                keyList.append(dateString)
            }
        }
        return (newDateDictArray, keyList)
    }
    
    func dividedByFriend(data: [[String: AnyObject]]) -> ([String: [[String: AnyObject]]], [String]) {
        var newDictArray = Dictionary<String, [[String: AnyObject]]>()
        var usernameArray: [String] = []
        for itemDict in data {
            let username: String = itemDict["username"] as! String
            if newDictArray[username] == nil {
                newDictArray[username] = [itemDict]
                usernameArray.append(username)
            } else {
                newDictArray[username]?.append(itemDict)
            }
        }
        return (newDictArray, usernameArray)
    }
}
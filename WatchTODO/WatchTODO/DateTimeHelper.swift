//
//  DateTimeHelper.swift
//  WatchTODO
//
//  Created by Liu, Naitian on 2/5/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import Foundation
import DateTools

class DateTimeHelper {
    init() {
        
    }
    
    func convertDateToEpoch(date: NSDate?) -> String? {
        if let tempDate = date {
            let epoch: String = String(Int(tempDate.timeIntervalSince1970))
            print(epoch)
            return epoch
        } else {
            return nil
        }
    }
    
    func convertEpochToDate(epoch: String) -> NSDate {
        let date: NSDate = NSDate(timeIntervalSince1970: NSTimeInterval(epoch)!)
        return date
    }
    
    func convertDateToStringMediumStyle(date: NSDate) -> String {
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.MediumStyle
        let dateString = formatter.stringFromDate(date)
        return dateString
    }
    
    func convertStringToDateMediumStyle(dateString: String) -> NSDate {
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.MediumStyle
        let date = formatter.dateFromString(dateString)
        return date!
    }
    
    func getDateEndOfToday() -> NSDate {
        let components = NSDateComponents()
        components.day = 1
        components.second = -1
        let endOfToday = NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: self.getDateStartOfToday(), options: NSCalendarOptions())
        return endOfToday!
    }
    
    func getDateStartOfToday() -> NSDate {
        let startOfToday = NSCalendar.currentCalendar().startOfDayForDate(NSDate())
        return startOfToday
    }
}


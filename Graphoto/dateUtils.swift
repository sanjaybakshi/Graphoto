//
//  dateUtils.swift
//  Graphoto
//
//  Created by Sanjay Bakshi on 9/25/23.
//

import Foundation



public class dateUtils
{
    
    public init()
    {
        
    }
    
    public var currentTime: String {
        get {
            return Date().description(with: Locale.current)
        }
    }


    public func monthNumToString(month: Int) -> String
    {
        let dateFormatter: DateFormatter = DateFormatter()
        let months = dateFormatter.shortMonthSymbols
        let monthSymbol = months?[month-1]
    
        return monthSymbol!
    }
    
    public func monthNumToLongString(month: Int) -> String
    {
        let dateFormatter: DateFormatter = DateFormatter()
        let months = dateFormatter.standaloneMonthSymbols
        let monthSymbol = months?[month-1]
        
        return monthSymbol!
    }

    public func monthLongStringToInt(month: String) -> Int
    {
        let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
        let index = months.index(of: month)
        return index! + 1
    }

    public func stringToDate(dateString: String) -> Date?
        // Description:
        //      Takes a string of format 7/19/2014 and returns a Date.
        //
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/d/yyyy"
        return dateFormatter.date(from: dateString)
    }

    public func dateToString(dateV: Date) -> String?
        // Description:
        //      Takes a date and returns it in the format 7/19/2014
        //
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/d/yyyy"
        return dateFormatter.string(from: dateV)
    }

    public func getCurrentDay() -> String
    {
        let todayDate = Date()
        let cal       = Calendar.current
        let dayInt = ((cal as NSCalendar).component(NSCalendar.Unit.day, from: todayDate))
        return String(dayInt)
    }

    public func getCurrentYear() -> String
    {
        return GetYearFromDate(Date())
    }
    
    public func getCurrentMonth() -> String
    {
        return GetMonthFromDate(Date())
    }

    public func GetYearFromDate(_ date: Date) -> String
    {
        let cal       = Calendar.current
        let yearInt = ((cal as NSCalendar).component(NSCalendar.Unit.year, from: date))
        return String(yearInt)
    }
    
    public func GetMonthFromDate(_ date: Date) -> String
    {
        return monthNumToLongString(month: GetMonthIntFromDate(date))
    }
    
    public func GetMonthIntFromDate(_ date: Date) -> Int
    {
        let cal       = Calendar.current
        let monthInt  = ((cal as NSCalendar).component(NSCalendar.Unit.month, from: date))
        return monthInt
    }
    
    public func GetDayFromDate(_ date: Date) -> String
    {
        return String(GetDayIntFromDate(date))
    }
    
    public func GetDayIntFromDate(_ date: Date) -> Int
    {
        let cal       = Calendar.current
        let dayInt = ((cal as NSCalendar).component(NSCalendar.Unit.day, from: date))
        return dayInt
    }

}

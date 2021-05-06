//
//  CDADateManager.swift
//  CDAUtilities
//
//  Created by Alexander on 5/05/21.
//

import Foundation

public struct DifferenceDates {
    
    public var year    = 0
    public var month   = 0
    public var day     = 0
    public var hour    = 0
    public var minute  = 0
    public var second  = 0
}

public enum LocalIdentifier : String {
    
    case spanish_Peru    = "es_PE"
    case english         = "en"
}

extension String {
    
    public func toDateWithFormat(_ dateformat: String, withLocale locale: Locale = Locale(identifier: Locale.current.identifier)) -> Date {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = locale
        dateFormatter.dateFormat = dateformat
        
        return dateFormatter.date(from: self) ?? Date()
    }

}
//MARK: - class CSDateManager

public class CSDateManager {
    
    public class func convertDateInTextLocale(date : Date,dateStyle : DateFormatter.Style,language : LocalIdentifier? = nil) -> String {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = Locale(identifier: language?.rawValue ?? "es_PE")
        dateFormatter.dateStyle = dateStyle
        
        return dateFormatter.string(from: date)
    }
    
    public class func convertDateIntTextTime(date : Date, format : String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
}

//MARK: - Date Propeties

extension Date {
    
    public typealias AditiontalDaysInMonth = (upperDays: [Date], regularDays: [Date], downDays: [Date])
 
    public var numberDayOfWeek: TimeInterval {
        
        let components = Calendar.current.dateComponents([.weekday], from: self)
        return TimeInterval(components.weekday ?? 0)
    }
    
    public var countDays: Int {
        
        guard let range = Calendar.current.range(of: .day, in: .month, for: self) else { return 0 }
        let numDays = range.count
        return numDays
    }
    
    public var firstDayOfMonth: Date? {
        
        var components = Calendar.current.dateComponents([.month, .year], from: self)
        components.day = 1
        let newDate = Calendar.current.date(from: components)
        return newDate
    }
    
    public var lastDayOfMonth: Date? {

        var components = Calendar.current.dateComponents([.month, .year], from: self)
        components.day = self.countDays
        let newDate = Calendar.current.date(from: components)
        return newDate
    }

    public var fisrtDayOfWeek: Date? {
        
        let delta = Int(1 - self.numberDayOfWeek)
        let newDate = self.addTime(DateComponents(day: delta))
        return newDate
    }
    
    public var lastDayOfWeek: Date? {
        
        let delta = Int(7 - self.numberDayOfWeek)
        let newDate = self.addTime(DateComponents(day: delta))
        return newDate
    }
    
    private static func createDaysForRange(_ range: Range<Int>, toStartInDate date: Date) -> [Date] {
        
        var arrayDays = [Date]()
        
        range.forEach { (increment) in
            let dateComponent = DateComponents(day: increment)
            arrayDays.append(date.addTime(dateComponent))
        }
        
        return arrayDays
    }
    
    public var daysInWeek: [Date] {

        guard let fisrtDayOfWeek = self.fisrtDayOfWeek else { return [] }
        let range = (0..<7)
        return Date.createDaysForRange(range, toStartInDate: fisrtDayOfWeek)
    }
    
    private var regularDaysInMonth: [Date] {

        guard let firstDayInMonth = self.firstDayOfMonth else { return [] }
        let range = (0..<self.countDays)
        return Date.createDaysForRange(range, toStartInDate: firstDayInMonth)
    }
    
    private var upperDaysInMonth: [Date] {

        guard let firstDayInMonth = self.firstDayOfMonth else { return [] }
        let numberOfDayInWeek = Int(firstDayInMonth.numberDayOfWeek) - 1
        let range = (-numberOfDayInWeek)..<0
        return Date.createDaysForRange(range, toStartInDate: firstDayInMonth)
    }
    
    private var lowerDaysInMonth: [Date] {

        guard let lastDayOfMonth = self.lastDayOfMonth else { return [] }
        let numberOfDayInWeek = Int(lastDayOfMonth.numberDayOfWeek)
        let range = 1..<(8-numberOfDayInWeek)
        return Date.createDaysForRange(range, toStartInDate: lastDayOfMonth)
    }
    
    public var daysInMonth: AditiontalDaysInMonth {
        return (self.upperDaysInMonth, self.regularDaysInMonth, self.lowerDaysInMonth)
    }
}



//MARK: - Date Methods

extension Date {
        
    public func toStringWithFormat(_ format: String, withLocale locale: Locale = Locale(identifier: Locale.current.identifier)) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = locale
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: self)
    }
    
    static public func convertTimestampInDate(_ timestamp: String) -> Date {
        
        if let interval = TimeInterval(timestamp) {
            return Date(timeIntervalSince1970: interval)
        }
        
        return Date()
    }
    
    public var toDate: Date {
        let dateComponents = Calendar.current.dateComponents([.day, .month, .year], from: self)
        return Calendar.current.date(from: dateComponents) ?? self
    }
    
    public func addTime(_ time: DateComponents) -> Date{
        return Calendar.current.date(byAdding: time, to: self) ?? Date()
    }
    
    public func getYearsDifferenceBetweenDate(_ finalDate: Date) -> TimeInterval{
        
        let components = Calendar.current.dateComponents([.year], from: self, to: finalDate)
        return TimeInterval(components.year ?? 0)
    }
    
    public func getMonthDifferenceBetweenDate(_ finalDate: Date) -> TimeInterval{
        
        let components = Calendar.current.dateComponents([.month], from: self, to: finalDate)
        return TimeInterval(components.month ?? 0)
    }
        
    public func getDayDifferenceBetweenDate(_ finalDate: Date) -> TimeInterval{
        
        let components = Calendar.current.dateComponents([.day], from: self, to: finalDate)
        return TimeInterval(components.day ?? 0)
    }
    
    public func getHourDifferenceBetweenDate(_ finalDate: Date) -> TimeInterval{
        
        let components = Calendar.current.dateComponents([.hour], from: self, to: finalDate)
        return TimeInterval(components.hour ?? 0)
    }
    
    public func getMinuteDifferenceBetweenDate(_ finalDate: Date) -> TimeInterval{
        
        let components = Calendar.current.dateComponents([.minute], from: self, to: finalDate)
        return TimeInterval(components.minute ?? 0)
    }
    
    public func getSecondDifferenceBetweenDate(_ finalDate: Date) -> TimeInterval{
        
        let components = Calendar.current.dateComponents([.second], from: self, to: finalDate)
        return TimeInterval(components.second ?? 0)
    }
    
    public func getDifferenceBetweenDate(_ finalDate: Date) -> DifferenceDates{
        
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self, to: finalDate)
        
        var difference = DifferenceDates()
        
        difference.year     = components.year ?? 0
        difference.month    = components.month ?? 0
        difference.year     = components.day ?? 0
        difference.hour     = components.hour ?? 0
        difference.minute   = components.minute ?? 0
        difference.second   = components.second ?? 0
        
        return difference
    }
}

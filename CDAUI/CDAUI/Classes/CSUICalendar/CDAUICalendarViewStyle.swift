//
//  CDAUICalendarViewStyle.swift
//  CDAUI
//
//  Created by Alexander on 8/05/21.
//

import UIKit

extension CDAUICalendarViewStyle.DateStyle {
    
    public struct Date {
        public var eventColor           = UIColor.systemBlue
        public var selection            = UIColor.systemBlue
        public var textColor            = UIColor.darkGray
        public var textColorSelected    = UIColor.white
        public var font                 = UIFont.systemFont(ofSize: 16)
        
        public init(eventColor: UIColor = .systemBlue, selection: UIColor = .systemBlue, textColor: UIColor = .darkGray, textColorSelected: UIColor = .white) {
            self.eventColor         = eventColor
            self.selection          = selection
            self.textColor          = textColor
            self.textColorSelected  = textColorSelected
        }
    }
}

extension CDAUICalendarViewStyle {
    
    public struct DateStyle {
        public var available    = Date(textColor: UIColor.darkGray)
        public var disable      = Date(textColor: UIColor.lightGray)
    }
}

extension CDAUICalendarViewStyle {
    
    public struct DayStyle {
        public var textColor    = UIColor.darkGray
        public var font         = UIFont.systemFont(ofSize: 16)
    }
}

extension CDAUICalendarViewStyle {
    
    public struct Header {
        public var backgroundColor : UIColor = .systemBlue
        public var title           = ""
        public var font            = UIFont.boldSystemFont(ofSize: 22)
        public var nextIcon        : UIImage? = UIImage(named: "ic_chevron.right")
        public var backIcon        : UIImage? = UIImage(named: "ic_chevron.left")
        public var height          : CGFloat = 50
        public var titleColor      = UIColor.white
    }
}

extension CDAUICalendarViewStyle.Lock {
        
    public struct Days: OptionSet {
        
        public let rawValue: Int
    
        public static let none      = Days(rawValue: 1 << 0)
        public static let sunday    = Days(rawValue: 1 << 1)
        public static let monday    = Days(rawValue: 1 << 2)
        public static let tuesday   = Days(rawValue: 1 << 3)
        public static let wednesday = Days(rawValue: 1 << 4)
        public static let thursday  = Days(rawValue: 1 << 5)
        public static let friday    = Days(rawValue: 1 << 6)
        public static let saturday  = Days(rawValue: 1 << 7)
        
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
        
        public static func getDay(rawValue: Int) -> Days {
            switch rawValue {
                case 1: return .sunday
                case 2: return .monday
                case 3: return .tuesday
                case 4: return .wednesday
                case 5: return .thursday
                case 6: return .friday
                case 7: return .saturday
                default: return .none
            }
        }
    }
}

extension CDAUICalendarViewStyle {
    
    public struct Lock {
        public var days         : Days = .none
        public var hollyDays    = [Date]()
        public var minimunDate  : Date?
        public var maximunDate  : Date?
    }
}

public struct CDAUICalendarViewStyle {

    public var cornerRadius         : CGFloat = 0
    public var header               = Header()
    public var backgroundColor      = UIColor.lightText
    public var dateStyle            = DateStyle()
    public var dayStyle             = DayStyle()
    public var lock                 = Lock()
    
    func dayIsLock(_ date: Date) -> Bool {
        
        if let minimunDate = self.lock.minimunDate, minimunDate > date { return true }
        if let maximunDate = self.lock.maximunDate, maximunDate < date { return true }
        
        let numberDayInWeek = Int(date.numberDayOfWeek)
        let dayToLock = Lock.Days.getDay(rawValue: numberDayInWeek)
        if self.lock.days.contains(dayToLock) { return true }
        
        return self.lock.hollyDays.filter({ $0 == date.toStringWithFormat("dd/MM").toDateWithFormat("dd/MM")}).count > 0
    }
}

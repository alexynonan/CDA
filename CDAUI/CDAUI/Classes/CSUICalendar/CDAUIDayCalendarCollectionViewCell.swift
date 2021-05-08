//
//  CDAUIDayCalendarCollectionViewCell.swift
//  CDAUI
//
//  Created by Alexander on 8/05/21.
//

import UIKit

public class CDAUIDayCalendarCollectionViewCell: UICollectionViewCell {
    
    private lazy var btnDay: UIButton = {
       
        let btn = UIButton(type: .system)
        btn.clipsToBounds = true
        btn.isUserInteractionEnabled = false
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private var objCalendarDate: CDAUICalendarDate!
    
    public func setCalendarData(_ calendarDate: CDAUICalendarDate, isSelected: Bool = false) {
        
        self.isUserInteractionEnabled = !calendarDate.dateIsLock
        self.objCalendarDate = calendarDate
        self.btnDay.setTitle(self.objCalendarDate.date.toStringWithFormat("dd"), for: .normal)
        self.selectCell(isSelected)
    }
    
    public func selectCell(_ isSelected: Bool, animated: Bool = false) {
        
        UIView.animate(withDuration: animated ? 0.25 : 0) {
            self.btnDay.tintColor = isSelected ? self.objCalendarDate.style.textColorSelected : self.objCalendarDate.style.textColor
            self.btnDay.backgroundColor = isSelected ? self.objCalendarDate.style.selection : .clear
        }
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.addSubview(self.btnDay)
        self.btnDay.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        self.btnDay.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        self.btnDay.widthAnchor.constraint(equalTo: self.btnDay.heightAnchor, multiplier: 1).isActive = true
        self.btnDay.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        
        self.btnDay.layer.cornerRadius = rect.height / 2
    }
}

public class CDAUICalendarDate {
    
    public var date: Date
    public var dateIsLock: Bool
    public var style: CDAUICalendarViewStyle.DateStyle.Date
    
    init(date: Date, dateIsLock: Bool, style: CDAUICalendarViewStyle.DateStyle.Date) {
        self.date = date
        self.dateIsLock = dateIsLock
        self.style = style
    }
}

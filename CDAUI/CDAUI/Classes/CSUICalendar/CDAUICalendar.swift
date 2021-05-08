//
//  CDAUICalendar.swift
//  CDAUI
//
//  Created by Alexander on 8/05/21.
//

import UIKit

@objc public protocol CDAUICalendarViewDelegate {
    @objc optional func calendarView(_ calendar: CDAUICalendarView, didSelectDate date: Date)
    @objc optional func calendarView(_ calendar: CDAUICalendarView, allowNextMonthToDate date: Date) -> Bool
    @objc optional func calendarView(_ calendar: CDAUICalendarView, allowBackMonthToDate date: Date) -> Bool
}

@IBDesignable open class CDAUICalendarView: UIView {
    
    public var style = CDAUICalendarViewStyle() {
        didSet { self.updateStyleAppeareance() }
    }
    
    @IBOutlet weak var delegate: CDAUICalendarViewDelegate?
    @IBOutlet weak var cnsHeight: NSLayoutConstraint?
    
    @IBInspectable private var cornerRadius: CGFloat {
        get { return self.style.cornerRadius }
        set { self.style.cornerRadius = newValue }
    }
    
    @IBInspectable private var headerBackground: UIColor {
        get { return self.style.header.backgroundColor }
        set { self.style.header.backgroundColor = newValue}
    }
    
    @IBInspectable private var headerTitle: UIColor {
        get { return self.style.header.titleColor }
        set { self.style.header.titleColor = newValue}
    }
    
    @IBInspectable private var backMonthIcon: UIImage? {
        get { return self.style.header.backIcon }
        set { self.style.header.backIcon = newValue}
    }
    
    @IBInspectable private var nextMonthIcon: UIImage? {
        get { return self.style.header.nextIcon }
        set { self.style.header.nextIcon = newValue}
    }
    
    @IBInspectable private var bodyBackground: UIColor {
        get { return self.style.backgroundColor }
        set { self.style.backgroundColor = newValue}
    }
    
    private lazy var arrayDaysLabels: [UILabel] = {
       
        var array = [UILabel]()
        var arrayDays = ["D", "L", "M", "M", "J", "V", "S"]
        
        arrayDays.forEach { (day) in
            let lbl = UILabel()
            lbl.text = day
            lbl.font = self.style.dayStyle.font
            lbl.textColor = self.style.dayStyle.textColor
            lbl.numberOfLines = 1
            lbl.textAlignment = .center
            lbl.translatesAutoresizingMaskIntoConstraints = false
            array.append(lbl)
        }

        return array
    }()

    public var selectedDate = Date().toDate
    private var currentDate = Date().toDate {
        didSet { self.reloadCurrentDate() }
    }
    
    private var arrayDates = [CDAUICalendarDate]()
    
    private func getCurrentDate() -> Date {
        return Date()
    }
    
    private lazy var viewHeader: UIView = {
        var view = UIView()
        view.backgroundColor = self.style.header.backgroundColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var viewContent: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = self.style.backgroundColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var lblTiitle: UILabel = {
       
        let lbl = UILabel()
        lbl.font = self.style.header.font
        lbl.textColor = self.style.header.titleColor
        lbl.text = self.currentDate.toStringWithFormat("MMMM yyyy")
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var btnNextMonth: UIButton = {
       
        let btn = UIButton(type: .system)
        btn.setImage(self.style.header.nextIcon, for: .normal)
        btn.tintColor = self.style.header.titleColor
        btn.addTarget(self, action: #selector(self.clickBtnNextMonth(_:)), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private lazy var btnBackMonth: UIButton = {
       
        let btn = UIButton(type: .system)
        btn.setImage(self.style.header.backIcon, for: .normal)
        btn.tintColor = self.style.header.titleColor
        btn.addTarget(self, action: #selector(self.clickBtnBackMonth(_:)), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private lazy var viewDays: UIView = {
       
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var clvDates: UICollectionView = {
       
        let clv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        clv.register(CDAUIDayCalendarCollectionViewCell.self, forCellWithReuseIdentifier: "CDAUIDayCalendarCollectionViewCell")
        clv.backgroundColor = .clear
        clv.delegate = self
        clv.dataSource = self
        clv.translatesAutoresizingMaskIntoConstraints = false
        return clv
    }()
    
    private func getArrayDatesToDate(_ date: Date) -> [CDAUICalendarDate] {
        
        let daysInMonth = date.daysInMonth
        
        var arrayCalendarDate = [CDAUICalendarDate]()
        var arrayDates = [Date]()
        
        arrayDates.append(contentsOf: daysInMonth.upperDays)
        daysInMonth.upperDays.forEach { (date) in
            arrayCalendarDate.append(CDAUICalendarDate(date: date, dateIsLock: true, style: self.style.dateStyle.disable))
        }
        
        arrayDates.append(contentsOf: daysInMonth.regularDays)
        daysInMonth.regularDays.forEach { (date) in
            
            let dateIsLock = self.style.dayIsLock(date)
            let style = dateIsLock ? self.style.dateStyle.disable : self.style.dateStyle.available
            arrayCalendarDate.append(CDAUICalendarDate(date: date, dateIsLock: dateIsLock, style: style))
        }
        
        arrayDates.append(contentsOf: daysInMonth.downDays)
        daysInMonth.downDays.forEach { (date) in
            arrayCalendarDate.append(CDAUICalendarDate(date: date, dateIsLock: true, style: self.style.dateStyle.disable))
        }
        
        return arrayCalendarDate
    }
    
    private func reloadCurrentDate() {
        
        self.lblTiitle.text = self.currentDate.toStringWithFormat("MMMM yyyy")
        
        self.arrayDates = self.getArrayDatesToDate(self.currentDate)
        self.clvDates.performBatchUpdates({
            self.clvDates.reloadSections(IndexSet(arrayLiteral: 0))
        }) { (_) in
            if let index = self.arrayDates.firstIndex(where: { return $0.date.getDayDifferenceBetweenDate(self.selectedDate) == 0 }) {
                let indexPath = IndexPath(item: index, section: 0)
                self.clvDates.selectItem(at: indexPath, animated: true, scrollPosition: .top)
            }
            self.animateHeight()
        }
    }
    
    private func animateHeight(animate: Bool = true) {
        UIView.animate(withDuration: animate ? 0.35 : 0) {
            self.cnsHeight?.constant = self.frame.height - self.clvDates.frame.height + self.clvDates.contentSize.height
            self.superview?.layoutIfNeeded()
        }
    }
    
    private func updateStyleAppeareance() {
        
        self.viewContent.layer.cornerRadius = self.style.cornerRadius
        self.viewContent.layer.masksToBounds = true
        self.viewContent.backgroundColor = self.style.backgroundColor
        self.lblTiitle.textColor = self.style.header.titleColor
        
        self.btnBackMonth.setImage(self.style.header.backIcon, for: .normal)
        self.btnNextMonth.setImage(self.style.header.nextIcon, for: .normal)
        
        self.btnBackMonth.tintColor = self.style.header.titleColor
        self.btnNextMonth.tintColor = self.style.header.titleColor
    }
    
    open override func draw(_ rect: CGRect) {
        super.draw(rect)

        self.arrayDates = self.getArrayDatesToDate(self.currentDate)
        
        self.addViewContent()
        self.addViewHeader()
        self.addBtnBackMonth()
        self.addLblTitle()
        self.addBtnNextMonth()
        self.addViewDays()
        self.addArrayDaysLabels()
        self.addClvDates()
        
        if let index = self.arrayDates.firstIndex(where: { return $0.date.getDayDifferenceBetweenDate(self.selectedDate) == 0 }) {
            let indexPath = IndexPath(item: index, section: 0)
            self.clvDates.selectItem(at: indexPath, animated: true, scrollPosition: .top)
        }
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    open override func setNeedsLayout() {
        self.backgroundColor = .clear
        self.animateHeight(animate: false)
    }
}

extension CDAUICalendarView {
        
    @objc private func clickBtnNextMonth(_ sender: UIButton) {
        
        var dateComponent = DateComponents()
        dateComponent.month = 1
        self.currentDate = self.currentDate.addTime(dateComponent)
        self.btnBackMonth.isEnabled = self.delegate?.calendarView?(self, allowBackMonthToDate: self.currentDate) ?? true
        self.btnNextMonth.isEnabled = self.delegate?.calendarView?(self, allowNextMonthToDate: self.currentDate) ?? true
    }
    
    @objc private func clickBtnBackMonth(_ sender: UIButton) {
        
        var dateComponent = DateComponents()
        dateComponent.month = -1
        self.currentDate = self.currentDate.addTime(dateComponent)
        
        self.btnBackMonth.isEnabled = self.delegate?.calendarView?(self, allowBackMonthToDate: self.currentDate) ?? true
        self.btnNextMonth.isEnabled = self.delegate?.calendarView?(self, allowNextMonthToDate: self.currentDate) ?? true
    }
}

extension CDAUICalendarView {
    
    private func addViewContent() {
        self.addSubview(self.viewContent)
        self.viewContent.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        self.viewContent.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        self.viewContent.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        self.viewContent.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
    }
    
    private func addViewHeader() {
        self.viewContent.addSubview(self.viewHeader)
        self.viewHeader.topAnchor.constraint(equalTo: self.viewContent.topAnchor, constant: 0).isActive = true
        self.viewHeader.leadingAnchor.constraint(equalTo: self.viewContent.leadingAnchor, constant: 0).isActive = true
        self.viewHeader.trailingAnchor.constraint(equalTo: self.viewContent.trailingAnchor, constant: 0).isActive = true
        self.viewHeader.heightAnchor.constraint(equalToConstant: self.style.header.height).isActive = true
    }
    
    private func addLblTitle() {
        
        self.viewHeader.addSubview(self.lblTiitle)
        self.lblTiitle.leadingAnchor.constraint(equalTo: self.btnBackMonth.trailingAnchor, constant: 20).isActive = true
        self.lblTiitle.centerYAnchor.constraint(equalTo: self.btnBackMonth.centerYAnchor, constant: 0).isActive = true
    }
    
    private func addBtnNextMonth() {
        
        self.viewHeader.addSubview(self.btnNextMonth)
        self.btnNextMonth.trailingAnchor.constraint(equalTo: self.viewHeader.trailingAnchor, constant: -20).isActive = true
        self.btnNextMonth.centerYAnchor.constraint(equalTo: self.lblTiitle.centerYAnchor, constant: 0).isActive = true
        self.btnNextMonth.leadingAnchor.constraint(equalTo: self.lblTiitle.trailingAnchor, constant: 15).isActive = true
    }
    
    private func addBtnBackMonth() {
        
        self.viewHeader.addSubview(self.btnBackMonth)
        self.btnBackMonth.leadingAnchor.constraint(equalTo: self.viewHeader.leadingAnchor, constant: 20).isActive = true
        self.btnBackMonth.centerYAnchor.constraint(equalTo: self.viewHeader.centerYAnchor, constant: 0).isActive = true
    }
    
    private func addViewDays() {
        
        self.viewContent.addSubview(self.viewDays)
        self.viewDays.topAnchor.constraint(equalTo: self.viewHeader.bottomAnchor, constant: 0).isActive = true
        self.viewDays.leadingAnchor.constraint(equalTo: self.viewContent.leadingAnchor, constant: 5).isActive = true
        self.viewDays.trailingAnchor.constraint(equalTo: self.viewContent.trailingAnchor, constant: -5).isActive = true
        self.viewDays.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    private func addArrayDaysLabels() {
        
        for (index, label) in self.arrayDaysLabels.enumerated() {
            self.viewDays.addSubview(label)
            
            label.topAnchor.constraint(equalTo: self.viewDays.topAnchor, constant: 0).isActive = true
            label.bottomAnchor.constraint(equalTo: self.viewDays.bottomAnchor, constant: 0).isActive = true
            
            if index > 0 {
                label.widthAnchor.constraint(equalTo: self.arrayDaysLabels[index - 1].widthAnchor, multiplier: 1).isActive = true
                label.leadingAnchor.constraint(equalTo: self.arrayDaysLabels[index - 1].trailingAnchor, constant: 0).isActive = true
            }
            
            if index == 0 {
                label.leadingAnchor.constraint(equalTo: self.viewDays.leadingAnchor, constant: 0).isActive = true
            }
            
            if index == (self.arrayDaysLabels.count - 1) {
                label.trailingAnchor.constraint(equalTo: self.viewDays.trailingAnchor, constant: 0).isActive = true
            }
        }
    }
    
    private func addClvDates() {
        
        self.clvDates.invalidateIntrinsicContentSize()
        self.viewContent.addSubview(self.clvDates)
        self.clvDates.topAnchor.constraint(equalTo: self.viewDays.bottomAnchor, constant: 0).isActive = true
        self.clvDates.leadingAnchor.constraint(equalTo: self.viewContent.leadingAnchor, constant: 5).isActive = true
        self.clvDates.trailingAnchor.constraint(equalTo: self.viewContent.trailingAnchor, constant: -5).isActive = true
        self.clvDates.bottomAnchor.constraint(equalTo: self.viewContent.bottomAnchor, constant: -5).isActive = true
    }
}

extension CDAUICalendarView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrayDates.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellIdenfier = "CDAUIDayCalendarCollectionViewCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdenfier, for: indexPath) as! CDAUIDayCalendarCollectionViewCell
        
        let objCalendarDate = self.arrayDates[indexPath.row]
        let isSelected = self.selectedDate == objCalendarDate.date
        cell.setCalendarData(self.arrayDates[indexPath.row], isSelected: isSelected)
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let calendarDate = self.arrayDates[indexPath.row]
        self.selectedDate = calendarDate.date
        self.delegate?.calendarView?(self, didSelectDate: self.selectedDate)
        guard let cell = collectionView.cellForItem(at: indexPath) as? CDAUIDayCalendarCollectionViewCell else { return }
        cell.selectCell(true, animated: true)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CDAUIDayCalendarCollectionViewCell else { return }
        cell.selectCell(false, animated: true)
    }
}

extension CDAUICalendarView: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth = collectionView.frame.width / 7
        return CGSize(width: cellWidth, height: 40)
    }
}

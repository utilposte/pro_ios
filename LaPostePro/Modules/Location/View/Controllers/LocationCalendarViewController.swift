//
//  LocationCalendarViewController.swift
//  LaPostePro
//
//  Created by Lassad Tiss on 31/07/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit
import FSCalendar

class LocationCalendarViewController: UIViewController {

    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var previousMonthButton: UIButton!
    @IBOutlet weak var nextMonthButton: UIButton!
    
    var codeSite = ""
    var postalOfficeHours: [Any]?
    
    var typeTag : String?
    
    let locationMapViewModel = LocationViewModel()
    
    var sections = ["Horaires d’ouverture", "Heures limites de dépôt"]
    var items: Array<Any>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTitleNavigationBar(backEnabled: true, title:"Calendrier des horaires", showCart: false)
        setupCalendar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // ATInternet
        if let type = self.typeTag {
            ATInternetTaggingManager.sharedManager.sendTrackPage(pageName: TaggingData.kCalendar,
                                                                 chapter1: type,
                                                                 chapter2: nil,
                                                                 level2: TaggingData.kLocaliseLevel)
        }
    }
    
    func setupCalendar() {
        calendarView.appearance.weekdayFont = UIFont.systemFont(ofSize: 14)
        calendarView.appearance.titleFont = UIFont.systemFont(ofSize: 18)
        setupMonthLabel(page: calendarView.currentPage)
        setWorkingHours(for: Date())
    }
    
    @IBAction func showPreviousMonth(_ sender: UIButton) {
        showMonth(position: -1)
        if calendarView.isPage(inRange: calendarView.maximumDate) {
            nextMonthButton.setImage(R.image.ic_next_month(), for: .normal)
        }
        if isActivePage(for: calendarView.minimumDate) {
            sender.setImage(R.image.ic_previous_month_disabled(), for: .normal)
        }
    }
    
    @IBAction func showNextMonth(_ sender: UIButton) {
        showMonth(position: 1)
        if calendarView.isPage(inRange: calendarView.minimumDate) {
            previousMonthButton.setImage(R.image.ic_previous_month(), for: .normal)
        }
        if isActivePage(for: calendarView.maximumDate) {
            sender.setImage(R.image.ic_next_month_disabled(), for: .normal)
        }
    }
    
    func showMonth(position: Int)  {
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.month = position
        let currentPage = calendar.date(byAdding: dateComponents, to: calendarView.currentPage)
        calendarView.setCurrentPage(currentPage!, animated: true)
        setupMonthLabel(page: calendarView.currentPage)
    }
    
    func setupMonthLabel(page: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        let month = dateFormatter.string(from: page)
        dateFormatter.dateFormat = "yyyy"
        let year = dateFormatter.string(from: page)
        let formattedString = NSMutableAttributedString()
        formattedString
            .custom("\(month.capitalized) ", font: UIFont.systemFont(ofSize: 24), color: .lpDeepBlue)
            .custom(year, font: UIFont.boldSystemFont(ofSize: 24), color: .lpPurple)
        monthLabel.attributedText = formattedString
    }
    
    func isToady(date: Date) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MM yyyy"
        let today = dateFormatter.string(from: Date())
        let event = dateFormatter.string(from: date)
        if today == event {
            return true
        }
        return false
    }
    
    func isActivePage(for date: Date) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM yyyy"
        let maximumPage = dateFormatter.string(from: date)
        let currentPage = dateFormatter.string(from: calendarView.currentPage)
        if maximumPage == currentPage {
            return true
        }
        return false
    }
    @IBAction func dismissClicked(_ sender: Any) {
        self.dismissLeftTransition()
    }
    
}

extension LocationCalendarViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if items?.isEmpty == false {
            return items!.count
        }
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = UIView()
        header.backgroundColor = .white
        let headerFrame = self.view.frame.size
        let titleLabel = UILabel(frame: CGRect(x: 20, y: 20, width: headerFrame.width - 40, height: 30))
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = .lpDeepBlue
        titleLabel.text = sections[section]
        header.addSubview(titleLabel)
        
        return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if items?.isEmpty == false, let array = items?[section] as? Array<Any> {
            return array.count
        }
        return 0
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.locationCalendarTableViewCellID, for: indexPath)!
        let array = items?[indexPath.section] as? Array<Any>
        let hours = array?[indexPath.row] as? Array<String>
        cell.titleLabel.text = hours?.first?.replacingOccurrences(of: "<br />", with: "", options: .literal, range: nil)
        cell.workingHoursLabel.text = hours?.last?.replacingOccurrences(of: ":", with: "h", options: .literal, range: nil)
        cell.workingHoursLabel.text = cell.workingHoursLabel.text?.replacingOccurrences(of: "-", with: " à ", options: .literal, range: nil)
        if hours?.last == "Fermé" {
            cell.workingHoursLabel.textColor = .red
        } else  {
            cell.workingHoursLabel.textColor = .lpGrey
        }
        return cell
    }
}

extension LocationCalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        if isToady(date: date) {
            return 1
        }
        return 0
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        if isToady(date: date) {
            cell.titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        }
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let cell = calendarView.cell(for: date, at: monthPosition)
        cell?.titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        setWorkingHours(for: date)
    }
    
    func setWorkingHours(for date: Date) {
//        locationMapViewModel.getPostOfficeDetails(codeSite: codeSite) { postOffice in
        if let horarires = postalOfficeHours {
            let openingHours = self.locationMapViewModel.getWorkingHours(for: horarires, date: date)
            self.items = Array<Any>()
            if openingHours.0 != nil {
               self.items?.append(openingHours.0!)
            }
            else {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEEE dd MMMM yyyy"
                self.items?.append([[dateFormatter.string(from: date).capitalized, "Fermé"]])
            }
            if openingHours.1 != nil {
              self.items?.append(openingHours.1!)
            }
            self.tableView.reloadData()
        }
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        //TODO set maximum
        let date: Date!
        let calendar = Calendar.current
        if let horarires = postalOfficeHours {
            if (self.locationMapViewModel.getLastDayDate(in: horarires) != Date()) {
                date = self.locationMapViewModel.getLastDayDate(in: horarires)
            } else {
                date = calendar.date(byAdding: .month, value: 3, to: Date())
            }
        } else {
            date = calendar.date(byAdding: .month, value: 3, to: Date())
        }
        return date!
    }
    
}

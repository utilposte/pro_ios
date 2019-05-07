//
//  LocationDetailHoursViewController.swift
//  LaPostePro
//
//  Created by Issam DAHECH on 04/10/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

class LocationDetailHoursViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var periodLabel: UILabel!
    @IBOutlet weak var exeptionalClosedLabel: UILabel!
    
    let daysArray = ["lundi","mardi","mercredi","jeudi","vendredi","samedi","dimanche"]
    var retrieveDepotHours: [Any]?
    var daysHours : [String : AnyObject]?
    var typeTag : String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpData()
        // Do any additional setup after loading the view.
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func setUpData() {
        if let data = retrieveDepotHours?.first as? [String : AnyObject]  {
            if let closure = data["fermeture"] as? [String] {
                var closureText = ""
                for text in closure {
                    closureText = closureText + text + "\n"
                }
                if closureText != "" {
                    closureText.remove(at: closureText.index(before: closureText.endIndex))
                }
                exeptionalClosedLabel.text = closureText
            }
            if let periode = data["periode"] as? [String : AnyObject]  {
                if let begin = periode["debut"] as? String, let end = periode["fin"] as? String {
                    periodLabel.text = "  Période du \(self.castedDate(begin)) à \(self.castedDate(end))  "
                }
            }
            daysHours = data["jours"] as? [String : AnyObject]
            tableView.dataSource = self
            tableView.reloadData()
        }
    }
    
    private func castedDate(_ date : String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        if let showDate = inputFormatter.date(from: date) {
            inputFormatter.dateFormat = "dd/MM/yyyy"
            let resultString = inputFormatter.string(from: showDate)
            return resultString
        }
        return ""
    }
    
    // MARK: - IBAction
    @IBAction func dismissClicked(_ sender: Any) {
        self.dismissLeftTransition()
    }
}

extension LocationDetailHoursViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.locationDetailCalendarHoursCellID , for: indexPath)
        cell?.dayLabel.text = daysArray[indexPath.row].capitalized
        if let hours = daysHours?[daysArray[indexPath.row]] as? [String]{
            cell?.setUpCell(data: hours)
        }
        else {
            cell?.setUpCell(data: [String]())
        }
        return cell ?? UITableViewCell()
    }

    
}

//
//  LocationFilterViewController.swift
//  LaPostePro
//
//  Created by Mohamed Helmi Ben Jabeur on 02/08/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

protocol LocationFilterDelegate {
    func hourFilterButtonClicked()
    func filterSelected()
}
class LocationFilterViewController: BaseViewController {

    //IBOUTLETS
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var hoursPickerViewTabBar: UIView!
    @IBOutlet weak var hoursPickerView: UIPickerView!
    
    //PROPRETIES
    let viewModel = LocationFilterViewModel()
    var resetButton = UIBarButtonItem()
    var filterType: FilterType?
    var delegate: LocationDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //NAVIGATION BAR
        self.setupTitleNavigationBar(backEnabled: true, title: "Filtrer")
        self.navigationItem.rightBarButtonItem = nil
        resetButton = UIBarButtonItem(title: "Effacer tout", style: UIBarButtonItemStyle.plain, target: self, action: #selector(LocationFilterViewController.resetFilter))
        
        //TABLE VIEW
        tableView.delegate = self
        tableView.dataSource = self
        
        //UIPICKERVIEW FOR HOURS LIST
        hoursPickerView.dataSource = self
        hoursPickerView.delegate = self
        
        //RESET BUTTON
        if viewModel.hideResetButton() {
            self.navigationItem.rightBarButtonItem = nil
        } else {
            setupResetButton()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // ATInternet
        ATInternetTaggingManager.sharedManager.sendTrackPage(pageName: TaggingData.kFiltredTypePoint,
                                                             chapter1: nil,
                                                             chapter2: nil,
                                                             level2: TaggingData.kLocaliseLevel)
        
    }
    
    override func viewDidLayoutSubviews() {
        tableView.reloadData()
        applyButton.cornerRadius = applyButton.frame.height / 2
    }
    
    
    @IBAction func applyButtonClicked(_ sender: Any) {
        // ATInternet
        ATInternetTaggingManager.sharedManager.sendTrackClick(clickLibelle: TaggingData.kAppliquer,
                                                              pageName: TaggingData.kFiltredTypePoint,
                                                              chapter1: nil,
                                                              chapter2: nil,
                                                              level2: TaggingData.kLocaliseLevel)
        
        
        let pointType = viewModel.getPointTypeFilterValue(type: filterType!, index: getSelectedPointType())
        let day = viewModel.getDayFilterValue(index: getSelectedDay())
        let hour = viewModel.getHourFilterValue(index: getSelectedHour())
        delegate?.applyFilter(pointType: pointType, day: day, hour: hour)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func resetFilter() {
        for i in 0 ..< 3 {
            switch i {
            case 2:
                let cell = tableView.cellForRow(at: IndexPath(item: i, section: 0)) as! LocationFilterListTableViewCell
                cell.resetContent()
            default:
                let cell = tableView.cellForRow(at: IndexPath(item: i, section: 0)) as! LocationFilterTableViewCell
                cell.resetContent()
            }
        }
        self.navigationItem.rightBarButtonItem = nil
    }
  
    @IBAction func hoursPickerViewTabBarValidateButtonClicked(_ sender: Any) {
        let cell = tableView.cellForRow(at: IndexPath(item: 2, section: 0)) as? LocationFilterListTableViewCell
        cell?.hourButton.setTitle(Constants.hoursList[hoursPickerView.selectedRow(inComponent: 0)], for: .normal)
        cell?.itemSelectedIndex = hoursPickerView.selectedRow(inComponent: 0)
        self.hoursPickerViewTabBarCancelButtonClicked(sender)
        self.filterSelected()
    }
    
    @IBAction func hoursPickerViewTabBarCancelButtonClicked(_ sender: Any) {
        UIView.animate(withDuration: 0.2) {
            self.hoursPickerView.isHidden = true
            self.hoursPickerViewTabBar.isHidden = true
        }
    }
    
    private func getSelectedPointType() -> Int {
        let cell = tableView.cellForRow(at: IndexPath(item: 0, section: 0)) as! LocationFilterTableViewCell
        return cell.itemSelectedIndex
    }
    
    private func getSelectedDay() -> Int {
        let cell = tableView.cellForRow(at: IndexPath(item: 1, section: 0)) as! LocationFilterTableViewCell
        return cell.itemSelectedIndex
    }
    
    private func getSelectedHour() -> Int {
        let cell = tableView.cellForRow(at: IndexPath(item: 2, section: 0)) as! LocationFilterListTableViewCell
        return cell.itemSelectedIndex
    }
}

extension LocationFilterViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 3:
            return 70
        default:
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LocationFilterTableViewCell", for: indexPath) as! LocationFilterTableViewCell
            cell.itemSelectedIndex = viewModel.pointTypeSelectedValue
            cell.setup(with: filterType!)
            cell.delegate = self
             return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LocationFilterTableViewCell", for: indexPath) as! LocationFilterTableViewCell
            cell.itemSelectedIndex = viewModel.daySeletedValue
            cell.setup(with: .day)
            cell.delegate = self
             return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LocationFilterListTableViewCell", for: indexPath) as! LocationFilterListTableViewCell
            cell.itemSelectedIndex = viewModel.hourSelectedValue
            cell.setupCell()
            cell.delegate = self
            return cell
        default:
            let cell = UITableViewCell()
            return cell
        }
       
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
}

extension LocationFilterViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Constants.hoursList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Constants.hoursList[row]
    }
}

extension LocationFilterViewController: LocationFilterDelegate {
    func hourFilterButtonClicked() {
        UIView.animate(withDuration: 0.2) {
            self.hoursPickerView.isHidden = false
            self.hoursPickerViewTabBar.isHidden = false
        }
    }
    
    func filterSelected() {
        var resetButtonHidden = true
        for i in 0 ..< 3 {
            switch i {
            case 2:
                let cell = tableView.cellForRow(at: IndexPath(item: i, section: 0)) as! LocationFilterListTableViewCell
                if cell.itemSelectedIndex != 0 {
                    resetButtonHidden = false
                    break
                }
            default:
                let cell = tableView.cellForRow(at: IndexPath(item: i, section: 0)) as! LocationFilterTableViewCell
                if cell.itemSelectedIndex != 0 {
                    resetButtonHidden = false
                    break
                }
            }
        }
        if resetButtonHidden {
            self.navigationItem.rightBarButtonItem = nil
        } else {
            setupResetButton()
        }
    }
    
    private func setupResetButton() {
        resetButton.setTitleTextAttributes([
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15, weight: .regular),
            NSAttributedStringKey.foregroundColor: UIColor.lpGrey],
                                           for: .normal)
        self.navigationItem.rightBarButtonItem = resetButton
    }
    
    func setFilterSelected(pointType: Int, day: Int, hour: Int) {
        viewModel.daySeletedValue = day
        viewModel.hourSelectedValue = hour
        viewModel.pointTypeSelectedValue = pointType
    }
}

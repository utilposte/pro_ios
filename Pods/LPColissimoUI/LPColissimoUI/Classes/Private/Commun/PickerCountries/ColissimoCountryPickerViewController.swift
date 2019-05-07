//
//  ColissimoCountryPickerViewController.swift
//  LPColissimoUI
//
//  Created by Issam DAHECH on 27/10/2018.
//

import UIKit
import LPColissimo


enum PickerType {
    case empty
    case departure
    case arrival
}

class ColissimoCountryPickerViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var validateButton: UIButton!
    @IBOutlet weak var countryPickerView: UIPickerView!
    
    // MARK: - Variable
    var presenter : ColissimoHomePresenter?
    var countries = [CLCountry]()
    var type = PickerType.empty {
        didSet {
            reloadPicker()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func reloadPicker() {
        if let result = self.presenter?.getCountriesWithType(type: type) {
            countries = result
            
            countryPickerView.reloadAllComponents()
            countryPickerView.selectRow(0, inComponent: 0, animated: false)
        }
    }
    
    // MARK: - IBAction
    @IBAction func dismissPickerView(_ sender: Any) {
        presenter?.dismissPickerView()
    }
    @IBAction func validateButtonClicked(_ sender: Any) {
        if countries.count > 0 {
            let country = countries[countryPickerView.selectedRow(inComponent: 0)]
            presenter?.selectCountryWithType(country: country, type: type)
        }
    }
    
}

extension ColissimoCountryPickerViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countries.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let country = countries[row]
        return country.name
    }
    
}

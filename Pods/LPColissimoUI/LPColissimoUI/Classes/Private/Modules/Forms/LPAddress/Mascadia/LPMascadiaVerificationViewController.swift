//
//  LPMascadiaVerificationViewController.swift
//  RefonteFormulaire
//
//  Created by Sofien Azzouz on 19/01/2018.
//  Copyright © 2018 Sofien Azzouz. All rights reserved.
//

import LPColissimo

public class LPMascadiaVerificationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var selectedAddressIndex = 0
    
    @IBOutlet var addressEntredByUserLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var addressView: UIView!
    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var alertImageView: UIImageView!
    @IBOutlet var continueButton: UIButton!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var keepEntryHeightConstraint: NSLayoutConstraint!
    @IBOutlet var selectPropositionLabel: UILabel!
    @IBOutlet var keepEntryButton: UIButton!
    @IBOutlet var editEntryButton: UIButton!
    
    @IBOutlet weak var descisionDetailLabel: UILabel!
    
    @IBOutlet weak var closeButton: UIButton!
    //header
    var descriptionImageView : UIImage!
    var descriptionViewName : String!
    @IBOutlet weak var logoImageViewWidthConstraint: NSLayoutConstraint!
    
    var addresses = [Any]()
    @objc public var lpAddress = LPAddressEntity()
    
    var isShowKeepEntryButton = false
    var addressText = ""
    var themeColor: UIColor!
    var trackingDelegate : LPAddressTrackingProtocol!
    var addressDelegate: LPAddressDelegate?
    var localityAndPostalCodeMascadiaOK = false
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.closeButton.setImage(ColissimoHomeServices.loadImage(name: "app-reex-ico-close.png"), for: .normal)
        self.keepEntryButton.layer.cornerRadius = 5
        self.keepEntryButton.layer.borderWidth = 1.0
        self.keepEntryButton.layer.borderColor = themeColor.cgColor
        self.keepEntryButton.clipsToBounds = true
        self.editEntryButton.layer.cornerRadius = 5
        self.editEntryButton.layer.borderWidth = 1.0
        self.editEntryButton.clipsToBounds = true
        self.addressView.layer.cornerRadius = 10
        self.addressView.clipsToBounds = true
        self.continueButton.layer.cornerRadius = 10
        self.continueButton.clipsToBounds = true
        
        self.title = "Vérification"
        
        if self.addresses.count == 0 {
            if self.localityAndPostalCodeMascadiaOK == false {
                self.keepEntryHeightConstraint.constant = 0
            }
            selectPropositionLabel.isHidden = true
            self.continueButton.isHidden = true
            self.view.updateConstraintsIfNeeded()
        }
        
        
        addressText = addressText + self.lpAddress.street + "\n"
        if lpAddress.complementaryAddress != "" {
            addressText = addressText + lpAddress.complementaryAddress + "\n"
        }
        addressText = addressText + lpAddress.postalCode + " "
        addressText = addressText + self.lpAddress.locality + "\n"
        addressText = addressText + self.lpAddress.countryName
        
        
        self.addressEntredByUserLabel.text = addressText.uppercased()
        self.addressEntredByUserLabel.adjustsFontSizeToFitWidth = true
        self.addressEntredByUserLabel.textColor = themeColor
        self.keepEntryButton.setTitleColor(themeColor, for: .normal)
        self.editEntryButton.layer.borderColor = themeColor.cgColor
        self.editEntryButton.setTitleColor(themeColor, for: .normal)
        
        self.alertImageView.image = UIImage(named: "app-reex-ico-adr-alert-gr")
        
        self.titleLabel.text = descriptionViewName
        if descriptionImageView != nil {
            self.logoImageView.image = descriptionImageView
        } else {
            logoImageViewWidthConstraint.constant = 0
        }
        if addresses.count == 0 {
            self.descisionDetailLabel.text = Constant.sharedInstance.sacadiaDecisionLabelForNoPropositions
        }
        
        // Utils.editImage(withColor: self.alertImageView, color: themeColor)
        
        self.continueButton.backgroundColor = themeColor
        
        //tracking
        if self.trackingDelegate != nil {
            self.trackingDelegate.sendGenericSarcadiaViewControllerDisplayed()
        }
        
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // ATInternet
        ATInternetTaggingManager.sharedManager.sendTrackPage(pageName: TaggingData.kSercadia,
                                                             chapter1: TaggingData.kChapter1,
                                                             chapter2: TaggingData.kChapter2,
                                                             chapter3: nil,
                                                             level2: TaggingData.kColissimoLevel)
    }
    
    // MARK: uitableview
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addresses.count
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LPMascadiaAddressCell") as? LPMascadiaAddressCell
        cell?.selectionStyle = .none
        let isChecked: Bool = self.selectedAddressIndex == Int(indexPath.row)
        if self.addresses.count == 1 {
            cell?.setup(withAddress: self.addresses[indexPath.row] as? [AnyHashable : Any], order: LPSarcadiaAddressCellAlone, isChecked: isChecked, color: themeColor)
        } else if indexPath.row == 0 {
            cell?.setup(withAddress: self.addresses[indexPath.row] as? [AnyHashable : Any], order: LPSarcadiaAddressCellFirst, isChecked: isChecked, color: themeColor)
        } else if self.addresses.count == (indexPath.row + 1) {
            cell?.setup(withAddress: self.addresses[indexPath.row] as? [AnyHashable : Any], order: LPSarcadiaAddressCellLast, isChecked: isChecked, color: themeColor)
        } else {
            // middle cell
            cell?.setup(withAddress: self.addresses[indexPath.row] as? [AnyHashable : Any], order: LPSarcadiaAddressCellMiddle, isChecked: isChecked, color: themeColor)
        }
        return cell!
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedAddressIndex = Int(indexPath.row)
        self.tableView.reloadData()
    }
    
    // MARK: action
    @IBAction func modifyAddressButtonClicked(_ sender: Any) {
        //tracking
        if self.trackingDelegate != nil {
            self.trackingDelegate.sendModifyingAddressAction()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func continuerButtonClicked(_ sender: Any) {
        // APPMOB-2650: REMOVE LIGNE 3 (WITH COMPLIMENTARY ADDRESS) FROM THE CURRENTLY SELECTED ADDRESS
        var newAddress = addresses[selectedAddressIndex] as! [AnyHashable : Any]
        newAddress.removeValue(forKey: "ligne3")
        addresses[0] = newAddress
        
        let mcmUserAddress = LPAddressValidationService.createMCMUser(fromMascadiaAddress: self.addresses[selectedAddressIndex] as! [String : Any], lpAddress: self.lpAddress)
        
        self.lpAddress.street = (mcmUserAddress?.street)!
        self.lpAddress.complementaryAddress = (mcmUserAddress?.floor) ?? ""
        self.lpAddress.postalCode = (mcmUserAddress?.postalCode)!
        self.lpAddress.locality = (mcmUserAddress?.locality)!
        self.lpAddress.countryName = (mcmUserAddress?.countryName)!
        self.lpAddress.countryIsoCode = (mcmUserAddress?.countryIsoCode)!
        
        //tracking
        if self.trackingDelegate != nil {
            self.trackingDelegate.sendKeepAddressEntredAction()
        }
        self.dismissModalStack()
    }
    
    @IBAction func keepEntryButtonClicked(_ sender: Any) {
        self.dismissModalStack()
    }
    
    func dismissModalStack() {
        if self.addressDelegate != nil {
            self.dismiss(animated: false) {
                self.addressDelegate?.didValidateFormButtonClicked(address: self.lpAddress)
            }
        } else {
            self.performSegue(withIdentifier: kUnwindFromMascadiaVC, sender: nil)
        }
    }
}

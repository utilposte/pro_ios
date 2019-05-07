//
//  MascadiaVerificationViewController.swift
//  LaPostePro
//
//  Created by Mohamed Helmi Ben Jabeur on 09/10/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

protocol MascadiaViewControllerDelegate: class {
    func keepAddress()
    func chooseAddress(_ address: AddressMascadia)
}

class MascadiaVerificationViewController: UIViewController {

    @IBOutlet weak var addressListDescriptionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editAddressButton: UIButton!
    @IBOutlet weak var addressToVerifyLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    weak var delegate: MascadiaViewControllerDelegate?
    
    let viewModel = MascadiaVerificationViewModel()
    private var cellSelectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
        addressToVerifyLabel.text = viewModel.getAddressToVerify()
        
        tableView.dataSource = self
        tableView.delegate = self
    }

    @IBAction func closeButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func editAddressButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func continueButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        delegate?.chooseAddress(viewModel.mascadiaAddressArray[cellSelectedIndex])
    }
    
    private func setupButtons() {
        continueButton.cornerRadius = continueButton.frame.height / 2
        editAddressButton.cornerRadius = editAddressButton.frame.height / 2
        editAddressButton.layer.borderColor = UIColor.lpPurple.cgColor
        editAddressButton.layer.borderWidth = 1
        
        if (viewModel.mascadiaAddressArray.count == 0) {
            continueButton.isHidden = true
            addressListDescriptionLabel.isHidden = true
        }
    }
}


extension MascadiaVerificationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.mascadiaAddressArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MascadiaAddressCell", for: indexPath) as! MascadiaAddressTableViewCell
        cell.setupCell(with: viewModel.mascadiaAddressArray[indexPath.row], isSelected: cellSelectedIndex == indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellSelectedIndex = indexPath.row
        tableView.reloadData()
    }
    
}

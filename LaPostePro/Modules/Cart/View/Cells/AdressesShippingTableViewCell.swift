//
//  AdressesShippingTableViewCell.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 18/07/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

protocol AdressesShippingTableViewCellDelegate: class {
    func tableViewCellTapped(indexPath: IndexPath)
}

class AdressesShippingTableViewCell: UITableViewCell {
    
    weak var delegate: AdressesShippingTableViewCellDelegate?
    
    enum AddressTableView {
        case address(address: DeliveryAddress)
        case addAddress
        case noAddress
        
        var cellIdentifier: String {
            switch self {
            case .address:
                return "AddressShippingTableViewCellID"
            case .noAddress:
                return "EmptyAdressShippingTableViewCellID"
            case .addAddress:
                return "AddAddressTableViewCellID"
            }
        }
        
        var rowHeight: CGFloat {
            switch self {
            case .address:
                return 150
            case .addAddress:
                return 60
            case .noAddress:
                return 0
            }
        }
    }
    
    var sections = [AddressTableView]()
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var addressesTableView: UITableView!
    @IBOutlet weak var chooseAddressLabel: UILabel!
    @IBOutlet weak var shippingLabelHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.addressesTableView.separatorStyle = .none
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func setupTableViewCell(addresses: [DeliveryAddress]) {
        self.sections.removeAll()
        if addresses.count > 0 {
            self.shippingLabelHeight.constant = 0
            addresses.forEach { (address) in
                self.sections.append(.address(address: address))
            }
//            self.sections.append(.addAddress)
            self.chooseAddressLabel.isHidden = true
            self.layoutIfNeeded()
        } else {
            self.shippingLabelHeight.constant = 0
            self.layoutIfNeeded()
            self.chooseAddressLabel.isHidden = true
//            self.sections.append(.noAddress)
            self.sections.append(.addAddress)
//            self.containerView.layer.cornerRadius = 5
//            self.containerView.layer.borderWidth = 1
//            self.containerView.layer.borderColor = UIColor.lpGrayShadow.cgColor
        }

        self.addressesTableView?.delegate = self
        self.addressesTableView?.dataSource = self
        self.addressesTableView?.isScrollEnabled = false
        self.addressesTableView?.reloadData()
    }
}

extension AdressesShippingTableViewCell: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.sections[indexPath.row]
        switch item {
        case .address(let address):
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! AddressShippingTableViewCell
            cell.setupAddressCell(address: address)
            return cell
        case .noAddress:
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! EmptyAdressShippingTableViewCell
            return cell
        case .addAddress:
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! AddAddressTableViewCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.tableViewCellTapped(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.sections[indexPath.row].rowHeight
    }
}

//
//  ReexCartDetailViewController.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 27/03/2019.
//  Copyright © 2019 App Mobile. All rights reserved.
//

import UIKit

class ReexCartDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    enum ColissimoCart {
        case image(image: String)
        case title(title: String, firstDate: String, secondDate: String, price: String, duration: Int, isDefinitve: Bool)
        case address(title: String, address: ReexAddress)
        case contract(title: String, contract: String)
        
        var cellIdentifier: String {
            switch self {
            case .image:
                return "ProductCartImageTableViewCellID"
            case .title:
                return "CartReexTitleTableViewCellID"
            case .address:
                return "ProductCartAddressTableViewCellID"
            case .contract:
                return "CartReexContractTableViewCellID"
            }
        }
        
        var rowHeight: CGFloat {
            switch self {
            case .image:
                return 250
            case .title:
                return UITableViewAutomaticDimension
            case .contract:
                return UITableViewAutomaticDimension
            case .address:
                return UITableViewAutomaticDimension
            }
        }
    }
    
    var product: Product?
    var availableSection: [ColissimoCart] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Détails du contrat"
        self.setupTableView()
        self.setupSections()
    }

    func setupTableView() {
        self.tableView.bounces = false
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
    }
    
    private func setupSections() {
        // IMAGE WITH NAME
        
        guard let optionReex = self.product?.optionReex else { return }
        
        if optionReex.isInternational {
            self.availableSection.append(.image(image: "reex-monde"))
        } else {
            self.availableSection.append(.image(image: "reex-france"))
        }
        
        if let title = self.product?.getReexTitle(), let price = optionReex.price {
            self.availableSection.append(.title(title: title, firstDate: optionReex.startDate ?? "", secondDate: optionReex.endDate ?? "", price: price, duration: optionReex.duration, isDefinitve: optionReex.isDefinitive))
        }
        
        if let originAddress = optionReex.originAddress, let newAddress = optionReex.newAddress {
            self.availableSection.append(.address(title: "Adresse d'origine", address: originAddress))
            self.availableSection.append(.address(title: "Adresse de destination", address: newAddress))
        }
        
        if let companyName = UserAccount.shared.customerInfo?.companyName {
            self.availableSection.append(.contract(title: "Entreprise concernée par le contrat", contract: companyName))
        }
        
        let contractActivation : String = "Je confirme qu'une personne de l'entreprise sera en mesure de réceptionner cette lettre recommandée puis d'activer le contrat en ligne.\nPar ailleurs, je peux aussi contacter le service client pour activer mon contrat."
        self.availableSection.append(.contract(title: "Activation du contrat", contract: contractActivation))
        
        self.tableView.reloadData()
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ReexCartDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.availableSection.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.availableSection[indexPath.row]
        
        switch item {
        case .image(let image):
            let cell = self.tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! ProductCartImageTableViewCell
            cell.setupCell(image: image)
            return cell
        case .title(let title, let firstDate, let secondDate, let price, let duration, let isDefinitve):
            let cell = self.tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! CartReexTitleTableViewCell
            cell.setupCell(title: title, firstDate: firstDate, secondDate: secondDate, price: price, duration: duration, isDefinitve: isDefinitve)
            return cell
        case .contract(let title, let contract):
            let cell = self.tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! CartReexContractTableViewCell
            cell.setupCell(title: title, contract: contract)
            return cell
        case .address(let title, let address):
            let cell = self.tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! ProductCartAddressTableViewCell
            cell.setupCellReex(title: title, address: address)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = self.availableSection[indexPath.row]
        return item.rowHeight
    }
    
}

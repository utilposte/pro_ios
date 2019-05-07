//
//  ColissimoCartDetailViewController.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 25/03/2019.
//  Copyright © 2019 App Mobile. All rights reserved.
//

import UIKit
import LPSharedMCM

class ColissimoCartDetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var product: Product?
    
    enum ColissimoCart {
        case image(image: String)
        case title(title: String, price: String)
        case info(title: String, textColor: UIColor, bold: Bool)
        case address(title: String, address: HYBAddress?)
        case detail(title: String, detail: String?)
        
        var cellIdentifier: String {
            switch self {
            case .image:
                return "ProductCartImageTableViewCellID"
            case .title:
                return "ProductCartTitleTableViewCellID"
            case .address:
                return "ProductCartAddressTableViewCellID"
            case .detail:
                return "ProductCartColissimoDetailTableViewCellID"
            case .info:
                return "ProductCartInfoTableViewCellID"
            }
        }
        
        var rowHeight: CGFloat {
            switch self {
            case .image:
                return 250
            case .title:
                return 80
            default:
                return UITableViewAutomaticDimension
            }
        }
    }
    
    var availableSection: [ColissimoCart] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Détails"
        self.setupTableView()
        self.setupSections()
    }
    
    private func setupTableView() {
        self.tableView.bounces = false
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
    }
    
    private func setupSections() {
        // IMAGE WITH NAME
        self.availableSection.append(.image(image: "icon_colissimo"))
        
        guard let product = product, let optionColissimo = product.optionColissimo, let price = optionColissimo.totalNetPriceColis else { return }
        
        // TITLE COLISSIMO - TYPE AND PRICE
        self.availableSection.append(.title(title: "Colissimo \(optionColissimo.formatColis?.uppercased() ?? "STANDARD") - \(optionColissimo.weight ?? "-") KG", price: "\(price)"))
        
        // EXPEDITEUR
        self.availableSection.append(.address(title: "Adresse de l'expéditeur",address: optionColissimo.senderAddress))
        
        // DESTINATAIRE
        self.availableSection.append(.address(title: "Adresse du destinataire", address: optionColissimo.receiverAddress))
        
        // DEPOT
        self.availableSection.append(.detail(title: "Mode de dépôt", detail: product.getDeliveryModeString()))
        
        // LIVRAISON
        self.availableSection.append(.detail(title: "Mode de livraison", detail: product.getShippingModeString()))
        
        // INFO COLISSIMO
        self.availableSection.append(.info(title: "Comment imprimer depuis chez moi ?", textColor: UIColor.lpPurple, bold: true))
        self.availableSection.append(.info(title: "Vous n'avez pas d'imprimante ? Un code vous sera communiqué après l'achat pour que vous puissiez imprimer en bureau de poste !", textColor: UIColor.lpGrey, bold: false))
        self.availableSection.append(.info(title: "Le service de Colissimo n'est pas soumis à la TVA", textColor: UIColor.lpGrey, bold: false))
        
        self.tableView.reloadData()
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ColissimoCartDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        case .title(let title, let price):
            let cell = self.tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! ProductCartTitleTableViewCell
            cell.setupCell(title: title, price: price)
            return cell
        case .info(let info, let color, let bold):
            let cell = self.tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! ProductCartInfoTableViewCell
            cell.setupCell(info: info, color: color, bold: bold)
            return cell
        case .address(let title, let address):
            let cell = self.tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! ProductCartAddressTableViewCell
            cell.setupCell(title: title, address: address)
            return cell
        case .detail(let title, let detail):
            let cell = self.tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! ProductCartColissimoDetailTableViewCell
            cell.setupCell(title: title, detail: detail)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = self.availableSection[indexPath.row]
        return item.rowHeight
    }
    
}

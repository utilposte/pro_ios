//
//  ThemesViewController.swift
//  LaPostePro
//
//  Created by Lassad Tiss on 29/05/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

protocol ThemesViewControllerDelegate: class {
    func collectionViewShouldReload(class: ThemesViewController)
}

class ThemesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var productViewModel: ProductViewModel = ProductViewModel()

    weak var delegate: ThemesViewControllerDelegate?
    
    var selectedSort = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        (self.parent as! FiltersViewController).delegate = self
        self.tableView.reloadData()
    }

    private func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = 55
    }
}

extension ThemesViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CurrentFacet.shared.conditions.last?.choices?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "ThemesTableViewCellID", for: indexPath) as! ThemesTableViewCell
        let item = CurrentFacet.shared.conditions.last?.choices![indexPath.row]
        cell.selectionStyle = .none
        cell.themeLabel.text = item?.choiceName
        if (item?.isChecked)! {
            cell.isCheckedImage.tintImageColor(color: .lpPurple)
            cell.isCheckedImage.image = UIImage(named: "small-check")
        } else {
            cell.isCheckedImage.image = UIImage()
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = CurrentFacet.shared.conditions.count - 1

        let customIndexPath = IndexPath(row: indexPath.row, section: section)
        if CurrentFacet.shared.conditionsSelected.contains(customIndexPath) {
            if CurrentFacet.shared.deleteElementToConditionsSelected(indexPath: customIndexPath) {
                CurrentFacet.shared.changeStateOfCondition(indexPath: customIndexPath)
            }
        } else {
            // ADD FOR TOP COLLECTIONVIEW
            if CurrentFacet.shared.addElementToConditionsSelected(indexPath: customIndexPath) {
                CurrentFacet.shared.changeStateOfCondition(indexPath: customIndexPath)
            }
        }

        // REFRESH VIEWS
        self.tableView.reloadData()
        self.delegate?.collectionViewShouldReload(class: self)

        // CREATE QUERY FOR WEBSERVICES
        CurrentFacet.shared.createQuery()

        self.productViewModel.getProductListWithFilter(filter: String(format: Constants.defaultQueryProductList, selectedSort, "\((self.parent as! FiltersViewController).categoryID ?? ""):\(CurrentFacet.shared.queryFilterTmp)"), nextPageEnabled: false) { isSuccess, _ in
            if isSuccess {
                if let filterViewController = (self.parent as? FiltersViewController) {
                    filterViewController.filterButton.setTitle(CurrentFacet.shared.filterValue, for: .normal)
                }
            } else {
                let alertController: UIAlertController = UIAlertController(title: "Ooops", message: "An Error Occured", dismissActionTitle: "Fermer", dismissActionBlock: {})
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect.init(x: 0, y: self.tableView.frame.minY, width: self.tableView.frame.width, height: 60))
        view.backgroundColor = .white
        let titleHeader = UILabel(frame: CGRect.init(x: 20, y: 20, width: self.tableView.frame.width, height: 30))
        titleHeader.backgroundColor = .white
        titleHeader.text = "Thématiques"
        titleHeader.font = UIFont.boldSystemFont(ofSize: 18)
        view.addSubview(titleHeader)
        return view
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
}

extension ThemesViewController: FiltersViewControllerDelegate {
    func tableViewShouldReloadData() {
        self.tableView.reloadData()
    }
}

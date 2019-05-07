//
//  ConditioningViewController.swift
//  LaPostePro
//
//  Created by Lassad Tiss on 29/05/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import LPSharedMCM
import UIKit

protocol ConditioningViewControllerDelegate: class {
    func collectionViewShouldReload(class: ConditioningViewController)
}

class ConditioningViewController: UIViewController {
    @IBOutlet var tableView: UITableView!

    weak var delegate: ConditioningViewControllerDelegate?
    let sectionOpenDefault = 4
    var collabsedFilter: [Int: Bool] = [:]
    var viewModel: ConditionViewModel = ConditionViewModel()
    var productViewModel: ProductViewModel = ProductViewModel()
    let kHeaderChevronTag: Int = 2504
    let kHeaderTitleTag: Int = 4052
    var selectedSort = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.getFilters()
    }

    override func viewWillAppear(_ animated: Bool) {
        (self.parent as! FiltersViewController).delegate = self
        self.tableView.reloadData()
    }

    func setupTableView() {
        self.tableView.estimatedRowHeight = 0
        self.tableView.estimatedSectionHeaderHeight = 0
        self.tableView.estimatedSectionFooterHeight = 0
    }

    func getFilters() {
        self.tableView.reloadData()
    }

    func getFilterEnum(string: String) -> String {
        return filters.init(rawValue: string)?.realName ?? ""
    }
}

extension ConditioningViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return CurrentFacet.shared.conditions.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.collabsedFilter[section] == true || section < self.sectionOpenDefault {
            return 1
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 65
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let itemForSection = CGFloat(CurrentFacet.shared.conditions[indexPath.section].choices?.count ?? 0)
        let value = round(itemForSection / CGFloat(2)) * 70
        return value
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = .white
        let headerFrame = self.view.frame.size

        let titleLabel = UILabel(frame: CGRect(x: 20, y: 19, width: headerFrame.width - 40, height: 22))
        titleLabel.text = self.getFilterEnum(string: CurrentFacet.shared.conditions[section].categoryName ?? "")
        titleLabel.tag = kHeaderTitleTag + section
        header.addSubview(titleLabel)

        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        titleLabel.textColor = .lpDeepBlue

        if section >= self.sectionOpenDefault {
            let chevronImageView = UIImageView(frame: CGRect(x: headerFrame.width - 36, y: 26, width: 16, height: 9))
            chevronImageView.image = R.image.ic_dropdown()
            chevronImageView.tag = kHeaderChevronTag + section
            header.addSubview(chevronImageView)

            if self.collabsedFilter[section] == true {
                chevronImageView.transform = CGAffineTransform(rotationAngle: (180.0 * CGFloat(Double.pi)) / 180.0)
            } else {
                chevronImageView.transform = CGAffineTransform(rotationAngle: (0.0 * CGFloat(Double.pi)) / 180.0)
            }

            let bottomSeparator = UIView(frame: CGRect(x: 0, y: 60, width: headerFrame.width, height: 5))
            bottomSeparator.backgroundColor = UIColor(rgb: 0xF7F7F7)
            header.addSubview(bottomSeparator)

            header.tag = section
            let headerTapGesture = UITapGestureRecognizer()
            headerTapGesture.addTarget(self, action: #selector(CategoryViewController.sectionHeaderWasTouched(_:)))
            header.addGestureRecognizer(headerTapGesture)
        }

        return header
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.filterCell, for: indexPath)!
        cell.delegate = self
        cell.productArray = CurrentFacet.shared.conditions[indexPath.section].choices ?? []
        cell.currentSection = indexPath.section

        if indexPath.section % 2 == 0 {
            cell.sizeCell = SizeConditionCell.tall
        } else {
            cell.sizeCell = SizeConditionCell.small
        }

        cell.collectionView.reloadData()
        cell.collectionView.collectionViewLayout.invalidateLayout()
        return cell
    }

    @objc func sectionHeaderWasTouched(_ sender: UITapGestureRecognizer) {
        let headerView = sender.view!
        let section = headerView.tag
        let imageView = headerView.viewWithTag(kHeaderChevronTag + section) as? UIImageView ?? UIImageView()
        let titleLabel = headerView.viewWithTag(kHeaderTitleTag + section) as? UILabel ?? UILabel()

        if self.collabsedFilter[section] == true {
            self.collabsedFilter[section] = false
            self.tableViewCollapeSection(section, imageView: imageView, label: titleLabel)

        } else {
            self.collabsedFilter[section] = true
            self.tableViewExpandSection(section, imageView: imageView, label: titleLabel)
        }
    }

    func tableViewCollapeSection(_ section: Int, imageView: UIImageView, label: UILabel) {
        let sectionData: [ConditionChoice] = CurrentFacet.shared.conditions[section].choices ?? []
        collabsedFilter[section] = false
        if sectionData.isEmpty {
            return
        } else {
            UIView.animate(withDuration: 0.4, animations: {
                imageView.transform = CGAffineTransform(rotationAngle: (0.0 * CGFloat(Double.pi)) / 180.0)
            })
            var indexesPath = [IndexPath]()
            let index = IndexPath(row: 0, section: section)
            indexesPath.append(index)
            self.tableView?.beginUpdates()
            self.tableView?.deleteRows(at: indexesPath, with: UITableViewRowAnimation.none)
            self.tableView?.endUpdates()
        }
    }

    func tableViewExpandSection(_ section: Int, imageView: UIImageView, label: UILabel) {
        let sectionData: [ConditionChoice] = CurrentFacet.shared.conditions[section].choices ?? []
        if sectionData.isEmpty {
            self.collabsedFilter[section] = false
            return
        } else {
            UIView.animate(withDuration: 0.4, animations: {
                imageView.transform = CGAffineTransform(rotationAngle: (180.0 * CGFloat(Double.pi)) / 180.0)
            })
            var indexesPath = [IndexPath]()
            let index = IndexPath(row: 0, section: section)
            indexesPath.append(index)

            collabsedFilter[section] = true
            self.tableView?.beginUpdates()
            self.tableView?.insertRows(at: indexesPath, with: UITableViewRowAnimation.none)
            self.tableView?.endUpdates()
        }
    }
}

extension ConditioningViewController: FilterTableViewCellDelegate {
    func itemDidTapped(cell: FilterTableViewCell, indexPath: IndexPath, item: ConditionChoice) {
        // ADD OR DELETE CONDITION

        if CurrentFacet.shared.conditionsSelected.contains(indexPath) {
            if CurrentFacet.shared.deleteElementToConditionsSelected(indexPath: indexPath) {
                CurrentFacet.shared.changeStateOfCondition(indexPath: indexPath)
            }
        } else {
            // ADD FOR TOP COLLECTIONVIEW
            if CurrentFacet.shared.addElementToConditionsSelected(indexPath: indexPath) {
                CurrentFacet.shared.changeStateOfCondition(indexPath: indexPath)
            }
        }

        // REFRESH VIEWS
        self.tableView.reloadData()
        self.delegate?.collectionViewShouldReload(class: self)

        // CREATE QUERY FOR WEBSERVICES
        CurrentFacet.shared.createQuery()

        if let filterViewController = (self.parent as? FiltersViewController) {
            filterViewController.getProductListWithFilter()
        }

        // ATInternet
        let sortType = self.getFilterEnum(string: CurrentFacet.shared.conditions[indexPath.section].categoryName ?? "")
        ATInternetTaggingManager.sharedManager.sendTrackClick(clickLibelle: item.choiceName ?? "",
                                                              pageName: sortType, chapter1: TaggingData.kProductsList,
                                                              chapter2: TaggingData.kFiltre, level2: TaggingData.kCommerceLevel)
    }
}

extension ConditioningViewController: FiltersViewControllerDelegate {
    func tableViewShouldReloadData() {
        self.tableView.reloadData()
    }
}

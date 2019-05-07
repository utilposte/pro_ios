//
//  CategoryViewController.swift
//  LaPostePro
//
//  Created by Lassad Tiss on 23/05/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit
import Firebase

enum EBoutiqueEntries {
    case header
    case category
    case bestSales

    var rowHeight: CGFloat {
        switch self {
        case .header:
            return 278
        case .category:
            return 61
        case .bestSales:
            return 330
        }
    }
}

class CategoryViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    let footerView = FooterView().initFooterView()

    var categories: [Category] = []

    var eBoutiqueArray: [EBoutiqueEntries] = []
    var collabsedCategory: [Int: Bool] = [:]

    let kHeaderChevronTag: Int = 2504
    let kHeaderTitleTag: Int = 4052

    override func viewDidLoad() {
        super.viewDidLoad()
        getCategories()
        setupTableView()
        self.footerView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupLogoNavigationBar()
        // Clear Query for product filters
        CurrentFacet.shared.clearQuery()
        CurrentFacet.shared.clearQueryTmp()
        
        // ATInternet
        ATInternetTaggingManager.sharedManager.sendTrackPage(pageName: TaggingData.kCommerceHome,
                                                             chapter1: nil,
                                                             chapter2: nil,
                                                             level2: TaggingData.kCommerceLevel)
    }

    func getCategories() {

        let ref = Database.database().reference(withPath: "categories")
        eBoutiqueArray.append(.header)
        eBoutiqueArray.append(.bestSales)

        // Listen for new categories in the Firebase database
        ref.observe(.childAdded, with: { (snapshot) -> Void in
            if let category = Category(snapshot: snapshot) {
                self.categories.append(category)
                self.eBoutiqueArray.insert(.category, at: self.categories.count)
                self.categories.sort { $0.rank < $1.rank }
                self.tableView.reloadData()

            }
        })

        // Listen for deleted categories in the Firebase database
        ref.observe(.childRemoved, with: { (snapshot) -> Void in
            let index = self.indexOfCategory(snapshot: snapshot)
            self.categories.remove(at: index)
            self.eBoutiqueArray.remove(at: index+1)
            self.tableView.reloadData()
        })
    }
    
    func openSearch(str: String, animated: Bool = true) {
        let productListViewController = R.storyboard.eBoutique.productListViewControllerID()!
        productListViewController.categoryID = String(0)
        productListViewController.categoryName = "Search"
        productListViewController.searchString = str        
        
        self.navigationController?.pushViewController(productListViewController, animated: animated)
    }

    func indexOfCategory(snapshot: DataSnapshot) -> Int {
        var index = 0
        for  category in self.categories {
            if (snapshot.key == category.key) {
                return index
            }
            index += 1
        }
        return -1
    }

    func setupTableView() {
        // Fix tableview animation
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.register(UINib(nibName: "CarouselTableViewCell", bundle: nil), forCellReuseIdentifier: "CarouselTableViewCellID")
    }

}

extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return eBoutiqueArray.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if eBoutiqueArray[section] == .category {
            if collabsedCategory[section] == true {
                let category = categories[section - 1]
                return category.subCategories.count
            } else {
                return 0
            }
        } else {
            return 1
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if eBoutiqueArray[section] != .category {
            return 0
        }
        return 85.0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = eBoutiqueArray[indexPath.section] as EBoutiqueEntries
        return item.rowHeight
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let header = UIView()
        header.backgroundColor = .white
        let headerFrame = self.view.frame.size
        let category = categories[section-1]

        let categoryImageView = UIImageView(frame: CGRect(x: 20, y: 10, width: 60, height: 60))
        categoryImageView.contentMode = .scaleAspectFit
        categoryImageView.image = UIImage(named: category.image)
        header.addSubview(categoryImageView)

        let titleLabel = UILabel(frame: CGRect(x: 110, y: 29, width: headerFrame.width - 158, height: 22))
        titleLabel.text = category.key
        titleLabel.tag = kHeaderTitleTag + section
        header.addSubview(titleLabel)

        let chevronImageView = UIImageView(frame: CGRect(x: headerFrame.width - 36, y: 36, width: 16, height: 9))
        chevronImageView.image = R.image.ic_dropdown()
        chevronImageView.tag = kHeaderChevronTag + section
        header.addSubview(chevronImageView)

        if eBoutiqueArray[section] == .category && collabsedCategory[section] == true {
            titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
            titleLabel.textColor = .lpPurple
            chevronImageView.transform = CGAffineTransform(rotationAngle: (180.0 * CGFloat(Double.pi)) / 180.0)
        } else {
            titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
            titleLabel.textColor = .lpDeepBlue
            chevronImageView.transform = CGAffineTransform(rotationAngle: (0.0 * CGFloat(Double.pi)) / 180.0)
        }

        let bottomSeparator = UIView(frame: CGRect(x: 0, y: 80, width: headerFrame.width, height: 5))
        bottomSeparator.backgroundColor = UIColor(rgb: 0xF7F7F7)
        header.addSubview(bottomSeparator)

        header.tag = section
        let headerTapGesture = UITapGestureRecognizer()
        headerTapGesture.addTarget(self, action: #selector(CategoryViewController.sectionHeaderWasTouched(_:)))
        header.addGestureRecognizer(headerTapGesture)

        return header
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch eBoutiqueArray[indexPath.section] {

        case .header:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.categoryHeaderCellID, for: indexPath)!
            cell.openSearchClosure = {
                
                let navigationViewController = R.storyboard.search.instantiateInitialViewController()!
                let searchViewController = navigationViewController.viewControllers[0] as! SearchViewController
                searchViewController.searchType = .shop
                searchViewController.openerViewController = self
                self.present(navigationViewController, animated: true)
            }
            return cell

        case .category:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.categoryCellID, for: indexPath)!
            let category = categories[indexPath.section-1]
            let subCategory = category.subCategories[indexPath.row]
            cell.subCategoryLabel.text = subCategory.key

            if (category.subCategories.count - 1) == indexPath.row {
                cell.subCategoryLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
                cell.separatorView.backgroundColor = UIColor(rgb: 0xF7F7F7)
                cell.separatorHeight.constant = 5
            } else {
                cell.subCategoryLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
                cell.separatorView.backgroundColor = UIColor(rgb: 0xE1E3E5)
                cell.separatorHeight.constant = 1
            }
            return cell

        case .bestSales:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.carouselTableViewCellID, for: indexPath)!
            cell.delegate = self
            cell.currentSection = indexPath.row
            let bestSell = Module.init(contentType: .bestSellCarousel, items: getLastBuyProducts())
            cell.setupUpCell(with: bestSell)
            return cell
        }
    }
    
    func getLastBuyProducts() -> [Product] {
        var bestProducts = [Product]()
        FrandoleViewModel.sharedInstance.getProducts(for: FrandoleProducts.best.rawValue) { (products) in
            for product in products! {
                bestProducts.append(FrandoleViewModel.sharedInstance.getFrandoleProduct(for: product))
            }
        }
        return bestProducts
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if eBoutiqueArray[indexPath.section] == .category {
            let category = categories[indexPath.section-1]
            let subCategory = category.subCategories[indexPath.row]
            
            if let lastCategory = category.subCategories.last {
                if subCategory.key == lastCategory.key {
                    showProductList(for: subCategory.id, title: category.key)
                } else {
                    showProductList(for: subCategory.id, title: subCategory.key)
                }
            }
        }
    }

    func showProductList(for categoryId: Int, title: String) {
        let productListViewController = R.storyboard.eBoutique.productListViewControllerID()!
        productListViewController.categoryID = String(categoryId)
        productListViewController.categoryName = title
        navigationController?.pushViewController(productListViewController, animated: true)
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - Expand / Collapse Methods

    @objc func sectionHeaderWasTouched(_ sender: UITapGestureRecognizer) {
        let headerView = sender.view!
        let section    = headerView.tag
        let imageView = headerView.viewWithTag(kHeaderChevronTag + section) as? UIImageView
        let titleLabel = headerView.viewWithTag(kHeaderTitleTag + section) as? UILabel

        if (collabsedCategory[section] == true) {
            collabsedCategory[section] = false
            tableViewCollapeSection(section, imageView: imageView!, label: titleLabel!)

        } else {
            collabsedCategory[section] = true
            tableViewExpandSection(section, imageView: imageView!, label: titleLabel!)
        }

    }

    func tableViewCollapeSection(_ section: Int, imageView: UIImageView, label: UILabel) {
        let category = categories[section-1]
        collabsedCategory[section] = false
        if (category.subCategories.isEmpty) {
            return
        } else {
            label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
            label.textColor = .lpDeepBlue
            UIView.animate(withDuration: 0.4, animations: {
                imageView.transform = CGAffineTransform(rotationAngle: (0.0 * CGFloat(Double.pi)) / 180.0)
            })
            var indexesPath = [IndexPath]()
            for row in 0 ..< category.subCategories.count {
                let index = IndexPath(row: row, section: section)
                indexesPath.append(index)
            }
            self.tableView!.beginUpdates()
            self.tableView!.deleteRows(at: indexesPath, with: UITableViewRowAnimation.none)
            self.tableView!.endUpdates()
        }
    }

    func tableViewExpandSection(_ section: Int, imageView: UIImageView, label: UILabel) {
        let category = categories[section-1]
        if (category.subCategories.isEmpty) {
            collabsedCategory[section] = false
            return
        } else {
            label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
            label.textColor = .lpPurple
            UIView.animate(withDuration: 0.4, animations: {
                imageView.transform = CGAffineTransform(rotationAngle: (180.0 * CGFloat(Double.pi)) / 180.0)
            })
            var indexesPath = [IndexPath]()
            for row in 0 ..< category.subCategories.count {
                let index = IndexPath(row: row, section: section)
                indexesPath.append(index)
            }
            collabsedCategory[section] = true
            self.tableView!.beginUpdates()
            self.tableView!.insertRows(at: indexesPath, with: UITableViewRowAnimation.none)
            self.tableView!.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.indexPathsForVisibleRows?.last?.row {
            self.footerView.frame.size.height = FooterView.height
            self.footerView.layoutIfNeeded()
            self.tableView.tableFooterView = self.footerView
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (tableView.indexPathsForVisibleRows?.contains(IndexPath(row: 0, section: 0)))! {
            self.setupLogoNavigationBar()
        } else {
            self.setupSearchNavigationBar(text: "Rechercher un produit", delegate: self)
        }
    }
}

extension CategoryViewController : UISearchBarDelegate {
 
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        let navigationViewController = R.storyboard.search.instantiateInitialViewController()!
        let searchViewController = navigationViewController.viewControllers[0] as! SearchViewController
        searchViewController.searchType = .shop
        searchViewController.openerViewController = self
        self.present(navigationViewController, animated: true)
        return false
    }
    
}

extension CategoryViewController: CarouselTableViewCellDelegate, CartViewControllerDelegate {
    func showDetails(for product: Product) {
        ProductViewModel().getProduct(withID: product.id!) { (product) in
            guard let productViewController = R.storyboard.eBoutique.productViewControllerID() else { return }
            productViewController.productDetailViewModel.product = product
            self.navigationController?.pushViewController(productViewController, animated: true)
        }
    }
    
    func didCellTapped(indexPath: IndexPath, cell: CarouselTableViewCell) {
        let product = cell.module!.items![indexPath.row]
        showDetails(for: product)
    }
}


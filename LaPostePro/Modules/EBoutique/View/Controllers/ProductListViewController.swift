//
//  EboutiqueProductListViewController.swift
//  LaPostePro
//
//  Created by Mohamed Helmi Ben Jabeur on 22/05/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit
import LPSharedMCM

class ProductListViewController: BaseViewController {

    @IBOutlet weak var filterButtonIcon: UIImageView!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var productTotalCountLabel: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsets(top: 10, left: 15, bottom: 15, right: 10)
            layout.scrollDirection = .horizontal
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.collectionViewLayout = layout
            collectionView.reloadData()
            collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    
    @IBOutlet weak var sortLabel: UILabel!
    @IBOutlet weak var sortView: UIView!
    @IBOutlet weak var sortViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var sortViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var sortingTableView: UITableView!
    
    var sortingArray = [HYBSort]()
    let sortingDefaultType = "relevance"
    var selectedSort = ""
    
    // MARK: catgory id for category selected used in web service
    var categoryID: String?
    var categoryName: String?

    // MARK: view model instance
    let productViewModel = ProductViewModel()

    // MARK: used for checking scroll up and down and displaying header view with filter and sorts
    var lastContentOffset: CGFloat = 0

    //cart view model to use if user add to cart
    var cartViewModel: CartViewModel?

    var isAnimatingHeader = false

    let footerView = FooterView().initFooterView()
    

    var searchString = ""

    //for weborama tag
    let weboramaManager = PixelWeboramaManager()


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !CurrentFacet.shared.queryFilter.isEmpty {
            productViewModel.resetToApplyFilter()
        }
        self.loadProducts(sort: selectedSort)
        self.adjustHashTagCollectionView()
        self.setupCollectionView()
        self.collectionView.reloadData()
        self.tableView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !CurrentFacet.shared.queryFilter.isEmpty {
            filterButtonIcon.image = R.image.fullFilter()
        }

        // ATInternet
        ATInternetTaggingManager.sharedManager.sendTrackPage(pageName: self.categoryID!,
                                                             chapter1: TaggingData.kProductsList,
                                                             chapter2: self.categoryName,
                                                             level2: TaggingData.kCommerceLevel)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let categoryName = self.categoryName {
            self.setupTitleNavigationBarListProduct(backEnabled: true, title: categoryName)
        } else {
            self.setupTitleNavigationBarListProduct(backEnabled: true, title: "")
        }
        self.applySearch()
        
        tableView.delegate = self
        tableView.dataSource = self
        //set tableview footer
        self.footerView.frame.size.height = FooterView.height
        self.footerView.layoutIfNeeded()
        self.tableView.tableFooterView = self.footerView

        guard self.categoryID != nil else {
            return
        }

        //metode to load product when starting view controller
        CurrentFacet.shared.clearConditions()
        CurrentFacet.shared.clearConditionsSelected()
        //load product when starting view controller
        self.adjustHashTagCollectionView()
        self.setupCollectionView()
        
        setupSortView()
        selectedSort = sortingDefaultType
        //sortingArray = ["Pertinence", "Meilleures ventes", "Prix croissant", "Prix décroissant", "Nouveautés", "Noms de A-Z", "Noms de Z-A"]
        
        
        //Send weborama tag
        let ccuId = UserAccount.shared.customerInfo?.displayUid?.sha256() ?? ""
        let key = weboramaManager.getKey(from: categoryID!, and: .vis)
        weboramaManager.sendWeboramaTag(tagToSend: key, ccuIDCryptedValue: ccuId)
        
        footerView.delegate = self
    }

    private func adjustHashTagCollectionView() {
        if CurrentFacet.shared.conditionsSelected.isEmpty {
            self.collectionViewHeightConstraint.constant = 0
        } else {
            self.collectionViewHeightConstraint.constant = 55
        }
    }

    fileprivate func loadProducts(sort: String) {
        if (!self.productViewModel.allProductsLoaded) {
            self.tableView.alwaysBounceVertical = false
            self.footerView.startLoading()
        }

        if CurrentFacet.shared.queryFilter.isEmpty {
            
            var query = String(format: Constants.defaultQueryProductList, sort, self.categoryID ?? "")
            if self.isSearch() {
                query = self.searchString + ":" + sort
            }
            self.productViewModel.getProductList(query: query) { reloadTableView, sorts in
                if reloadTableView {
                    self.sortingArray = self.productViewModel.getFormatted(sorts: sorts!)
                    self.sortingTableView.reloadData()
                    self.tableView.reloadData()
                }
                self.tableView.alwaysBounceVertical = true
                self.setProductTotalCountLabel()
                self.adjustHashTagCollectionView()
                self.setupCollectionView()
                self.collectionView.reloadData()
                self.footerView.finishLoading()
            }
        } else {
            let categoryIdWithFilterString = String(format: "%@:%@", self.categoryID ?? "", CurrentFacet.shared.queryFilter)
            var query = String(format: Constants.defaultQueryProductList, sort, categoryIdWithFilterString)
            if self.isSearch() {
                query = String(format: "%@:%@", (self.searchString + ":" + sort), CurrentFacet.shared.queryFilter)                
            }
            
            self.productViewModel.getProductList(query: query) { reloadTableView, sorts in
                if reloadTableView {
                    self.sortingArray = self.productViewModel.getFormatted(sorts: sorts!)
                    self.adjustHashTagCollectionView()
                    self.setupCollectionView()
                    self.collectionView.reloadData()
                    self.sortingTableView.reloadData()
                    self.tableView.reloadData()
                }
                self.setProductTotalCountLabel()
                self.footerView.finishLoading()
            }
        }
    }
    
    func setProductTotalCountLabel() {
        if self.isSearch() {
            self.productTotalCountLabel.text = "\(self.searchString) : \(self.productViewModel.getProductTotalCount())"
        }
        else {
            self.productTotalCountLabel.text = self.productViewModel.getProductTotalCount()
        }
        
        
    }

    @IBAction func filterButtonTapped(_ sender: Any) {
        let viewController = R.storyboard.eBoutique.filtersViewControllerID()!
        viewController.selectedSort = selectedSort
        viewController.hidesBottomBarWhenPushed = true
        let backItem = UIBarButtonItem()
        backItem.title = "Retour"
        navigationItem.backBarButtonItem = backItem
        viewController.categoryID = self.categoryID!
        viewController.searchString = self.searchString
        CurrentFacet.shared.filterValue = productViewModel.getProductTotalCountFormattedForFilter()
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    private func setupCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    func setupSortView() {
        sortViewHeightConstraint.constant = 0
        sortView.layer.applyShadow(color: .black, alpha: 0.15, x: 0, y: 5, blur: 20, spread: 0)
    }
    
    @IBAction func sortButtonTapped(_ sender: UIButton) {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideSortView))
        tap.delegate = self
        view.addGestureRecognizer(tap)
        sortViewHeightConstraint.constant = 336
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
     @objc func hideSortView() {
        sortViewHeightConstraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}

extension ProductListViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: sortView))! {
            return false
        }
        return true
    }
}

extension ProductListViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, ProductCellDelegate {
    func deleteProduct(product: Product) {
        
    }
    
    func addProductToCart(product: Product) {
        cartViewModel = CartViewModel.sharedInstance
        cartViewModel?.addProductToCart(product: product, quantityToAdd: 1, onCompletion: { (added, _) in
            if added {
                let toastConfiguration = Toast(title: "Produit ajouté au panier", titleColor: .white, backgroundColor: .lpPurple, viewController: self, duration: 2)
                let toast = ToastView()
                VibrationHelper.addToCart()
                toast.drawToast(toast: toastConfiguration)
                NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "update_cart")))
                
                if let categoryName = self.categoryName {
                    self.setupTitleNavigationBarListProduct(backEnabled: true, title: categoryName)
                } else {
                    self.setupTitleNavigationBarListProduct(backEnabled: true, title: "")
                }

                // ATInternet
                ATInternetTaggingManager.sharedManager.sendTrackClick(clickLibelle: TaggingData.kCtaAjoutPanier , pageName: nil, chapter1: TaggingData.kProductsList, chapter2: nil, level2: TaggingData.kCommerceLevel)
                
                // Adjust
                AdjustTaggingManager.sharedManager.trackEventToken(AdjustTaggingManager.kAddToCartToken)
                
                // Accengage
                
                AccengageTaggingManager().trackAddToCart(product: product)
                
                //Weborama tag
                let ccuId = UserAccount.shared.customerInfo?.displayUid?.sha256() ?? ""
                let key = self.weboramaManager.getKey(from: self.categoryID!, and: .vis)
                self.weboramaManager.sendWeboramaTag(tagToSend: key, ccuIDCryptedValue: ccuId)

            }
        })
    }
    
    func deleteProduct(product: ProductResponse) {
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == sortingTableView  {
            return sortingArray.count
        }
        return self.productViewModel.productList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == sortingTableView  {
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.sortingTableViewCellID, for: indexPath)!
            let sort = sortingArray[indexPath.row]
            cell.titleLabel.text = sort.name
            if sort.selected{
                cell.checkImageView.isHidden = false
                cell.titleLabel.textColor = .black
                cell.titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
            } else {
                cell.checkImageView.isHidden = true
                cell.titleLabel.textColor = .lpGrey
                cell.titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "productEboutiqueTableViewCellID") as! ProductListTableViewCell
            cell.delegate = self
            let product = productViewModel.getProductForCell(indexOfCell: indexPath)
            if product.imageUrl != nil {
                cell.configureCellWithProduct(product: product, productViewModel: self.productViewModel)
            }
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == sortingTableView  {
            return 48
        }
        return 155
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView == self.tableView {
            if indexPath.row == tableView.indexPathsForVisibleRows?.last?.row {
                self.footerView.frame.size.height = FooterView.height
                self.footerView.layoutIfNeeded()
                self.tableView.tableFooterView = self.footerView
            }
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tableView {
            self.productViewModel.getProduct(withID: self.productViewModel.productList[indexPath.row].code) { (product) in
                guard let productViewController = R.storyboard.eBoutique.productViewControllerID() else { return }
                productViewController.productDetailViewModel.product = product
                productViewController.productDetailViewModel.categoryId = self.categoryID
                self.navigationController?.pushViewController(productViewController, animated: true)
            }
        } else {
            let sort = sortingArray[indexPath.row]
            self.productViewModel.resetToApplyFilter()
            loadProducts(sort: sort.code)
            selectedSort = sort.code
            sortLabel.text = sort.name
            hideSortView()
            
            // ATInternet
            ATInternetTaggingManager.sharedManager.sendTrackClick(clickLibelle: sort.name , pageName: nil, chapter1: TaggingData.kProductsList, chapter2: TaggingData.kTri, level2: TaggingData.kCommerceLevel)
            
        }
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.lastContentOffset = scrollView.contentOffset.y
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let  height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom - 200 < height {
            self.loadProducts(sort: selectedSort)
        }
        if lastContentOffset > contentYoffset && self.headerViewHeightConstraint.constant == 0 {
            animateHeader(headerHeightConstraint: 155)
        }

        if contentYoffset > 100 && lastContentOffset < contentYoffset && !isAnimatingHeader {
            self.animateHeader(headerHeightConstraint: 0)
        }
    }

    func animateHeader(headerHeightConstraint: CGFloat) {
        if isAnimatingHeader {
            return
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.headerViewHeightConstraint.constant = headerHeightConstraint
            self.view.layoutIfNeeded()
            self.isAnimatingHeader = true
        }, completion: { (_) in
            self.isAnimatingHeader = false
        })
    }
}

extension ProductListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CurrentFacet.shared.conditionsSelected.count
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: HashTagCollectionViewCell = self.collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.hashTagCollectionViewCellID.identifier, for: indexPath) as! HashTagCollectionViewCell
        let item = CurrentFacet.shared.conditionsSelected[indexPath.row]
        var itemName = CurrentFacet.shared.conditions[item.section].choices![item.row].choiceName ?? ""
        //Change the text of the item only when the filtro is valeurPermanente
        if let sectionName = CurrentFacet.shared.conditions[item.section].categoryName,
            sectionName == filters.FILTER_VALEURPERMANENTE.rawValue,
            let choiseName = CurrentFacet.shared.conditions[item.section].choices![item.row].choiceName,
            let filterName = filters.init(rawValue: choiseName)?.realName {
            itemName =  filterName
        }
        cell.hashTagLabel.text = itemName
        cell.hashTagLabel.textColor = .white
        cell.hashTagLabel.font = UIFont.boldSystemFont(ofSize: 14)
        cell.contentView.backgroundColor = .lpPurple
        cell.contentView.layer.cornerRadius = 17.5
        cell.currentIndexPath = indexPath
        cell.delegate = self
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel()
        let item = CurrentFacet.shared.conditionsSelected[indexPath.row]
        label.text = CurrentFacet.shared.conditions[item.section].choices![item.row].choiceName
        return CGSize(width: label.intrinsicContentSize.width + 40, height: 35)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = CurrentFacet.shared.conditionsSelected.remove(at: indexPath.row)
        CurrentFacet.shared.conditions[item.section].choices![item.row].isChecked = false
        CurrentFacet.shared.createQuery()
        CurrentFacet.shared.queryFilter = CurrentFacet.shared.queryFilterTmp
        self.collectionView.reloadData()
        self.collectionView.collectionViewLayout.invalidateLayout()
        self.adjustHashTagCollectionView()
        self.productViewModel.resetToApplyFilter()
        self.loadProducts(sort: selectedSort)
    }
}

extension ProductListViewController: HashTagCollectionViewCellDelegate {
    func crossButtonDidTapped(indexPath: IndexPath) {
        let item = CurrentFacet.shared.conditionsSelected.remove(at: indexPath.row)
        CurrentFacet.shared.conditions[item.section].choices![item.row].isChecked = false
        CurrentFacet.shared.createQuery()
        CurrentFacet.shared.queryFilter = CurrentFacet.shared.queryFilterTmp
        self.collectionView.reloadData()
        self.collectionView.collectionViewLayout.invalidateLayout()
        self.adjustHashTagCollectionView()
        self.productViewModel.resetToApplyFilter()
        self.loadProducts(sort: selectedSort)
    }
}


// Search mode
extension ProductListViewController {
    
    func isSearch() -> Bool {
        return self.searchString != ""
    }
    
    func applySearch() {
        if self.isSearch() {
            self.setupTitleNavigationBarListProduct(backEnabled: true, title: "Recherche: \(self.searchString)")
            self.categoryID = self.searchString
        }
    }
}

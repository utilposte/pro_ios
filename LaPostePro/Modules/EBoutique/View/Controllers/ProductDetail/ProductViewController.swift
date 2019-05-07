//
//  ProductViewController.swift
//  LaPostePro
//
//  Created by Mohamed Helmi Ben Jabeur on 12/06/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit
import LPSharedMCM
import Alamofire
import RealmSwift

class ProductViewController: BaseViewController {

    enum ProductEnum: Equatable {
        case mainInfo
        case featureHeader
        case featureSmallSize(feature: ProductFeature)
        case featureBigSize(feature: ProductFeature)
        case longDescription(feature: ProductFeature, isCollapsed: Bool)
        case shareAndFavoris
        case carousel(module: Module)
        case addToCart
        case support
        case volumePrice
        case inFavorite
        
        var rowHeight: CGFloat {
            switch self {
            case .carousel:
                return 340
            case .support:
                return 90
            default:
                return UITableViewAutomaticDimension
            }
        }

        var cellIdentifier: String {
            switch self {
            case .mainInfo:
                return "ProductMainInfoTableViewCellID"
            case .addToCart:
                return "AddToCartTableViewCellID"
            case .featureHeader:
                return "FeatureHeaderTableViewCellID"
            case .featureBigSize:
                return "FeatureBigSizeTableViewCellID"
            case .featureSmallSize:
                return "FeatureSmallSizeTableViewCellID"
            case .longDescription:
                return "ProductLongDescriptionTableViewCellID"
            case .shareAndFavoris:
                return "ShareAndFavorisActionTableViewCellID"
            case .carousel:
                return "CarouselTableViewCellID"
            case .support:
                return "SupportTableViewCellID"
            case .volumePrice:
                return "ProductVolumePriceCell"
            case .inFavorite:
                return "ProductFavoriteTableViewCellID"
            }
        }
        
        static func ==(lhs: ProductEnum, rhs: ProductEnum) -> Bool {
            switch (lhs, rhs) {
            case (.mainInfo, .mainInfo), (.featureHeader, .featureHeader), (.shareAndFavoris, .shareAndFavoris),
                 (.addToCart,.addToCart), (.support, .support), (.volumePrice, .volumePrice), (.inFavorite, .inFavorite):
                return true
            case (let .featureSmallSize(feature1), let .featureSmallSize(feature2)):
                return feature1 == feature2
            case (let .featureBigSize(feature1), let .featureBigSize(feature2)):
                return feature1 == feature2
            case (let .longDescription(feature1, isCollapsed1), let .longDescription(feature2, isCollapsed2)):
                return feature1 == feature2 && isCollapsed1 == isCollapsed2
            case (let .carousel(module1), let .carousel(module2)):
                return module1 == module2
            default:
                return false
            }
        }
    }

    let productDetailViewModel = ProductDetailViewModel.init()
    var products = [Product]()
    var productIsFavorite: Bool = false
    var descriptionisCollapsed: Bool = true
    let footerView = FooterView().initFooterView()
    @IBOutlet weak var tableView: UITableView!
    var cellArray = [ProductEnum]()
    var featureArray = [ProductFeature]()
    lazy var loaderManager = LoaderViewManager()
    //var indexPath: IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTitleNavigationBar(backEnabled: true, title: productDetailViewModel.getProductName())
        configureTableView()
        footerView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        // ATInternet
        ATInternetTaggingManager.sharedManager.sendTrackPage(pageName: productDetailViewModel.getProductName(),
                                                             chapter1: TaggingData.kProductDetails,
                                                             chapter2: nil,
                                                             level2: TaggingData.kCommerceLevel)
    }

    private func configureTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.footerView.frame.size.height = FooterView.height
        self.footerView.layoutIfNeeded()
        self.tableView.tableFooterView = self.footerView
        self.tableView.register(UINib(nibName: "CarouselTableViewCell", bundle: nil), forCellReuseIdentifier: "CarouselTableViewCellID")
        
        let realm = try! Realm()
        if let product = self.productDetailViewModel.product, let codeProduct = product.code {
            let productExist = realm.objects(ProductFavorite.self).filter("productCode = '\(codeProduct)'")
            self.productIsFavorite = !productExist.isEmpty
        }
        
        self.getTableViewCells(features: self.productDetailViewModel.createSmallListFeatures())
    }
    
    func getProducts(for frandole: FrandoleProducts) -> [Product] {
        var productList = [Product]()
        FrandoleViewModel.sharedInstance.getProducts(for: frandole.rawValue) { (products) in
            if let _products = products {
                for product in _products {
                    productList.append(FrandoleViewModel.sharedInstance.getFrandoleProduct(for: product))
                }
            }

        }
        return productList
    }
    
    func getTableViewCells(features: [ProductFeature]) {
        self.cellArray.removeAll()
        self.featureArray.removeAll()
        self.featureArray = features

        let youWillLoveToo = Module.init(contentType: .youWillLoveToo, items: getProducts(for: .youWouldLike))
        let otherCustomBuy = Module.init(contentType: .otherCustomBuy, items: getProducts(for: .mostPurchasedByOthers))

        self.cellArray.append(contentsOf: [.mainInfo, .addToCart])
        
        if productDetailViewModel.getVolumePriceList() != nil {
            self.cellArray.append(.volumePrice)
        }
        
        self.cellArray.append(.featureHeader)

        for feature in featureArray {
            switch feature.featureSize! {
            case .big:
                self.cellArray.append(.featureBigSize(feature: feature))
            case .small:
                self.cellArray.append(.featureSmallSize(feature: feature))
            }
        }
        
        if self.productIsFavorite {
            self.cellArray.append(.inFavorite)
            self.cellArray.append(.shareAndFavoris)
        } else {
            self.cellArray.append(.shareAndFavoris)
        }
                
        if !getProducts(for: .youWouldLike).isEmpty {
            self.cellArray.append(.carousel(module: youWillLoveToo))
        }
        self.cellArray.append(.longDescription(feature: productDetailViewModel.getLongDescription(), isCollapsed: descriptionisCollapsed))
        
        if !getProducts(for: .mostPurchasedByOthers).isEmpty {
            self.cellArray.append(.carousel(module: otherCustomBuy))
        }
//        self.cellArray.append(.support)
        self.tableView.reloadData()
        
    }

}

extension ProductViewController: UITableViewDelegate, UITableViewDataSource, ProductDetailDelegate, ExpandableLabelDelegate, AddToCartCellDelegate {
    func displayAlertForAvailabilityNotifictation() {
        if let alertView = UIAlertController(title: nil, message: Constants.availabilityNotificationMessage, dismissActionTitle: "OK", dismissActionBlock: {
            
        }) {
            self.present(alertView, animated: true, completion: nil)
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.indexPathsForVisibleRows?.last?.row {
            self.footerView.frame.size.height = FooterView.height
            self.footerView.layoutIfNeeded()
            self.tableView.tableFooterView = self.footerView
        }
    }
    

    func addToCartButtonTapped(cell: AddToCartTableViewCell) {
        cell.stepperView.quantityTextField.resignFirstResponder()
        let toastConfiguration = Toast(title: "Produit ajouté au panier", titleColor: .white, backgroundColor: .lpPurple, viewController: self, duration: 2)
        let toast = ToastView()
        VibrationHelper.addToCart()
        toast.drawToast(toast: toastConfiguration)
    }
    
    func willExpandLabel(_ label: ExpandableLabel) {
    }

    func didExpandLabel(_ label: ExpandableLabel) {
        let point = label.convert(CGPoint.zero, to: tableView)
        if let indexPath = tableView.indexPathForRow(at: point) as IndexPath? {
            self.descriptionisCollapsed = false
            self.cellArray[indexPath.row] = .longDescription(feature: productDetailViewModel.getLongDescription(), isCollapsed: descriptionisCollapsed)
            self.reloadRows(indexPaths: [indexPath], animation: .fade)
        }
    }

    func willCollapseLabel(_ label: ExpandableLabel) {
    }

    func didCollapseLabel(_ label: ExpandableLabel) {
        let point = label.convert(CGPoint.zero, to: tableView)
        if var indexPath = tableView.indexPathForRow(at: point) as IndexPath? {
            self.descriptionisCollapsed = true
            self.cellArray[indexPath.row] = .longDescription(feature: productDetailViewModel.getLongDescription(), isCollapsed: descriptionisCollapsed)
            self.reloadRows(indexPaths: [indexPath], animation: .fade)
            self.tableView.scrollToRow(at: IndexPath(row: indexPath.row - 1, section: indexPath.section), at: .top, animated: false)
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellItem = self.cellArray[indexPath.row]
        switch self.cellArray[indexPath.row] {
        case .mainInfo:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: cellItem.cellIdentifier, for: indexPath) as! ProductMainInfoTableViewCell
            cell.delegate = self
            cell.setUpCell(productDetailViewModel: productDetailViewModel)
            return cell
        case .featureHeader:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: cellItem.cellIdentifier, for: indexPath) as! FeatureHeaderTableViewCell
            cell.delegate = self
            cell.setupCell(with: productDetailViewModel.getActuelFeaturesListSize(featuresList: featureArray))
            return cell
        case .featureSmallSize(let feature):
            let cell = self.tableView.dequeueReusableCell(withIdentifier: cellItem.cellIdentifier, for: indexPath) as! FeatureSmallSizeTableViewCell
            cell.setupCell(feature: feature)
            return cell
        case .featureBigSize(let feature):
            let cell = self.tableView.dequeueReusableCell(withIdentifier: cellItem.cellIdentifier, for: indexPath) as! FeatureBigSizeTableViewCell
            cell.setupCell(feature: feature)
            return cell
        case .longDescription(let feature, _):
            let cell = self.tableView.dequeueReusableCell(withIdentifier: cellItem.cellIdentifier, for: indexPath) as! ProductLongDescriptionTableViewCell
            cell.longDescriptionExpandableLabel.delegate = self
            cell.setupCell(feature: feature, isCollapsed: self.descriptionisCollapsed)
            return cell
        case .shareAndFavoris:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: cellItem.cellIdentifier, for: indexPath) as! ShareAndFavorisActionTableViewCell
            cell.delegate = self
            cell.shareDelegate = self
            if self.productIsFavorite {
                cell.favoriteLabel.text = "Retirer des favoris"
                cell.favoriteImageView.image = UIImage(named: "remove-favorites")
            } else {
                cell.favoriteLabel.text = "Ajouter aux favoris"
                cell.favoriteImageView.image = UIImage(named: "add-favorites")
            }
            return cell
        case .carousel(let module):
            let cell = self.tableView.dequeueReusableCell(withIdentifier: cellItem.cellIdentifier, for: indexPath) as! CarouselTableViewCell
            cell.setupUpCell(with: module)
            cell.currentSection = indexPath.row
            cell.delegate = self
            return cell
        case .addToCart:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellItem.cellIdentifier, for: indexPath) as! AddToCartTableViewCell
            cell.setupCell(with: productDetailViewModel)
            cell.delegate = self
            return cell
        case .support:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: cellItem.cellIdentifier, for: indexPath) as! SupportTableViewCell
            cell.setupSupportCell()
            return cell
        case .volumePrice:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: cellItem.cellIdentifier, for: indexPath) as! ProductVolumePriceCell
            if let volumePrices = productDetailViewModel.getVolumePriceList() {
                cell.configureCellWith(volumePrices)
            }
            return cell
        case .inFavorite:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: cellItem.cellIdentifier, for: indexPath) as! ProductFavoriteTableViewCell
            cell.setupCell()
            return cell
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellArray.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellItem = self.cellArray[indexPath.row]
        return cellItem.rowHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellItem = self.cellArray[indexPath.row]
        switch cellItem {
        case .support:
            let viewController = R.storyboard.webView.webViewControllerID()!
            viewController.url = "https://aide.laposte.fr/categorie/assistance/"
            self.navigationController?.pushViewController(viewController, animated: true)
        default:
            break
        }
    }

    func openGallery(with images: [UIImage]) {
        guard let productGalleryViewController = R.storyboard.eBoutique.productGalleryViewControllerID() else { return }
        productGalleryViewController.imageList = images
        productGalleryViewController.productName = productDetailViewModel.getProductName()
        productGalleryViewController.providesPresentationContextTransitionStyle = true
        productGalleryViewController.definesPresentationContext = true
        productGalleryViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.tabBarController?.present(productGalleryViewController, animated: true, completion: nil)
    }

    func changeFeaturesListSize() {
        var features: [ProductFeature]
        switch productDetailViewModel.getNewFeaturesListSize(featuresList: featureArray) {
        case .big:
            features = productDetailViewModel.createBigListFeatures()
        case .small:
           features = productDetailViewModel.createSmallListFeatures()
        }
        
        // Remove from array
        var indexToRemove: [IndexPath] = []
        self.cellArray = self.cellArray.enumerated().compactMap { (index, productEnum) -> ProductEnum? in
            switch productEnum {
            case .featureSmallSize(_), .featureBigSize(_):
                indexToRemove.append(IndexPath(row: index, section: 0))
                return nil
            default :
                return productEnum
            }
        }
        
        var indexStartInsert: Int?
        if self.productIsFavorite {
            indexStartInsert = self.cellArray.index(of: .inFavorite)
        } else {
            indexStartInsert = self.cellArray.index(of: .shareAndFavoris)
        }
        
        // Insert in the Array
       var indexToInsert: [IndexPath] = []
        self.featureArray = features
        if var index = indexStartInsert {
            for feature in featureArray {
                guard let size = feature.featureSize else { break }
                switch size {
                case .big:
                    self.cellArray.insert(.featureBigSize(feature: feature), at: index)
                case .small:
                    self.cellArray.insert(.featureSmallSize(feature: feature), at: index)
                }
                indexToInsert.append(IndexPath(row: index, section: 0))
                index = index + 1
            }
        }
        
        // Remove from TableView  and Insert in TableView
        if #available(iOS 11.0, *) {
            self.tableView.performBatchUpdates({ [weak self] in
                self?.tableView.deleteRows(at: indexToRemove, with: .top)
                self?.tableView.insertRows(at: indexToInsert, with: .top)
            }, completion: nil)
        } else {
            self.tableView.beginUpdates()
            self.tableView.deleteRows(at: indexToRemove, with: .top)
            self.tableView.insertRows(at: indexToInsert, with: .top)
            self.tableView.endUpdates()
        }
    }

    func shareProduct() {
        let firstActivityItem = "Bonjour,\n je pense que ce produit pourrait t'intéresser :"
        let secondActivityItem = productDetailViewModel.product?.name ?? ""
        var thirdActivityItem: NSURL = NSURL()
        
        if let categories = productDetailViewModel.product?.categories as? [HYBCategory], let urlCategory = categories.first?.url, let code = productDetailViewModel.product?.code {
            let string = "https://www.laposte.fr/"+urlCategory+"/p/"+code
            thirdActivityItem = NSURL.init(string: string.replacingOccurrences(of: "//", with: "/"))!
        }
        
        let activityViewController: UIActivityViewController = UIActivityViewController(
            activityItems: [firstActivityItem, secondActivityItem, thirdActivityItem], applicationActivities: nil)

        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)

        // Anything you want to exclude
        activityViewController.excludedActivityTypes = [
            UIActivityType.postToWeibo,
            UIActivityType.print,
            UIActivityType.assignToContact,
            UIActivityType.saveToCameraRoll,
            UIActivityType.addToReadingList,
            UIActivityType.postToFlickr,
            UIActivityType.postToVimeo,
            UIActivityType.postToTencentWeibo
        ]

        self.present(activityViewController, animated: true, completion: nil)
        
        // ATInternet
        ATInternetTaggingManager.sharedManager.sendTrackClick(clickLibelle: TaggingData.kPartager , pageName: nil, chapter1: TaggingData.kProductDetails, chapter2: productDetailViewModel.getProductName(), level2: TaggingData.kCommerceLevel)
        
    }

    func scrollToCell(cell: UITableViewCell) {
        tableView.scrollToRow(at: tableView.indexPath(for: cell)!, at: .middle, animated: true)
    }
    
    func addProductToFavorite() {
        let keychainService = KeychainService()
        let authorization = String(format: "Bearer %@", keychainService.get(key: keychainService.accessTokenkey) ?? "")
        
        let headers :[String: String?] = [
            "Authorization": authorization,
            "Content-Type": "application/json"
        ]
        
        let urlString = "https://" + EnvironmentUrlsManager.sharedManager.getHybrisServiceHost() + "/eboutiquecommercewebservices/v2/eboutiquePro/users/"
        guard let email = UserAccount.shared.customerInfo?.displayUid else { Logger.shared.debug("Error"); return }
        guard let productCode = self.productDetailViewModel.product?.code else { Logger.shared.debug("Print Error"); return}
        let urlString2 = urlString + email + Constants.wishlist + "?productCode=\(String(describing: productCode))"
        
        let url = URL(string: urlString2)
        guard let _url = url else {
            return
        }
        
        var request = URLRequest(url: _url)
        request.httpMethod = HTTPMethod.put.rawValue
        request.allHTTPHeaderFields = headers as? [String : String]
        
        self.loaderManager.showLoderView()
        Alamofire.request(request)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                self.loaderManager.hideLoaderView()
                switch response.result {
                case .success( _):
                    let productFavorite = ProductFavorite()
                    productFavorite.save(productCode: productCode, completion: { isSuccess in
                        self.updateFavoriteCell()
                    })
                case .failure:
                    if response.response?.statusCode == 200 {
                        let productFavorite = ProductFavorite()
                        productFavorite.save(productCode: productCode, completion: { isSuccess in
                            self.updateFavoriteCell()
                        })
                    } else {
                        let alertController = UIAlertController(title: "Erreur", message: "Une erreur est survenue", preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "Fermer", style: .destructive, handler: nil))
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
        }
    }
    
    func deleteProductToFavorite() {
        let keychainService = KeychainService()
        let authorization = String(format: "Bearer %@", keychainService.get(key: keychainService.accessTokenkey) ?? "")
        
        let headers :[String: String?] = [
            "Authorization": authorization,
            "Content-Type": "application/json"
        ]
        
        let urlString = "https://" + EnvironmentUrlsManager.sharedManager.getHybrisServiceHost() + "/eboutiquecommercewebservices/v2/eboutiquePro/users/"
        guard let email = UserAccount.shared.customerInfo?.displayUid else { Logger.shared.debug("Error"); return }
        guard let productCode = self.productDetailViewModel.product?.code else { Logger.shared.debug("Print Error"); return}
        let urlString2 = urlString + email + Constants.wishlist + "?productCode=\(String(describing: productCode))"
        
        let url = URL(string: urlString2)
        guard let _url = url else {
            return
        }
        
        var request = URLRequest(url: _url)
        request.httpMethod = HTTPMethod.delete.rawValue
        request.allHTTPHeaderFields = headers as? [String : String]
        
        self.loaderManager.showLoderView()
        Alamofire.request(request)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                self.loaderManager.hideLoaderView()
                switch response.result {
                case .success( _):
                    let productFavorite = ProductFavorite()
                    productFavorite.delete(productCode: productCode, completion: { isSuccess in
                        self.updateFavoriteCell()
                    })
                case .failure:
                    if response.response?.statusCode == 200 {
                        let productFavorite = ProductFavorite()
                        productFavorite.delete(productCode: productCode, completion: { isSuccess in
                            self.updateFavoriteCell()
                        })
                    } else {
                        let alertController = UIAlertController(title: "Erreur", message: "Une erreur est survenue", preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "Fermer", style: .destructive, handler: nil))
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
        }
    }
    
    private func updateFavoriteCell() {
        let realm = try! Realm()
        if let product = self.productDetailViewModel.product, let codeProduct = product.code {
            let productExist = realm.objects(ProductFavorite.self).filter("productCode = '\(codeProduct)'")
            self.productIsFavorite = !productExist.isEmpty
        }
        if self.productIsFavorite, let shareIndex = self.cellArray.index(of: .shareAndFavoris) {
            self.cellArray.insert(.inFavorite, at: shareIndex)
            if #available(iOS 11.0, *) {
                self.tableView.performBatchUpdates({ [weak self] in
                    self?.tableView.insertRows(at: [IndexPath(row: shareIndex, section: 0)], with: .automatic)
                }, completion: nil)
            } else {
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: [IndexPath(row: shareIndex, section: 0)], with: .automatic)
                self.tableView.endUpdates()
            }
        } else if let favoriteIndex = self.cellArray.index(of: .inFavorite) {
            self.cellArray.remove(at: favoriteIndex)
            if #available(iOS 11.0, *) {
                self.tableView.performBatchUpdates({ [weak self] in
                    self?.tableView.deleteRows(at: [IndexPath(row: favoriteIndex, section: 0)], with: .automatic)
                }, completion: nil)
            } else {
                self.tableView.beginUpdates()
                self.tableView.deleteRows(at: [IndexPath(row: favoriteIndex, section: 0)], with: .automatic)
                self.tableView.endUpdates()
            }
        }
        
        if let index = self.cellArray.index(of: .shareAndFavoris) {
            self.reloadRows(indexPaths: [IndexPath(row: index, section: 0)], animation: .fade)
        }
    }
    
    private func reloadRows(indexPaths: [IndexPath], animation: UITableView.RowAnimation) {
        if #available(iOS 11.0, *) {
            self.tableView.performBatchUpdates({ [weak self] in
                self?.tableView.reloadRows(at: indexPaths, with: .fade)
                }, completion: nil)
        } else {
            self.tableView.beginUpdates()
            self.tableView.reloadRows(at: indexPaths, with: .fade)
            self.tableView.endUpdates()
        }
    }

}


extension ProductViewController: ShareAndFavorisActionTableViewCellDelegate {
    func addToFavorites() {
        // ATInternet
        ATInternetTaggingManager.sharedManager.sendTrackClick(clickLibelle: TaggingData.kAjouterAuxFavoris,
                                                              pageName: nil,
                                                              chapter1: TaggingData.kProductDetails,
                                                              chapter2: productDetailViewModel.getProductName(),
                                                              level2: TaggingData.kCommerceLevel)
        
        if self.productIsFavorite {
            self.deleteProductToFavorite()
        } else {
            self.addProductToFavorite()
        }
    }
}

extension ProductViewController: CarouselTableViewCellDelegate, CartViewControllerDelegate {
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

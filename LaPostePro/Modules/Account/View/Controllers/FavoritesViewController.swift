//
//  FavoritesViewController.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 27/08/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit
import RealmSwift

enum TableViewType {
    case favorites
    case postOffice
}

class FavoritesViewController: UIViewController {
    lazy var loaderManager = LoaderViewManager()
    // MARK: ENUM
    enum FavoriteTableView {
        case empty(type: TableViewType)
        case oneButton(title: String)
        case product(product: Product)
        case postalOffice(office: PostalOffice)
        
        var cellIdentifier: String {
            switch self {
            case .empty:
                return "EmptyFavoritesProductsTableViewCellID"
            case .oneButton:
                return "AccessShoppingTableViewCellID"
            case .product:
                return "productEboutiqueTableViewCellID"
            case .postalOffice:
                return "LocationListTableViewCell"
            }
        }
        
        var rowHeight: CGFloat {
            switch self {
            case .empty:
                return 258
            case .oneButton:
                return 85
            case .product:
                return 155
            case .postalOffice:
                return 155
            }
        }
    }
    
    // MARK: IBOutlets
    @IBOutlet weak var favoritesSegmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Variables
    var availableSection = [FavoriteTableView]()
    var viewModel = FavoriteViewModel()
    var productViewModel = ProductViewModel()
    var screenType: TableViewType = .favorites
    
    // MARK: Cycle Life View
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupTitleNavigationBar(backEnabled: true, title: "Favoris", showCart: false)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        self.setupTableView()
        if self.screenType == .favorites {
            self.fetchWishlist()
        }
        
        if self.screenType == .postOffice {
            self.fetchPostOffice()
        }
    }
    
    // MARK: Setup Methods
    
    private func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 80
    }
    
    @IBAction func changeSegmentControl(_ sender: Any) {
        if self.favoritesSegmentedControl.selectedSegmentIndex == 0 {
            self.screenType = .favorites
            self.fetchWishlist()
        } else {
            self.screenType = .postOffice
            self.fetchPostOffice()
        }
    }
    
    private func fetchWishlist() {
        loaderManager.showLoderView()
        self.availableSection.removeAll()
        self.viewModel.getProductWishlist { isSuccess in
            self.loaderManager.hideLoaderView()
            
            if isSuccess {
                if let products = self.viewModel.productsWishlist {
                    for productResponse in products {
                        self.availableSection.append(.product(product: productResponse))
                    }
                    ATInternetTaggingManager.sharedManager.sendTrackPage(pageName: TaggingData.kProducts,
                                                                         chapter1: TaggingData.kMyFavorites,
                                                                         chapter2: nil,
                                                                         level2: TaggingData.kAccountLevel)
                } else {
                    self.availableSection.append(.empty(type: .favorites))
                    self.availableSection.append(.oneButton(title: "Accéder à la boutique"))
                    // ATInternet
                    ATInternetTaggingManager.sharedManager.sendTrackPage(pageName: TaggingData.kHomeWithoutFavotites,
                                                                         chapter1: TaggingData.kMyFavorites,
                                                                         chapter2: nil,
                                                                         level2: TaggingData.kAccountLevel)
                }
            } else {
                self.availableSection.append(.empty(type: .favorites))
                self.availableSection.append(.oneButton(title: "Accéder à la boutique"))
                // ATInternet
                ATInternetTaggingManager.sharedManager.sendTrackPage(pageName: TaggingData.kHomeWithoutFavotites,
                                                                     chapter1: TaggingData.kMyFavorites,
                                                                     chapter2: nil,
                                                                     level2: TaggingData.kAccountLevel)
            }
            self.tableView.reloadData()
            self.view.isUserInteractionEnabled = true
        }
    }
    
    
    private func fetchPostOffice() {
        self.availableSection.removeAll()
        do {
            let realm = try Realm()
            
            let postalOffices = realm.objects(PostalOffice.self)
            
            if !postalOffices.isEmpty {
                for postalOffice in postalOffices {
                    self.availableSection.append(.postalOffice(office: postalOffice))
                }
                ATInternetTaggingManager.sharedManager.sendTrackPage(pageName: TaggingData.kPostalOffices,
                                                                     chapter1: TaggingData.kMyFavorites,
                                                                     chapter2: nil,
                                                                     level2: TaggingData.kAccountLevel)
            } else {
                self.availableSection.append(.empty(type: .postOffice))
                self.availableSection.append(.oneButton(title: "Accéder à la carte"))
                // ATInternet
                ATInternetTaggingManager.sharedManager.sendTrackPage(pageName: TaggingData.kHomeWithoutFavotites,
                                                                     chapter1: TaggingData.kMyFavorites,
                                                                     chapter2: nil,
                                                                     level2: TaggingData.kAccountLevel)
            }
            
        } catch let error as NSError {
            Logger.shared.debug(error.localizedDescription)
        }
        self.tableView.reloadData()
    }
    
    private func deletePostOffice(codeSite: String) {
        let postalOffice = PostalOffice()
        postalOffice.deletePostalOffice(codeSite: codeSite) { isSuccess in
            if isSuccess {
                self.fetchPostOffice()
                let toastConfiguration = Toast(title: "Bureau de poste supprimé", titleColor: .white, backgroundColor: .lpPurple, viewController: self, duration: 3)
                let toast = ToastView()
                toast.drawToast(toast: toastConfiguration)
                self.tableView.reloadData()
            } else {
                let alert = UIAlertController(title: "Erreur", message: "Erreur lors de la suppression du bureau de poste", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Fermer", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.availableSection.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.availableSection[indexPath.row]
        switch item {
        case .empty(let type):
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! EmptyFavoritesProductsTableViewCell
            cell.type = type
            cell.setupCell()
            return cell
        case .oneButton(let title):
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! AccessShoppingTableViewCell
            cell.setupCell(title: title)
            cell.delegate = self
            return cell
        case .product(let product):
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! ProductListTableViewCell
            cell.configureCellWithProductFavorites(product: product, productViewModel: self.productViewModel)
            cell.delegate = self
            return cell
        case .postalOffice(let office):
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! LocationListTableViewCell
            cell.delegate = self
            cell.setupCellFavorites(office: office)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = self.availableSection[indexPath.row]
        return item.rowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.availableSection[indexPath.row]
        switch item {
        case .product(let product):
            if let code = product.id {
                self.productViewModel.getProduct(withID: code) { (product) in
                    guard let productViewController = R.storyboard.eBoutique.productViewControllerID() else { return }
                    productViewController.productDetailViewModel.product = product
                    self.navigationController?.pushViewController(productViewController, animated: true)
                }
            }
        case .postalOffice(let office):
            let viewController = R.storyboard.location.locationDetailViewController()!
            viewController.detailPostalOffice = self.viewModel.convertPostalOfficeToLocPostalOffice(office: office)
            viewController.isFromFavorites = true
            self.navigationController?.pushViewController(viewController, animated: true)
        default:
            break
        }
    }
    
}

extension FavoritesViewController: LocationListTableViewCellDelegate {
    func crossButtonDidTapped(office: PostalOffice) {
        if let codeSite = office.codeSite {
            self.deletePostOffice(codeSite: codeSite)
        }
    }
}

extension FavoritesViewController: ProductCellDelegate {
    func deleteProduct(product: Product) {
        self.viewModel.deleteProductWishlist(product: product.id!) { isSuccess in
            if isSuccess {
                let toastConfiguration = Toast(title: "Un produit supprimé", titleColor: .white, backgroundColor: .lpPurple, viewController: self, duration: 3)
                let toast = ToastView()
                toast.drawToast(toast: toastConfiguration)
                self.view.isUserInteractionEnabled = false
                self.fetchWishlist()
            } else { }
        }
    }
    
    
    func addProductToCart(product: Product) {
        let cartViewModel = CartViewModel.sharedInstance
        cartViewModel.addProductToCart(product: product, quantityToAdd: 1, onCompletion: { (added, _) in
            if added {
                let toastConfiguration = Toast(title: "Produit ajouté au panier", titleColor: .white, backgroundColor: .lpPurple, viewController: self, duration: 2)
                let toast = ToastView()
                VibrationHelper.addToCart()
                toast.drawToast(toast: toastConfiguration)                
                NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "update_cart")))
            }
        })
    }
}

extension FavoritesViewController: AccessShoppingTableViewCellDelegate {
    func accessShoppingButtonDidTapped(cell: AccessShoppingTableViewCell) {
        
        let referenceForTabBarController = self.presentingViewController as! UITabBarController
        self.navigationController?.presentingViewController?.dismiss(animated: false, completion: {
            if self.screenType == .favorites {
                referenceForTabBarController.selectedIndex = TabBarItem.eBoutique.rawValue
            } else {
                referenceForTabBarController.selectedIndex = TabBarItem.locator.rawValue
            }
        })
    }
}

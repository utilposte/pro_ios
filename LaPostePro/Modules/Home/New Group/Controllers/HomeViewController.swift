//
//  HomeViewController.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 04/05/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit
import Firebase
import LPSharedSUIVI
import LPColissimo
import LPColissimoUI

enum TabBarItem: Int {
    case home = 0
    case eBoutique = 1
    case locator = 2
    case scan = 3
}

enum CategoryIndex: Int {
    case stickers = 4
    case packaging = 3
}

enum FrandoleProducts: String {
    case best = "BEST_SELLERS"
    case interesting = "INTERESTING_PRODUCTS"
    case lastBuy = "COMMAND_PRODUCTS"
    case youWouldLike = "YOUWOULDLIKE_PRODUCTS"
    case mostPurchased = "MOST_PURCHASSED"
    case mostPurchasedByOthers = "MOST_PURCHASSED_BY_OTHERS"
}

class HomeViewController: BaseViewController {

    var homeTableViewCellArray: [Home] = [Home]() {
        didSet {
            self.tableView.reloadData()
        }
    }

    lazy var titleViewLabel = UILabel(frame: CGRect.zero)

    //var products = [Product]()
    var bestSellersproducts = [Product]()
    var youWouldLikeProducts = [Product]()
    var lastBuyProducts = [Product]()
    var favoriteProducts = [Product]()

    let product = Product.init()

    var indexCategory = 0

    // MARK: table view footer
    let footerView = FooterView().initFooterView()

    // Product viiewModel used to get product list for test
    var homeViewModel: HomeViewModel
    var cartViewModel: CartViewModel
    var frandoleViewModel: FrandoleViewModel?
    let productViewModel = ProductViewModel()
    var favoriteViewModel = FavoriteViewModel()

    // Carousel webview height
    let carouselHieght: CGFloat = 200

    // MARK: enum for table view cell
    enum Home: Equatable {

        case certification
        case webViewCarousel
        case greetingsMessage(name: String, prefix: String, message: String)
        case navigationInApp(module: Module)
        case track
        case localiser
        case verticalList(module: Module)
        case autoAdvertising(product: Product)
        case promotion
        case carousel(module: Module)
        case advice
        case title
        case colissimo
        case image(image: String)

        var cellIdentifier: String {
            switch self {
            case .certification:
                return "CertificationTableViewCellID"
            case .webViewCarousel:
                return "homeWebCarouselTableViewCellID"
            case .greetingsMessage:
                return "greetingsTableViewCellID"
            case .navigationInApp:
                return "navigationInAppTableViewCellID"
            case .track:
                return "HomeTrackingTableViewCellID"
            case .localiser:
                return "localiserTableViewCellID"
            case .verticalList:
                return "HomeVerticalListTableViewCellID"
            case .autoAdvertising:
                return "autoAdvertisingTableViewCellID"
            case .promotion:
                return "HomePromotionTableViewCellID"
            case .carousel:
                return "CarouselTableViewCellID"
            case .advice:
                return "HomeAdviseTableViewCellID"
            case .title:
                return "HomeTitleTableViewCellID"
            case .colissimo:
                return "ColissimoTableViewCellID"
            case .image:
                return "ColissimoImageTableViewCellID"
            }
        }

        var rowHeight: CGFloat {
            switch self {
            case .certification:
                return 60
            case .carousel:
                return 340
            case .navigationInApp:
                return 98
            case .title:
                return 61
            case .colissimo:
                return 200
            default:
                return UITableViewAutomaticDimension
            }
        }
        
        static func == (lhs: Home, rhs: Home) -> Bool {
            switch (lhs, rhs) {
            case (let .verticalList(module1), let .verticalList(module2)):
                return module1 == module2
            default:
                return false
            }
        }
    }

    // MARK: IBOutlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBarView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchBarHeight: NSLayoutConstraint!
    
    public init(homeViewModel: HomeViewModel, cartViewModel: CartViewModel) {
        self.homeViewModel = homeViewModel
        self.cartViewModel = cartViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder decoder: NSCoder) {
        self.homeViewModel = HomeViewModel()
        self.cartViewModel = CartViewModel.sharedInstance
        super.init(coder: decoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.addProductAndShowCart), name: NSNotification.Name(rawValue: "Colissimo.Home.Cart"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.pushCart), name: NSNotification.Name(rawValue: "ShowCartColissimo"), object: nil)
        self.setupTableView()
        self.frandoleViewModel = FrandoleViewModel.sharedInstance
        let launchedBefore = UserDefaults.standard.bool(forKey: "firstLaunch")
        if !launchedBefore {
            UserDefaults.standard.set(true, forKey: "firstLaunch")
        }
        homeViewModel.setupCategories(completion: { modules in
            self.createTableViewDataSource()
            self.tableView.reloadData()
        })
        homeViewModel.getWelcomingMessages(launchedBefore: launchedBefore) {
            self.createTableViewDataSource()
            self.tableView.reloadData()
        }
        footerView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        // create header
        self.setupLogoNavigationBar()
        
        // Refresh UserData
        self.refreshDataForConnectedUser()
        
        // ATInternet
        ATInternetTaggingManager.sharedManager.sendTrackPage(pageName: TaggingData.kHomeConnected,
                                                             chapter1: nil,
                                                             chapter2: nil,
                                                             level2: TaggingData.kHomeLevel)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    // MARK: Actions

    @objc func pushCart() {
        let viewController = UIStoryboard(name: "Cart", bundle: nil).instantiateViewController(withIdentifier: "CartViewControllerID") as! CartViewController
        let navigationController = UINavigationController(rootViewController: viewController)
        self.present(navigationController, animated: true, completion: nil)
    }

    @objc func addProductAndShowCart() {
        cartViewModel.getCart(onCompletion: { (cart) in
            if cart.totalUnitCount != nil {
                self.updateCartButtonItem()
                let viewController = UIStoryboard(name: "Cart", bundle: nil).instantiateViewController(withIdentifier: "CartViewControllerID") as! CartViewController
                let navigationController = UINavigationController(rootViewController: viewController)
                self.present(navigationController, animated: true, completion: nil)
            }
        })
    }

    func setupTableView() {
        self.tableView.register(UINib(nibName: "CarouselTableViewCell", bundle: nil), forCellReuseIdentifier: "CarouselTableViewCellID")
        self.tableView.estimatedRowHeight = 120
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func getAllLists() {
        // call get lists
        self.getBestSellersProducts()
        self.getYouWouldLikeProducts()
        self.getLastBuyProducts()
        self.getFavotiteProducts()
    }
    
    func refreshDataForConnectedUser() {
        // Refresh Content
        self.getAllLists()
        
        cartViewModel.getCart(onCompletion: { (cart) in
            if cart.totalUnitCount != nil {
                self.updateCartButtonItem()
            }
        })
        
        self.createTableViewDataSource()
        self.tableView.reloadData()

    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        let navigationViewController = R.storyboard.search.instantiateInitialViewController()!
        let searchViewController = navigationViewController.viewControllers[0] as! SearchViewController
        searchViewController.searchType = .all
        searchViewController.openerViewController = self
        self.present(navigationViewController, animated: true)
        return false
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.homeTableViewCellArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.homeTableViewCellArray[indexPath.row]
        switch item {
        case .image(let image):
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! ColissimoImageTableViewCell
            cell.delegate = self
            cell.setupCell(image: image)
            return cell
        case .certification:
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! CertificationTableViewCell
            cell.delegate = self as CertificationCellDelegate
            return cell
        case .webViewCarousel:
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! HomeWebViewCarouselTableViewCell
            cell.setupCell()
            //cell.setupCell(url: self.carouselHtmlContent)
            return cell
        case .greetingsMessage(let name, let prefix, let message):
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! HomeGreetingsMessageTableViewCell
            cell.setupCell(name: name, prefix: prefix, message: message)
            return cell
        case .navigationInApp(let module):
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! HomeNavigationInAppTableViewCell
            cell.setupCell(module: module)
            return cell
        case .track:
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! HomeTrackingTableViewCell
            let (tracks , showMore) = homeViewModel.getTrackList()
            cell.setUpCell(tracks: tracks, showMore: showMore)
            cell.delegate = self
            return cell
        case .localiser:
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! HomeLocaliserTableViewCell
            return cell
        case .verticalList(let module):
            var cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as? HomeVerticalListTableViewCell
            if cell == nil {
                cell = HomeVerticalListTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: item.cellIdentifier)
            }
            cell?.setUpCell(module: module)
            cell?.delegate = self
            return cell!
        case .autoAdvertising(let product):
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! HomeAutoAdvertisingTableViewCell
            cell.setupCell(with: product)
            return cell
        case .promotion:
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! HomePromotionTableViewCell
            cell.configureCell()
            return cell
        case .carousel(let module):
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! CarouselTableViewCell
            cell.delegate = self
            cell.setupUpCell(with: module)
            cell.currentSection = indexPath.row
            cell.collectionView.reloadData()
            return cell
        case .advice:
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! HomeAdviseTableViewCell
            return cell
        case .title:
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! HomeTitleTableViewCell
            cell.titleLabel.text = "Tous nos produits"
            return cell
        case .colissimo:
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! ColissimoTableViewCell
            cell.setupCell()
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = self.homeTableViewCellArray[indexPath.row]
        return item.rowHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.homeTableViewCellArray[indexPath.row]
        switch item {
        case .localiser:
            // ATInternet
            ATInternetTaggingManager.sharedManager.sendTrackClick(clickLibelle: TaggingData.kBureauxDePostePlusProches,
                                                                  pageName: nil,
                                                                  chapter1: TaggingData.kHomeConnected,
                                                                  chapter2: TaggingData.kKocaliser,
                                                                  level2: TaggingData.kHomeLevel)

            self.tabBarController?.selectedIndex = TabBarItem.locator.rawValue
        case .colissimo:
            // ATInternet
            // Need to Add to ATInternet Tags
//            ATInternetTaggingManager.sharedManager.sendTrackClick(clickLibelle: TaggingData.kNouveauColis,
//                                                                  pageName: nil,
//                                                                  chapter1: TaggingData.kHomeConnected,
//                                                                  chapter2: TaggingData.kSuivre,
//                                                                  level2: TaggingData.kHomeLevel)

            let viewController = R.storyboard.account.colissimoViewControllerID()!
            let cartViewModel = CartViewModel.init()
            viewController.containsColissimo = cartViewModel.cartContainColissimo()
            let navigationController: UINavigationController = UINavigationController(rootViewController: viewController)
            self.present(navigationController, animated: true) { }
            break
        case .navigationInApp(let module):
            switch module.moduleRedirectionType {
            case .redirectionToBoutique?:
                // ATInternet
                ATInternetTaggingManager.sharedManager.sendTrackClick(clickLibelle: TaggingData.kCommanderTimbres,
                                                                      pageName: nil,
                                                                      chapter1: TaggingData.kHomeConnected,
                                                                      chapter2: TaggingData.kEntreesServices,
                                                                      level2: TaggingData.kHomeLevel)

                tabBarController!.selectedIndex = TabBarItem.eBoutique.rawValue
                showProductlist(for: nil)
            case .redirectionToStikers?:
                // ATInternet
                ATInternetTaggingManager.sharedManager.sendTrackClick(clickLibelle: TaggingData.kAjouterStickerSuivi,
                                                                      pageName: nil,
                                                                      chapter1: TaggingData.kHomeConnected,
                                                                      chapter2: TaggingData.kEntreesServices,
                                                                      level2: TaggingData.kHomeLevel)

                let category = self.homeViewModel.categories[CategoryIndex.stickers.rawValue]
                showProductlist(for: category)
            case .redirectionToPackaging?:
                // ATInternet
                ATInternetTaggingManager.sharedManager.sendTrackClick(clickLibelle: TaggingData.kEnvoyerColisAvecEmballage,
                                                                      pageName: nil,
                                                                      chapter1: TaggingData.kHomeConnected,
                                                                      chapter2: TaggingData.kEntreesServices,
                                                                      level2: TaggingData.kHomeLevel)

                let category = self.homeViewModel.categories[CategoryIndex.packaging.rawValue]
                showProductlist(for: category)
            default:
                if(indexPath.row >= self.indexCategory) {
                    let category = self.homeViewModel.categories[indexPath.row - self.indexCategory]
                    showProductlist(for: category)

                    // ATInternet
                    switch category.key {
                    case "Timbres Marianne":
                        ATInternetTaggingManager.sharedManager.sendTrackClick(clickLibelle: TaggingData.kTimbresMarianne , pageName: nil, chapter1: TaggingData.kHomeConnected, chapter2: TaggingData.kTousNosArticles, level2: TaggingData.kHomeLevel)
                    case "Beaux timbres":
                        ATInternetTaggingManager.sharedManager.sendTrackClick(clickLibelle: TaggingData.kBeauxTimbres , pageName: nil, chapter1: TaggingData.kHomeConnected, chapter2: TaggingData.kTousNosArticles, level2: TaggingData.kHomeLevel)
                    case "Enveloppes préaffranchies":
                        ATInternetTaggingManager.sharedManager.sendTrackClick(clickLibelle: TaggingData.kEnveloppesPreaffranchies , pageName: nil, chapter1: TaggingData.kHomeConnected, chapter2: TaggingData.kTousNosArticles, level2: TaggingData.kHomeLevel)
                    case "Emballages préaffranchis":
                        ATInternetTaggingManager.sharedManager.sendTrackClick(clickLibelle: TaggingData.kEmballagesPreaffranchis , pageName: nil, chapter1: TaggingData.kHomeConnected, chapter2: TaggingData.kTousNosArticles, level2: TaggingData.kHomeLevel)
                    default:
                        ATInternetTaggingManager.sharedManager.sendTrackClick(clickLibelle: TaggingData.kStickerSuivi , pageName: nil, chapter1: TaggingData.kHomeConnected, chapter2: TaggingData.kTousNosArticles, level2: TaggingData.kHomeLevel)
                    }
                }
            }
        case .autoAdvertising:
            // ATInternet
            ATInternetTaggingManager.sharedManager.sendTrackClick(clickLibelle: TaggingData.kProduitsRecommandations,
                                                                  pageName: nil,
                                                                  chapter1: TaggingData.kPushCrossSelling,
                                                                  chapter2: nil,
                                                                  level2: TaggingData.kTransverseLevel)

            showDetails(for: youWouldLikeProducts.first!)
        default:
            return
        }
    }

    func openSearch(str:String) {
        tabBarController!.selectedIndex = TabBarItem.eBoutique.rawValue
        let navigationViewController = tabBarController!.viewControllers![1] as! UINavigationController
        if let categoryViewController = navigationViewController.visibleViewController as? CategoryViewController {
            categoryViewController.openSearch(str: str, animated: false)
        }
    }

    func showProductlist(for category: Category?) {
        tabBarController!.selectedIndex = TabBarItem.eBoutique.rawValue
        let navigationViewController = tabBarController!.viewControllers![1] as! UINavigationController
        if let categoryViewController = navigationViewController.visibleViewController as? CategoryViewController {
            if category != nil  {
                categoryViewController.showProductList(for: category!.id, title: category!.key)
            }
        } else {
            navigationViewController.popToRootViewController(animated: true)
            if category != nil  {
                let categoryViewController = navigationViewController.visibleViewController as! CategoryViewController
                categoryViewController.showProductList(for: category!.id, title: category!.key)
            }
        }
    }

    func openSearchFollow() {
        tabBarController!.selectedIndex = TabBarItem.scan.rawValue
    }

    func openSearchLocator(str:String) {
        tabBarController!.selectedIndex = TabBarItem.locator.rawValue
        let navigationViewController = tabBarController!.viewControllers![2] as! UINavigationController
        if let locationRootViewController = navigationViewController.visibleViewController as? LocationRootViewController {
            locationRootViewController.searchLocator(str)
        }
    }

    // Get frandoles products

    fileprivate func getLastBuyProducts() {
        self.lastBuyProducts.removeAll()
        self.frandoleViewModel?.getProducts(for: FrandoleProducts.lastBuy.rawValue) { (products) in
            if let resultProducts = products {
                for product in resultProducts {
                    self.lastBuyProducts.append(self.frandoleViewModel!.getFrandoleProduct(for: product))
                }
                self.createTableViewDataSource()
                self.tableView.reloadData()
            }
        }
    }

    func getBestSellersProducts() {
        self.bestSellersproducts.removeAll()
        self.frandoleViewModel?.getProducts(for: FrandoleProducts.best.rawValue) { (products) in
            for product in products! {
                self.bestSellersproducts.append(self.frandoleViewModel!.getFrandoleProduct(for: product))
            }
            self.createTableViewDataSource()
            self.tableView.reloadData()
        }
    }

    func getYouWouldLikeProducts() {
        self.youWouldLikeProducts.removeAll()
        self.frandoleViewModel?.getProducts(for: FrandoleProducts.youWouldLike.rawValue) { (products) in
            for product in products! {
                self.youWouldLikeProducts.append(self.frandoleViewModel!.getFrandoleProduct(for: product))
            }
            self.createTableViewDataSource()
            self.tableView.reloadData()
        }
    }

    func getFavotiteProducts() {
        self.favoriteProducts.removeAll()
        self.favoriteViewModel.getProductWishlist { isSuccess in
            if isSuccess {
                if let favorites = self.favoriteViewModel.productsWishlist {
                    for favorite in favorites {
                        self.favoriteProducts.append(self.frandoleViewModel!.getFrandoleProduct(for: favorite))
                    }
                }
            }
            self.createTableViewDataSource()
            self.tableView.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.indexPathsForVisibleRows?.last?.row {
            self.footerView.frame.size.height = FooterView.height
            self.footerView.layoutIfNeeded()
            self.tableView.tableFooterView = self.footerView
        }
    }

    func createTableViewDataSource() {
        self.homeTableViewCellArray.removeAll()
        // MARK: data for test Navigat
        let module1 = Module.init(moduleName: "Commander des timbres", moduleImage: R.image.envoyerCourrier()!, deepLink: "", with: .lpPurple, moduleRedirectionType: InAppNavigationType.redirectionToBoutique)
        let module2 = Module.init(moduleName: "Ajouter un sticker suivi à mes envois", moduleImage: R.image.ajouterSuivis()!, deepLink: "", with: .lpPurple, moduleRedirectionType: InAppNavigationType.redirectionToStikers)
        let module3 = Module.init(moduleName: "Envoyer un colis avec emballage", moduleImage: R.image.envoyerColis()!, deepLink: "", with: .lpPurple, moduleRedirectionType: InAppNavigationType.redirectionToPackaging)

        let lastBuyModule = Module.init(moduleName: "Les derniers produits achetés", deepLink: "", actionDescription: "Voir ma dernière commande", items: lastBuyProducts, contentType: .lastBuyList)

        let cartModule = Module.init(moduleName: "Vous avez ajouté à votre panier", deepLink: "", actionDescription: "Finaliser ma commande", items: cartViewModel.products, contentType: .cartList)

        let favoritModule = Module.init(moduleName: "Vos produits favoris", deepLink: "", actionDescription: "Voir mes favoris", items: favoriteProducts, contentType: .favoritesList)

        let bestSell = Module.init(contentType: .bestSellCarousel, items: bestSellersproducts)

        homeTableViewCellArray = [.image(image: "colissimoHome"), .greetingsMessage(name: UserAccount.shared.customerInfo?.firstName ?? "", prefix: "\(self.homeViewModel.greetingTitle) ", message: self.homeViewModel.greetingSubtitle), .navigationInApp(module: module1), .navigationInApp(module: module2), .navigationInApp(module: module3)/*, .carousel(module: lastSee)*/]
        if let user = UserAccount.shared.customerInfo, user.showCertified() != true {
            homeTableViewCellArray.insert(.certification, at: 0)
        }
        homeTableViewCellArray.append(.track)
        homeTableViewCellArray.append(.localiser)
        //        homeTableViewCellArray.append(.promotion)
        if (lastBuyProducts.count > 0) {
            homeTableViewCellArray.append(.verticalList(module: lastBuyModule))
        }
        homeTableViewCellArray.append(.title)
        homeTableViewCellArray.append(.colissimo)
        indexCategory = homeTableViewCellArray.count
        if (self.homeViewModel.categories.count > 0) {
            let modules = self.homeViewModel.modulesFor(categories:self.homeViewModel.categories)
            for module in modules {
                self.homeTableViewCellArray.append(.navigationInApp(module: module))
            }
        }
        if (bestSellersproducts.count > 0) {
            homeTableViewCellArray.append(.carousel(module: bestSell))
        }
        if youWouldLikeProducts.first != nil {
            homeTableViewCellArray.append(.autoAdvertising(product: youWouldLikeProducts.first!))
        }
        if (cartViewModel.products.count > 0) {
            homeTableViewCellArray.append(.verticalList(module: cartModule))
        }
        //        homeTableViewCellArray.append(.advice)
        if (favoriteProducts.count > 0) {
            homeTableViewCellArray.append(.verticalList(module: favoritModule))
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollOffset = scrollView.contentOffset.y

        if scrollOffset > 0 {
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.1, animations: {() -> Void in
                self.view.layoutIfNeeded()
            }, completion: {(_) -> Void in
                self.searchBarView.isHidden = true
                self.searchBar.isHidden = true
                self.searchBarHeight.constant = 0
                self.setupSearchNavigationBar(text: "Rechercher un produit, un suivi, bureau...", delegate: self)
                self.view.layoutIfNeeded()
            })
        } else {
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.1, animations: {() -> Void in
                self.searchBarView.isHidden = false
                self.searchBar.isHidden = false
                self.searchBarHeight.constant = 50
                
                self.view.layoutIfNeeded()
            }, completion: {(_) -> Void in
                self.setupLogoNavigationBar()
                self.view.layoutIfNeeded()
            })
        }
    }

}

extension HomeViewController: CarouselTableViewCellDelegate, CartViewControllerDelegate {
    func showDetails(for product: Product) {
        if product.isReex() {
            // PUSH TO Reex Detail Product
            if let viewController = UIStoryboard.init(name: "Cart", bundle: nil).instantiateViewController(withIdentifier: "ReexCartDetailViewControllerID") as? ReexCartDetailViewController {
                viewController.product = product
                self.present(viewController, animated: true, completion: nil)
            }
        } else {
            self.productViewModel.getProduct(withID: product.id!) { (product) in
                guard let productViewController = R.storyboard.eBoutique.productViewControllerID() else { return }
                productViewController.productDetailViewModel.product = product
                self.navigationController?.pushViewController(productViewController, animated: true)
            }
        }
    }

    func didCellTapped(indexPath: IndexPath, cell: CarouselTableViewCell) {
        let product = cell.module!.items![indexPath.row]
        showDetails(for: product)
    }
}

extension HomeViewController: CertificationCellDelegate {
    func showInstructions() {
        let certificationController = R.storyboard.account.certificationViewControllerID()!
        modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        navigationController?.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        present(certificationController, animated: true, completion: nil)
    }
}

extension HomeViewController: HomeTrackingTableViewCellDelegate {
    func showScanView() {
        // ATInternet
        ATInternetTaggingManager.sharedManager.sendTrackClick(clickLibelle: TaggingData.kTousLesSuivis,
                                                              pageName: nil,
                                                              chapter1: TaggingData.kHomeConnected,
                                                              chapter2: TaggingData.kSuivre,
                                                              level2: TaggingData.kHomeLevel)

        tabBarController!.selectedIndex = TabBarItem.scan.rawValue
        let navigationViewController = tabBarController!.viewControllers![TabBarItem.scan.rawValue] as! UINavigationController
        if let scanRootViewController = navigationViewController.visibleViewController as? FollowListViewController {
            scanRootViewController.goToScanController()
        }
    }
    
    func showTrackView() {
        // ATInternet
        ATInternetTaggingManager.sharedManager.sendTrackClick(clickLibelle: TaggingData.kTousLesSuivis,
                                                              pageName: nil,
                                                              chapter1: TaggingData.kHomeConnected,
                                                              chapter2: TaggingData.kSuivre,
                                                              level2: TaggingData.kHomeLevel)
        
        tabBarController!.selectedIndex = TabBarItem.scan.rawValue
//        let navigationViewController = tabBarController!.viewControllers![TabBarItem.scan.rawValue] as! UINavigationController
//        if let scanRootViewController = navigationViewController.visibleViewController as? FollowListViewController {
//            scanRootViewController.goToScanController()
//        }
    }

    func showTrackDetail(track: ResponseTrack) {
        guard let detailFollowViewController = R.storyboard.follow.followDetailViewControllerID() else {
            return
        }
        // ATInternet
//        ATInternetTaggingManager.sharedManager.sendTrackClick(clickLibelle: TaggingData.kNouveauColis,
//                                                              pageName: nil,
//                                                              chapter1: TaggingData.kHomeConnected,
//                                                              chapter2: TaggingData.kSuivre,
//                                                              level2: TaggingData.kHomeLevel)

        detailFollowViewController.responseTrack = track
        self.navigationController?.pushViewController(detailFollowViewController, animated: true)
    }
}

extension HomeViewController: ColissimoImageTableViewCellDelegate {
    func cellDidTapped() {
        let viewController = R.storyboard.account.colissimoViewControllerID()!
        let cartViewModel = CartViewModel.init()
        viewController.containsColissimo = cartViewModel.cartContainColissimo()
        let navigationController: UINavigationController = UINavigationController(rootViewController: viewController)
        self.present(navigationController, animated: true) { }
    }
}

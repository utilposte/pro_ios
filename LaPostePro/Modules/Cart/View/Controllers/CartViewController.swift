//
//  CartViewController.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 04/05/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import LPSharedMCM
import UIKit

protocol CartViewControllerDelegate: class {
    func showDetails(for product: Product)
}

class CartViewController: BaseViewController {
    // MARK: Properties

    var cartArray: [CartViewController.Cart] = [CartViewController.Cart]()
    var cartHeaderArray: [CartViewController.Cart] = []
    var products = [Product]()
    lazy var promoCodeCellIsExpanded = false
    var cartViewModel: CartViewModel

    var favoriteViewModel = FavoriteViewModel()
    var favoriteProducts = [Product]()
    lazy var loaderManager = LoaderViewManager()
    let error: String = ""

    public init(cartViewModel: CartViewModel) {
        self.cartViewModel = cartViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder decoder: NSCoder) {
        self.cartViewModel = CartViewModel.sharedInstance
        super.init(coder: decoder)
    }
    // MARK: Enum

    enum Cart: Equatable {
        static func == (lhs: CartViewController.Cart, rhs: CartViewController.Cart) -> Bool {
            switch (lhs, rhs) {
            case (.crossSelling, .crossSelling):
                return true
            case (.cart, .cart):
                return true
            default:
                return false
            }
        }

        case shipping(totalAmount: Float)
        case priceProduct(itemNumber: Int, TTCPrice: String)
        case confirmOrder
        case emptyCart
        case cart
        case promoCode
        case shippingDate(from: String, to: String)
        case recommendation(product: Product)
        case carousel(module: Module)
        case verticalList(module: Module)
        case crossSelling
        case totalAmount(priceWithTVA: HYBPrice, priceWithoutTVA: HYBPrice, totalTVA: HYBPrice, shippingPrice: HYBPrice?, reductionPrice: HYBPrice, shouldDisplay: Bool)

        var cellIdentifier: String {
            switch self {
            case .shipping:
                return "ShippingTableViewCellID"
            case .priceProduct:
                return "PriceProductTableViewCellID"
            case .confirmOrder:
                return "ConfirmOrderTableViewCellID"
            case .emptyCart:
                return "EmptyCartTableViewCellID"
            case .cart:
                return "ProductCartTableViewCellID"
            case .promoCode:
                return "PromoCodeTableViewCellID"
            case .shippingDate:
                return "ShippingDateTableViewCellID"
            case .recommendation:
                return "RecommendationTableViewCellID"
            case .carousel:
                return "CarouselTableViewCellID"
            case .verticalList:
                return "HomeVerticalListTableViewCellID"
            case .crossSelling:
                return "StickerTableViewCellID"
            case .totalAmount:
                return "CartTotalPriceTableViewCellID"
            }
        }

        var rowHeight: CGFloat {
            switch self {
            case .shipping(let totalAmount):
                if totalAmount > 0 {
                    return 70
                } else {
                    return 35
                }
            case .carousel:
                return 330
            case .emptyCart:
                return 280
            case .confirmOrder:
                return 110
            case .cart:
                return UITableViewAutomaticDimension
            case .recommendation:
                return 272
            default:
                return UITableViewAutomaticDimension
            }
        }
    }

    // MARK: IBOutlets

    @IBOutlet var tableView: UITableView!

    let footerView = FooterView().initFooterView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.promoCodeCellIsExpanded = self.cartViewModel.activeVoucher != nil
        self.setupTableView()
        self.tableView.register(UINib(nibName: "CarouselTableViewCell", bundle: nil),
                                forCellReuseIdentifier: "CarouselTableViewCellID")
        self.setupModalNavigationBar(title: "Mon panier", image: R.image.ic_close() ?? UIImage(), leftBarButtom: false)
        self.getFavotiteProducts()
        self.footerView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        self.setupView()

        // ATInternet
        ATInternetTaggingManager.sharedManager.sendTrackPage(pageName: TaggingData.kCart,
                                                             chapter1: TaggingData.kTunnel,
                                                             chapter2: nil,
                                                             level2: TaggingData.kCommerceLevel)
    }

    func getProducts(for frandole: FrandoleProducts) -> [Product] {
        var productList = [Product]()
        FrandoleViewModel.sharedInstance.getProducts(for: frandole.rawValue) { products in
            for product in products! {
                productList.append(FrandoleViewModel.sharedInstance.getFrandoleProduct(for: product))
            }
        }
        return productList
    }

    func getFavotiteProducts() {
        self.favoriteViewModel.getProductWishlist { isSuccess in
            self.favoriteProducts.removeAll()
            if isSuccess {
                if let favorites = self.favoriteViewModel.productsWishlist {
                    for favorite in favorites {
                        self.favoriteProducts.append(FrandoleViewModel().getFrandoleProduct(for: favorite))
                    }
                }
                self.setupView()
                self.tableView.reloadData()
            }
        }
    }

    func setupView() {
        self.loaderManager.showLoderView()
        self.cartViewModel.getProductListForCarousel(query: String(format: Constants.defaultQueryProductList, "", "312"), completion: { productList in
            for product in productList {
                self.products.append(Product(hybProduct: product))
            }
            // let lastSeeModule = Module.init(moduleName: "Derniers articles vus", deepLink: "", actionDescription: "Voir les derniers articles vus", items: self.products, contentType: .lastSeeCarousel)

            let couldBeInterestedModule = Module(moduleName: "Ce qui pourrait vous intéresser", deepLink: "", actionDescription: "Voir ce qui pourrait vous intéresser", items: self.getProducts(for: .interesting), contentType: .couldBeInterested)

            let favoritModule = Module(moduleName: "Vos produits favoris", deepLink: "", actionDescription: "Voir mes favoris", items: self.favoriteProducts, contentType: .favoritesList)

            self.cartViewModel.getCart(onCompletion: { cart in
                self.loaderManager.hideLoaderView()
                self.cartArray = []
                self.cartHeaderArray = []
                if cart.totalUnitCount != nil, cart.totalUnitCount.intValue > 0 {
                    if cart.hasOnlyEservice == false {
                        if let _ = cart.deliveryCost {
                            self.cartHeaderArray.append(.shipping(totalAmount: self.cartViewModel.totalPrice))
                        } else {
                           self.cartHeaderArray.append(.shipping(totalAmount: 0))
                        }
                    }
                    if self.cartViewModel.products.count > 1 {
                        self.cartArray.append(.priceProduct(itemNumber: self.cartViewModel.productTotalCountInCart ?? 0, TTCPrice: (self.cartViewModel.priceWithTVA?.formattedValue) ?? ""))
                    } else {
                        self.cartArray.append(.priceProduct(itemNumber: self.cartViewModel.productTotalCountInCart ?? 0, TTCPrice: self.cartViewModel.priceWithTVA?.formattedValue ?? ""))
                    }
                    self.cartArray.append(.confirmOrder)

                    for _ in self.cartViewModel.products {
                        self.cartArray.append(.cart)
                    }
                    if self.cartViewModel.needReconditioning() {
                        self.cartArray.append(.crossSelling)
                    }

                    self.cartArray.append(.promoCode)

                    if let firstDate = self.cartViewModel.firstDeliveryDate, let secondDate = self.cartViewModel.secondDeliveryDate {
                        if cart.hasOnlyEservice == false {
                            self.cartArray.append(.shippingDate(from: firstDate, to: secondDate))
                        }
                    }

                    self.cartArray.append(.totalAmount(priceWithTVA: self.cartViewModel.priceWithTVA ?? HYBPrice(),
                                                       priceWithoutTVA: self.cartViewModel.priceWithoutTVA ?? HYBPrice(),
                                                       totalTVA: self.cartViewModel.totalTVA ?? HYBPrice(),
                                                       shippingPrice: self.cartViewModel.shippingPrice,
                                                       reductionPrice: self.cartViewModel.discount ?? HYBPrice(),
                                                       shouldDisplay: (self.cartViewModel.activeVoucher != nil) && (self.cartViewModel.discount!.value != 0)))
                    
//                    if !self.getProducts(for: .youWouldLike).isEmpty {
//                        self.cartArray.append(.recommendation(product: self.getProducts(for: .youWouldLike).first!))
//                    }
                    self.cartArray.append(.carousel(module: couldBeInterestedModule))
                } else {
                    self.cartArray = []
                    self.cartViewModel.removeVoucher { _ in }
                    self.cartArray.append(.emptyCart)
                    if !self.products.isEmpty {
                        self.cartArray.append(.carousel(module: couldBeInterestedModule))
                        if !self.favoriteProducts.isEmpty {
                            self.cartArray.append(.verticalList(module: favoritModule))
                        }
                    }
                }
                
                let totalProducts = self.cartViewModel.productTotalCountInCart ?? 0
                if totalProducts == 1 {
                    self.setupModalNavigationBar(title: "Mon panier: \(totalProducts) produit", image: R.image.ic_close() ?? UIImage(),
                                                 leftBarButtom: false)
                } else if totalProducts > 1 {
                    self.setupModalNavigationBar(title: "Mon panier: \(totalProducts) produits", image: R.image.ic_close() ?? UIImage(),
                                                 leftBarButtom: false)
                } else {
                    self.setupModalNavigationBar(title: "Mon panier", image: R.image.ic_close() ?? UIImage(),
                                                 leftBarButtom: false)
                }
                self.tableView.reloadData()
            })
        })
    }

    func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        self.tableView.separatorColor = .clear
        self.footerView.frame.size.height = FooterView.height
        self.footerView.layoutIfNeeded()
        self.tableView.tableFooterView = self.footerView
    }
}

extension CartViewController: UITableViewDelegate, UITableViewDataSource, ReconditioningCellDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cartArray.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.cartHeaderArray.indices.contains(section) {
            let item = self.cartHeaderArray[section]
            switch item {
            case .shipping(let totalAmount):
                let cell = self.tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier) as! ShippingTableViewCell
                cell.configureShippingCell(amount: totalAmount)
                return cell
            default:
                break
            }
        }
        return nil
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.cartArray[indexPath.row]

        switch item {
        case .shipping(let totalAmount):
            let cell = self.tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! ShippingTableViewCell
            cell.configureShippingCell(amount: totalAmount)
            return cell
        case .priceProduct(let itemNumber, let TTCPrice):
            let cell = self.tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! PriceProductTableViewCell
            cell.configurePriceProductCell(itemNumber: itemNumber, TTCPrice: TTCPrice)
            return cell
        case .confirmOrder:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! ConfirmOrderTableViewCell
            cell.delegate = self
            cell.configureConfirmOrderCell()
            return cell
        case .emptyCart:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! EmptyCartTableViewCell
            cell.configureEmptyCartCell()
            return cell
        case .cart:
            let index = indexPath.row - 2 >= 0 ? indexPath.row - 2 : 0
            let product = self.cartViewModel.products[index]
            if product.isColissimo() {
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "ProductCartColissimoTableViewCellID", for: indexPath) as! ProductCartColissimoTableViewCell
                cell.delegate = self
                cell.setupCell(product: product)
                return cell
            } else if product.isReex() {
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "ProductCartColissimoTableViewCellID", for: indexPath) as! ProductCartColissimoTableViewCell
                cell.delegate = self
                cell.setupCellForReex(product: product)
                return cell
            } else {
                let cell = self.tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! ProductCartTableViewCell
                cell.delegate = self
                cell.configureProductCartCell(product: product)
                return cell
            }
        case .promoCode:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! PromoCodeTableViewCell
            cell.configurePromoCodeCell(expanded: self.promoCodeCellIsExpanded)
            if self.promoCodeCellIsExpanded {}
            cell.promoCodeTextField.delegate = self
            cell.delegate = self
            return cell
        case .shippingDate(let fromDate, let toDate):
            let cell = self.tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! ShippingDateTableViewCell
            cell.containerView.addRadius(value: 5, color: UIColor.lightGray.cgColor, width: 1)
            cell.containerView.clipsToBounds = true
            cell.configureShippingDateCell(fromDate: fromDate, toDate: toDate)
            return cell
        case .recommendation(let product):
            let cell = self.tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! RecommendationTableViewCell
            cell.setupCell(with: product)
            return cell
        case .carousel(let module):
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! CarouselTableViewCell
            cell.setupUpCell(with: module)
            cell.currentSection = indexPath.row
            cell.delegate = self
            return cell
        case .crossSelling:
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! StickerTableViewCell
            cell.configure()
            cell.delegate = self
            return cell
        case .verticalList(let module):
            var cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as? HomeVerticalListTableViewCell
            if cell == nil {
                cell = HomeVerticalListTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: item.cellIdentifier)
            }
            cell?.setUpCell(module: module)
            cell?.delegate = self
            return cell!
        case .totalAmount(let priceWithTVA, let priceWithoutTVA, let totalTVA, let shippingPrice, let reductionPrice, let shouldDisplay):
            let cell = self.tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath) as! CartTotalPriceTableViewCell
            cell.delegate = self
            cell.setupCartTotalPriceCell(priceWithTVA: priceWithTVA, priceWithoutTVA: priceWithoutTVA, totalTVA: totalTVA, shippingPrice: shippingPrice, reductionPrice: reductionPrice, shouldDisplay: shouldDisplay)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.cartHeaderArray.indices.contains(section) {
            let item = self.cartHeaderArray[section]
            return item.rowHeight
        }
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = self.cartArray[indexPath.row]
        switch item {
        case .verticalList(let module):
            var buttonbCellHeight = 0
            if module.contentType != .cartList {
                buttonbCellHeight = -30
            }
            if module.items != nil, module.items!.count <= 2 {
                return CGFloat((module.items!.count * 110) + (185 + buttonbCellHeight))
            } else {
                return CGFloat(505 + buttonbCellHeight)
            }
        default:
            return item.rowHeight
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.indexPathsForVisibleRows?.last?.row {
            self.footerView.frame.size.height = FooterView.height
            self.footerView.layoutIfNeeded()
            self.tableView.tableFooterView = self.footerView
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.cartArray[indexPath.row]
        switch item {
        case .cart:
            let index = indexPath.row - 2 >= 0 ? indexPath.row - 2 : 0
            let product = self.cartViewModel.products[index]
            showDetails(for: product)
            return
        case .recommendation:
            self.showDetails(for: self.getProducts(for: .youWouldLike).first!)
        default:
            return
        }
    }

    func applyReconditioning(products: [Product]) {
        self.cartViewModel.applyReconditioning(products: products) { reconditioningApplied in
            if reconditioningApplied {
                self.setupView()
            }
        }
    }

    func removeReconditioningCell(cell: UITableViewCell) {
        let crossSellingCell = self.cartArray.filter { Cart.crossSelling == $0 }
        if !crossSellingCell.isEmpty {
            self.cartArray.remove(at: self.cartArray.index(where: { $0 == .crossSelling })!)
            self.tableView.deleteRows(at: [tableView.indexPath(for: cell)!], with: .right)
        }
    }
}

extension CartViewController: CarouselTableViewCellDelegate, ConfirmOrderDelegate, CartViewControllerDelegate {
    func confirmButtonClicked() {
        let viewController = R.storyboard.cart.shippingCartViewControllerID()!
        viewController.colissmoCostShipping = String(describing: self.cartViewModel.deliveryCost())
        self.navigationController?.pushViewController(viewController, animated: true)
        
        // ATInternet
        ATInternetTaggingManager.sharedManager.sendTrackClick(clickLibelle: TaggingData.kFinaliserCommande, pageName: nil, chapter1: TaggingData.kCart, chapter2: nil, level2: TaggingData.kCommerceLevel)
    }

    func didCellTapped(indexPath: IndexPath, cell: CarouselTableViewCell) {
        let product = cell.module!.items![indexPath.row]
        showDetails(for: product)
    }
    
    func showDetails(for product: Product) {
        if product.isReex() {
            didPushedReexDetails(product: product)
        } else {
            ProductViewModel().getProduct(withID: product.id!) { product in
                guard let productViewController = R.storyboard.eBoutique.productViewControllerID() else { return }
                productViewController.productDetailViewModel.product = product
                self.navigationController?.pushViewController(productViewController, animated: true)
            }
        }
    }
}

extension CartViewController: PromoCodeTableViewCellDelegate {
    func didTappedPromoCodeButton(cell: PromoCodeTableViewCell) {
        self.tableView.beginUpdates()

        if self.promoCodeCellIsExpanded == false {
            UIView.animate(withDuration: 0.4, animations: {
                cell.promoCodeViewHeightConstraint.constant = 45
                cell.layoutIfNeeded()
            }) { _ in
                cell.promoCodeApplyButton.isHidden = false
                cell.promoCodeTextField.isHidden = false
                cell.promoCodeTypeButton.isHidden = true
                cell.promoCodeBenefitsLabel.font = UIFont.boldSystemFont(ofSize: 15)
                cell.promoCodeBenefitsLabel.text = "Mon code de réduction"
                self.promoCodeCellIsExpanded = true
            }
        }

        self.tableView.endUpdates()

        // ATInternet
        ATInternetTaggingManager.sharedManager.sendTrackClick(clickLibelle: TaggingData.kSaisirCodePromo, pageName: nil, chapter1: TaggingData.kCart, chapter2: nil, level2: TaggingData.kCommerceLevel)
    }

    func didTappedPromoCodeApplyButton(cell: PromoCodeTableViewCell) {
        // IF TRUE
        guard let promoCode = cell.promoCodeTextField.text else {
            let content = "Veuillez renseigner un code promo"
            let alertController = UIAlertController(title: content, message: "", preferredStyle: .alert)
            let closeAlertAction = UIAlertAction(title: "Fermer", style: .default, handler: nil)
            alertController.addAction(closeAlertAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }

        if self.cartViewModel.activeVoucher != nil {
            self.cartViewModel.removeVoucher { success in
                var message = "Impossible de supprimer le code promo"
                if success {
                    message = "Code Promo supprimé"
                }
                let toastConfiguration = Toast(title: message, titleColor: .white, backgroundColor: .lpPurple, viewController: self, duration: 2)
                let toast = ToastView()
                toast.drawToast(toast: toastConfiguration)
                self.setupView()
                return
            }
        } else {
            self.cartViewModel.applyCodePromo(promoCode: promoCode, onCompletion: { success in
                var message = "Code promo invalide"
                if success {
                    message = "Code promo appliqué"
                }
                let toastConfiguration = Toast(title: message, titleColor: .white, backgroundColor: .lpPurple, viewController: self, duration: 2)
                let toast = ToastView()
                toast.drawToast(toast: toastConfiguration)
                self.setupView()
                return
            })
        }

        // ATInternet
        ATInternetTaggingManager.sharedManager.sendTrackClick(clickLibelle: TaggingData.kAppliquerCodePromo, pageName: nil, chapter1: TaggingData.kCart, chapter2: nil, level2: TaggingData.kCommerceLevel)
    }
}

extension CartViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.resignFirstResponder()
        return true
    }
}

extension CartViewController: ProductCartTableViewCellDelegate {
    func didUpdateProductQuantity() {
        self.setupView()
    }

    func didDeletedProduct(index: Int) {
        let alertController = UIAlertController(title: nil, message: "Êtes-vous sûr de supprimer cet article?", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Oui", style: .default) { (_: UIAlertAction) in
            self.cartViewModel.removeProductFromCart(index: index, onCompletion: { isRemoved in
                if isRemoved {
                    NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "update_cart")))
                    self.setupView()
                } else {
                    let alertControllerFailure = UIAlertController(title: "Suppression", message: "Une erreur est survenue durant la suppression du produit", preferredStyle: .alert)
                    let actionFailure = UIAlertAction(title: "Fermer", style: .cancel) { (_: UIAlertAction) in
                    }
                    alertControllerFailure.addAction(actionFailure)
                    self.present(alertControllerFailure, animated: true, completion: nil)
                }
            })
        }

        let action2 = UIAlertAction(title: "Annuler", style: .default) { (_: UIAlertAction) in }

        alertController.addAction(action1)
        alertController.addAction(action2)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension CartViewController: ProductCartColissimoTableViewCellDelegate {
    func didPushedReexDetails(product: Product) {
        // PUSH TO Reex Detail Product
        if let viewController = UIStoryboard.init(name: "Cart", bundle: nil).instantiateViewController(withIdentifier: "ReexCartDetailViewControllerID") as? ReexCartDetailViewController {
            viewController.product = product
            self.present(viewController, animated: true, completion: nil)
        }
    }
    
    func didDeletedColissimo(index: Int) {
        let alertController = UIAlertController(title: nil, message: "Êtes-vous sûr de supprimer cet article?", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Oui", style: .default) { (_: UIAlertAction) in
            self.cartViewModel.removeProductFromCart(index: index, onCompletion: { isRemoved in
                if isRemoved {
                    NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "update_cart")))
                    self.setupView()
                } else {
                    let alertControllerFailure = UIAlertController(title: "Suppression", message: "Une erreur est survenue durant la suppression du produit", preferredStyle: .alert)
                    let actionFailure = UIAlertAction(title: "Fermer", style: .cancel) { (_: UIAlertAction) in
                    }
                    alertControllerFailure.addAction(actionFailure)
                    self.present(alertControllerFailure, animated: true, completion: nil)
                }
            })
        }
        
        let action2 = UIAlertAction(title: "Annuler", style: .default) { (_: UIAlertAction) in }
        
        alertController.addAction(action1)
        alertController.addAction(action2)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func didPushedColissimoDetails(product: Product) {
        let viewController = UIStoryboard.init(name: "Cart", bundle: nil).instantiateViewController(withIdentifier: "ColissimoCartDetailViewControllerID") as! ColissimoCartDetailViewController
        viewController.product = product
        self.present(viewController, animated: true, completion: nil)
    }
}

extension CartViewController: CartTotalPriceTableViewCellDelegate {
    func confirmButtonDidTapped(cell: CartTotalPriceTableViewCell) {
        let viewController = R.storyboard.cart.shippingCartViewControllerID()!
        viewController.colissmoCostShipping = String(describing: self.cartViewModel.deliveryCost())
        self.navigationController?.pushViewController(viewController, animated: true)

        // Adjust
        AdjustTaggingManager.sharedManager.trackEventToken(AdjustTaggingManager.kOrderToken, price: Double(self.cartViewModel.totalPrice))

        // Accengage
        AccengageTaggingManager().trackPurchase(order: self.products)
    }
}

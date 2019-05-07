//
//  SearchViewController.swift
//  LaPostePro
//
//  Created by Issam DAHECH on 13/09/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import LPSharedMCM
import UIKit

class SearchViewController: UIViewController {
    // Initial View
    @IBOutlet var indicationLabel: UILabel!
    
    // Search
    @IBOutlet var searchTableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    var searchType: SearchSourceType = .all
    var searchViewModel: SearchViewModel!
    var searchHistoryList = [String]()
    var canRemove = true
    
    var openerViewController: UIViewController?
    
    // Resault
    @IBOutlet var resultTableView: UITableView!
    @IBOutlet var emptyResultView: UIView!
    @IBOutlet var emptyImageView: UIImageView!
    var resultList = [SearchResult]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchViewModel = SearchViewModel(type: searchType)
        self.searchViewModel.openerViewController = self.openerViewController
        self.searchViewModel.searchViewController = self
        refreshData()
        setSearchBar()
        setIndicationLabel()
        
        if searchType == .shop {
            self.searchBar.becomeFirstResponder()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: Notification.Name.UIKeyboardWillShow, object: nil)
        // ATInternet
        let pageName = TaggingData.kSearchPage
        ATInternetTaggingManager.sharedManager.sendTrackPage(pageName: pageName,
                                                             chapter1: nil,
                                                             chapter2: nil,
                                                             level2: searchType.taggingN2)
    }
    
    @objc func keyboardWillAppear() {
        ATInternetTaggingManager.sharedManager.sendTrackPage(pageName: TaggingData.kSearchHome,
                                                             chapter1: TaggingData.kKeyboard,
                                                             chapter2: TaggingData.kHome,
                                                             level2: TaggingData.kSearchLevel)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func backButtonClicked() {
        if let locationRootViewController = self.openerViewController as? LocationRootViewController, self.searchType == .localisator {
            locationRootViewController.searchLocator(self.searchBar.text ?? "")
        }
        self.dismiss(animated: true) {}
    }
    
    func refreshData() {
        searchHistoryList = searchViewModel.getSearchHistory(text: searchBar.text ?? "")
        canRemove = searchBar.text?.isEmpty ?? true
        searchTableView.isHidden = searchHistoryList.isEmpty
        searchTableView.reloadData()
        resultTableView.isHidden = true
        emptyResultView.isHidden = true
    }
    
    func setSearchBar() {
        searchBar.searchBarStyle = UISearchBarStyle.minimal
        searchBar.isTranslucent = true
        switch searchType {
        case .all:
            searchBar.placeholder = "Rechercher un produit, suivi, bureau..."
        case .localisator:
            searchBar.placeholder = "Rechercher un bureau, point retrait, dépôt..."
        case .order:
            searchBar.placeholder = "Rechercher par numéro de commande"
        case .shop:
            searchBar.placeholder = "Rechercher un produit"
        case .follow:
            searchBar.placeholder = "Rechercher un suivi (ex:1L345678901)"
        }
    }
    
    func setIndicationLabel() {
        switch searchType {
        case .all:
            indicationLabel.text = "Tapez un ou plusieurs mots-clés pour rechercher un produit, une référence, un numéro de suivi, un bureau de poste ou un contact."
        case .follow:
            indicationLabel.text = "Tapez le numéro d'envoi ou d'avis de passage pour rechercher un suivi."
        case .shop:
            indicationLabel.text = "Tapez le nom du produit"
        case .localisator:
            indicationLabel.text = "Tapez la ville ou le code postal d'un bureau de poste, point retrait ou dépôt."
        case .order:
            indicationLabel.text = "Tapez en partie ou intégralement un  numéro de commande pour rechercher."
        }
    }
    
    func loadResult() {
        // ATInternet
        let pageName = TaggingData.kResultPage
        ATInternetTaggingManager.sharedManager.sendTrackPage(pageName: pageName,
                                                             chapter1: nil,
                                                             chapter2: nil,
                                                             level2: searchType.taggingN2)
        
        self.emptyResultView.isHidden = true
        self.resultTableView.isHidden = false
        if resultList.isEmpty {
            self.emptyResultView.isHidden = false
            self.emptyImageView.image = searchViewModel.imageFromType()
        }
        self.resultTableView.reloadData()
    }
    
    func executeOrderAndShop() {
        switch self.searchType {
        case .order:
            if searchBar.text != nil, let searchText = searchBar.text {
                OrderViewModel().getOrdersSearch(searchString: searchText) { ordersForShow in
                    if ordersForShow != nil {
                        if !ordersForShow!.1.isEmpty {
                            if !ordersForShow!.1[0].isEmpty {
                                if let history = self.openerViewController as? HistoryOrdersViewController {
                                    history.searchString = searchText
                                }
                                self.dismiss(animated: true, completion: nil)
                            } else {
                                self.resultTableView.isHidden = true
                                self.emptyResultView.isHidden = false
                                self.emptyImageView.image = R.image.img_search_shop()
                            }
                        } else {
                            self.resultTableView.isHidden = true
                            self.emptyResultView.isHidden = false
                            self.emptyImageView.image = R.image.img_search_shop()
                        }
                    }
                }
            }
        case .shop:
            self.searchViewModel.loaderManager.showLoderView()
            self.searchViewModel.getListProduct(searchText: searchBar.text ?? "") { searchResult in
                self.searchViewModel.loaderManager.hideLoaderView()
                if !searchResult.list.isEmpty {
                    if let category = self.openerViewController as? CategoryViewController {
                        category.openSearch(str: self.searchBar.text ?? "")
                        self.dismiss(animated: true, completion: nil)
                    }
                    if let product = self.openerViewController as? ProductListViewController {
                        product.searchString = self.searchBar.text ?? ""
                        product.applySearch()
                        product.productViewModel.reset()
                        self.dismiss(animated: true, completion: nil)
                    }
                }
                else {
                    self.resultTableView.isHidden = true
                    self.emptyResultView.isHidden = false
                    self.emptyImageView.image = R.image.img_search_shop()
                }
            }
        default:
            break
        }
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == resultTableView {
            return resultList.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == resultTableView {
            return resultList[section].list.count
        }
        return searchHistoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == resultTableView {
            return resultList[indexPath.section].list[indexPath.row]
        }
        else {
            let text = searchHistoryList[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.searchHistoryCell, for: indexPath)
            cell?.configureCell(text: text, canRemove: canRemove)
            cell?.delegate = self
            return cell ?? UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == resultTableView {
            return 40
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == resultTableView {
            let text = resultList[section].title
            let view = ResultHeaderView.getHeaderWithText(text)
            if resultList[section].list.count < 3 {
                view?.showAllButton.isHidden = true
            }
            else {
                view?.showAllClosure = resultList[section].showAllClosure
                view?.showAllButton.isHidden = (resultList[section].showAllClosure == nil)
            }
            return view
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == resultTableView {
            if let cell = resultTableView.cellForRow(at: indexPath) as? SearchResultLocalisatorCell {
                guard let detailViewController = R.storyboard.location.locationDetailViewController() else {
                    return
                }
                detailViewController.detailPostalOffice = cell.postalOffice
                self.present(detailViewController, animated: true) {
                    detailViewController.viewStatus = .list
                }
            }
            if resultTableView.cellForRow(at: indexPath) is SearchProductCell {
                guard let detailProductViewController = R.storyboard.eBoutique.productViewControllerID() else {
                    return
                }
                self.searchViewModel.loaderManager.showLoderView()
                self.searchViewModel.hybProductFor(index: indexPath.row) { product in
                    detailProductViewController.productDetailViewModel.product = product
                    self.searchViewModel.loaderManager.hideLoaderView()
                    self.navigationController?.pushViewController(detailProductViewController, animated: true)
                }
            }
            if let cell = resultTableView.cellForRow(at: indexPath) as? SearchShipmentCell {
                guard let detailFollowViewController = R.storyboard.follow.followDetailViewControllerID() else {
                    return
                }
                detailFollowViewController.responseTrack = cell.responseTrack
                self.navigationController?.pushViewController(detailFollowViewController, animated: true)
            }
        }
        else {
            searchBar.resignFirstResponder()
            let text = searchHistoryList[indexPath.row]
            self.searchBar.text = text
            self.searchViewModel.userDidSearchWith(text: text) { [weak self] result in
                if self?.searchType == .shop || self?.searchType == .order {
                    self?.executeOrderAndShop()
                }
                else {
                    self?.resultList = result
                    self?.loadResult()
                }
            }
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        refreshData()
        ATInternetTaggingManager.sharedManager.sendTrackPage(pageName: TaggingData.kResultPage,
                                                             chapter1: TaggingData.kKeyboard,
                                                             chapter2: TaggingData.kHome,
                                                             level2: TaggingData.kSearchLevel)
        searchViewModel.userDidSearchWith(text: searchBar.text ?? "") { [weak self] result in
            if self?.searchType == .shop || self?.searchType == .order {
                self?.executeOrderAndShop()
            }
            else {
                self?.resultList = result
                self?.loadResult()
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        refreshData()
    }
}

extension SearchViewController: SearchHistoryCellDelegate {
    func didRemoveSearchText(text: String) {
        searchViewModel.removeItem(text: text)
        refreshData()
    }
}

extension SearchViewController: ProductCellDelegate {
    func deleteProduct(product: Product) {}
    
    func addProductToCart(product: Product) {
        CartViewModel.sharedInstance.addProductToCart(product: product, quantityToAdd: 1, onCompletion: { added, _ in
            if added {
                let toastConfiguration = Toast(title: "Produit ajouté au panier", titleColor: .white, backgroundColor: .lpPurple, viewController: self, duration: 2)
                let toast = ToastView()
                VibrationHelper.addToCart()
                toast.drawToast(toast: toastConfiguration)
                NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "update_cart")))
                
                // ATInternet
                ATInternetTaggingManager.sharedManager.sendTrackClick(clickLibelle: TaggingData.kCtaAjoutPanier, pageName: nil, chapter1: TaggingData.kProductsList, chapter2: nil, level2: TaggingData.kCommerceLevel)
                
                // Adjust
                AdjustTaggingManager.sharedManager.trackEventToken(AdjustTaggingManager.kAddToCartToken)
                
                // Accengage
                
                AccengageTaggingManager().trackAddToCart(product: product)
                
                // Weborama tag
                
                let ccuId = UserAccount.shared.customerInfo?.displayUid?.sha256() ?? ""
                let key = PixelWeboramaManager().getKey(from: "Recherche", and: .vis)
                PixelWeboramaManager().sendWeboramaTag(tagToSend: key, ccuIDCryptedValue: ccuId)
            }
        })
    }
}

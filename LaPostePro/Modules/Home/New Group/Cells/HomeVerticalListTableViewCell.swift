//
//  HomeVerticalListTableViewCell.swift
//  LaPostePro
//
//  Created by Mohamed Helmi Ben Jabeur on 14/05/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

class HomeVerticalListTableViewCell: UITableViewCell {
    
    weak var delegate: CartViewControllerDelegate?
    var homeViewModel = HomeViewModel()
    var subMenuTableView: UITableView?
    var module = Module.init() {
        didSet {
            if (cellTitle != nil) {
                self.cellTitle.text = module.moduleName!
            }
        }
    }

    @IBOutlet weak var titleIconImageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tableViewContainer: UIView!
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cellTitle: UILabel! {
        didSet {
            if (module.moduleName != nil) {
                self.cellTitle.text = module.moduleName!
            }
        }
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    func setUpCell(module: Module) {
        self.module = module
        subMenuTableView = UITableView(frame: .zero, style: UITableViewStyle.plain)
        subMenuTableView?.delegate = self
        subMenuTableView?.dataSource = self
        subMenuTableView?.register(UINib(nibName: "HomeVerticalListItemTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeVerticalListItemTableViewCellID")
        subMenuTableView?.register(UINib(nibName: "HomeCTAVerticalListTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeCTAVerticalListTableViewCellID")
        subMenuTableView?.isScrollEnabled = false
        subMenuTableView?.separatorStyle = .none
        if (containerView != nil) {
            for view in tableViewContainer.subviews{
                view.removeFromSuperview()
            }
            containerView.layer.borderColor = UIColor.lpGrayShadow.cgColor
            containerView.layer.borderWidth = 1
            containerView.layer.cornerRadius = 5
            tableViewContainer.addSubview(subMenuTableView!)
            containerView.clipsToBounds = true
            self.addConstraintToTableView()
        }
        
        if (self.cellTitle != nil && module.moduleName != nil) {
            self.cellTitle.text = module.moduleName ?? ""
        }

        titleIconImageView.image = homeViewModel.getVerticalListIcon(for: module.contentType!)
        titleIconImageView.tintImageColor(color: .lpGrey)
        titleIconImageView.contentMode = .scaleAspectFit
        
        subMenuTableView?.rowHeight = UITableViewAutomaticDimension
        subMenuTableView?.estimatedRowHeight = 120
        contentViewHeightConstraint.constant = subMenuTableView?.contentSize.height ?? 610
    }
}

extension HomeVerticalListTableViewCell: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (module.items != nil) {
            if (module.items!.count >= 3) {
                return 4
            } else {
                return module.items!.count + 1
            }
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if (indexPath.row <= module.items!.count - 1 && indexPath.row <= 2) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeVerticalListItemTableViewCellID", for: indexPath) as! HomeVerticalListItemTableViewCell
            if indexPath.row == 0 {
                cell.hideSeparator = true
            }
            cell.listContentType = self.module.contentType
            cell.setupCell(product: module.items![indexPath.row], homeViewModel: self.homeViewModel)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCTAVerticalListTableViewCellID", for: indexPath) as! HomeCTAVerticalListTableViewCell
            cell.setupCell(module: module, homeViewModel: homeViewModel)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var index = 0
        if (module.items!.count >= 3) {
            index = 3
        } else {
            index = module.items!.count
        }
        
        if indexPath.row != index, let product = module.items?[indexPath.row] {
            delegate?.showDetails(for: product)
        } else {
            switch module.contentType {
            case .lastBuyList?:
                if let homeViewController = parentViewController as? HomeViewController {
                    // ATInternet
                    ATInternetTaggingManager.sharedManager.sendTrackClick(clickLibelle: TaggingData.kVoirDerniereCommande,
                                                                          pageName: nil,
                                                                          chapter1: TaggingData.kHomeConnected,
                                                                          chapter2: TaggingData.kArticles,
                                                                          level2: TaggingData.kHomeLevel)

                    let viewModel = OrderViewModel()
                    viewModel.getLastOrder { order in
                        if order != nil {
                            let viewController = R.storyboard.order.orderDetailViewController()!
                            viewController.viewModel = viewModel
                            homeViewController.navigationController?.viewControllers.append(viewController)
                            
                        }
                    }
                }
            case .cartList?:
                if let homeViewController = parentViewController as? HomeViewController {
                    ATInternetTaggingManager.sharedManager.sendTrackClick(clickLibelle: TaggingData.kFinaliserCommande,
                                                                          pageName: nil,
                                                                          chapter1: TaggingData.kHomeConnected,
                                                                          chapter2: TaggingData.kArticles,
                                                                          level2: TaggingData.kHomeLevel)

                    let viewController = R.storyboard.cart.shippingCartViewControllerID()!
                    viewController.colissmoCostShipping = String(describing: CartViewModel.sharedInstance.deliveryCost())
                    viewController.isModel = true
                    let navigationController = UINavigationController(rootViewController: viewController)
                    homeViewController.present(navigationController, animated: true, completion: {
                        homeViewController.navigationController?.popToRootViewController(animated: false)
                    })
                }
            case .favoritesList?:
                if let homeViewController = parentViewController as? HomeViewController ?? parentViewController as? CartViewController {
                    // ATInternet
                    ATInternetTaggingManager.sharedManager.sendTrackClick(clickLibelle: TaggingData.kVoirFavoris,
                                                                          pageName: nil,
                                                                          chapter1: TaggingData.kHomeConnected,
                                                                          chapter2: TaggingData.kArticles,
                                                                          level2: TaggingData.kHomeLevel)
                    
                    let viewController = R.storyboard.account.favoritesViewControllerID()!
                    homeViewController.navigationController?.pushViewController(viewController, animated: true)
                }
            default:
                break
            }
        }
    }

    func addConstraintToTableView() {
        subMenuTableView?.translatesAutoresizingMaskIntoConstraints = false
        let trailingConstraint = NSLayoutConstraint(item: subMenuTableView!, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: tableViewContainer, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0)
        let leadingConstraint = NSLayoutConstraint(item: subMenuTableView!, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: tableViewContainer, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
        let topConstraint = NSLayoutConstraint(item: subMenuTableView!, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: tableViewContainer, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: subMenuTableView!, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: tableViewContainer, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        tableViewContainer.addConstraints([trailingConstraint, leadingConstraint, topConstraint, bottomConstraint])
        self.layoutIfNeeded()
    }

    override func prepareForReuse() {
        self.subMenuTableView = nil
        self.cellTitle.text = ""
    }
}



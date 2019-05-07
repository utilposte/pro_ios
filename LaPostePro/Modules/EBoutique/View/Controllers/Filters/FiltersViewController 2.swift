//
//  FiltersViewController.swift
//  LaPostePro
//
//  Created by Lassad Tiss on 29/05/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit
import LPSharedMCM

protocol FiltersViewControllerDelegate: class {
    func tableViewShouldReloadData()
}

class FiltersViewController: UIViewController {

    weak var delegate: FiltersViewControllerDelegate?
    let productViewModel: ProductViewModel = ProductViewModel()
    var categoryID: String?
    var selectedSort = ""
    
    @IBOutlet weak var filtersButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var segmentedControlHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var collectionViewHeightConstaint: NSLayoutConstraint!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var containerView: UIView!
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

    private lazy var conditioningViewController: ConditioningViewController = {
        var viewController = R.storyboard.eBoutique.conditioningViewControllerID()!
        viewController.selectedSort = selectedSort
        viewController.delegate = self
        self.add(asChildViewController: viewController)
        return viewController
    }()

    private lazy var themesViewController: ThemesViewController = {
        var viewController = R.storyboard.eBoutique.themesViewControllerID()!
        viewController.selectedSort = selectedSort
        self.add(asChildViewController: viewController)
        viewController.delegate = self
        return viewController
    }()

    var containsThematique: Bool = {
        CurrentFacet.shared.conditions.contains { condition -> Bool in
            condition.categoryName == "listThematiques"
        }
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBarCustom()
        self.setupView()
        self.setupCollectionView()
        self.setupFilterButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.collectionView.reloadData()

        if containsThematique {
            self.segmentedControlHeightConstraint.constant = 53
        } else {
            self.segmentedControlHeightConstraint.constant = 0
        }

        self.adjustHashTagCollectionView()
    }

    private func setupView() {
        self.setupSegmentedControl()
        self.updateView()
    }

    private func setupNavigationBarCustom() {
        let rightBarButton: UIBarButtonItem = UIBarButtonItem(title: "Effacer tout", style: .plain, target: self, action: #selector(FiltersViewController.clearAllFilters))
        self.title = "Filtrer"
        self.navigationItem.backBarButtonItem?.title = "Retour"
        self.navigationItem.rightBarButtonItem = rightBarButton
    }

    private func setupCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }

    private func setupFilterButton() {
        self.filterButton.layer.cornerRadius = self.filterButton.frame.height / 2
        self.filterButton.backgroundColor = .lpPurple
        if CurrentFacet.shared.filterValue.isEmpty {
            self.updateFilterButton(filterValue: "Voir les résultats")
        } else {
            self.updateFilterButton(filterValue: CurrentFacet.shared.filterValue)
        }
        self.filterButton.titleEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    }

    private func adjustHashTagCollectionView() {
        if CurrentFacet.shared.conditionsSelected.isEmpty {
            self.collectionViewHeightConstaint.constant = 0
        } else {
            self.collectionViewHeightConstaint.constant = 55
        }
    }

    private func updateView() {
        if segmentedControl.selectedSegmentIndex == 0 {
            remove(asChildViewController: themesViewController)
            add(asChildViewController: conditioningViewController)
        } else {
            remove(asChildViewController: conditioningViewController)
            add(asChildViewController: themesViewController)
        }
    }

    private func setupSegmentedControl() {
        segmentedControl.addTarget(self, action: #selector(selectionDidChange(_:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
    }

    @objc func selectionDidChange(_ sender: UISegmentedControl) {
        updateView()
    }

    private func add(asChildViewController viewController: UIViewController) {
        addChildViewController(viewController)
        containerView.addSubview(viewController.view)
        viewController.view.frame = containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParentViewController: self)
    }

    private func remove(asChildViewController viewController: UIViewController) {
        viewController.willMove(toParentViewController: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
    }

    @objc func clearAllFilters() {
        // CLEAR ALL FILTERS
        CurrentFacet.shared.clearAllFilters()
        CurrentFacet.shared.createQuery()

        self.collectionView.reloadData()
        self.delegate?.tableViewShouldReloadData()
        self.adjustHashTagCollectionView()

        self.productViewModel.getProductListWithFilter(filter: String(format: Constants.defaultQueryProductList, selectedSort, "\(self.categoryID ?? ""):\(CurrentFacet.shared.queryFilterTmp)"), nextPageEnabled: false) { isSuccess, _ in
            if isSuccess {
                self.updateFilterButton(filterValue: CurrentFacet.shared.filterValue)
            } else {
                let alertController: UIAlertController = UIAlertController(title: "Ooops", message: "An Error Occured", dismissActionTitle: "Fermer", dismissActionBlock: {})
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    private func updateFilterButton(filterValue: String) {
        let label = UILabel()
        label.text = filterValue
        let labelSize = label.intrinsicContentSize.width + 50
        self.filterButton.setTitle(filterValue, for: .normal)
        self.filtersButtonWidthConstraint.constant = labelSize
        self.view.layoutIfNeeded()
    }

    @IBAction func filterButtonTapped(_ sender: Any) {
        CurrentFacet.shared.queryFilter = CurrentFacet.shared.queryFilterTmp
        self.navigationController?.popViewController(animated: true)
    }
}

extension FiltersViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CurrentFacet.shared.conditionsSelected.count
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: HashTagCollectionViewCell = self.collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.hashTagCollectionViewCellID.identifier, for: indexPath) as! HashTagCollectionViewCell
        let item = CurrentFacet.shared.conditionsSelected[indexPath.row]

        cell.hashTagLabel.text = CurrentFacet.shared.conditions[item.section].choices![item.row].choiceName
        cell.hashTagLabel.textColor = .white
        cell.hashTagLabel.font = UIFont.boldSystemFont(ofSize: 14)
        cell.contentView.backgroundColor = .lpPurple
        cell.contentView.layer.cornerRadius = 17.5
        cell.currentIndexPath = indexPath
        cell.delegate = self
        return cell
    }

}

extension FiltersViewController: UICollectionViewDelegateFlowLayout {

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

        self.collectionView.reloadData()
        self.collectionView.collectionViewLayout.invalidateLayout()
        self.adjustHashTagCollectionView()
        self.delegate?.tableViewShouldReloadData()

        self.productViewModel.getProductListWithFilter(filter: String(format: Constants.defaultQueryProductList, selectedSort, "\(self.categoryID ?? ""):\(CurrentFacet.shared.queryFilterTmp)"), nextPageEnabled: false) { isSuccess, _ in
            if isSuccess {
                self.updateFilterButton(filterValue: CurrentFacet.shared.filterValue)
            } else {
                let alertController: UIAlertController = UIAlertController(title: "Ooops", message: "An Error Occured", dismissActionTitle: "Fermer", dismissActionBlock: {})
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
}

extension FiltersViewController: ConditioningViewControllerDelegate {
    func collectionViewShouldReload(class: ConditioningViewController) {
        self.collectionView.reloadData()
        self.adjustHashTagCollectionView()
    }
}

extension FiltersViewController: ThemesViewControllerDelegate {
    func collectionViewShouldReload(class: ThemesViewController) {
        self.collectionView.reloadData()
        self.adjustHashTagCollectionView()
    }
}

extension FiltersViewController: HashTagCollectionViewCellDelegate {
    func crossButtonDidTapped(indexPath: IndexPath) {
        let item = CurrentFacet.shared.conditionsSelected.remove(at: indexPath.row)
        CurrentFacet.shared.conditions[item.section].choices![item.row].isChecked = false

        CurrentFacet.shared.createQuery()

        self.collectionView.reloadData()
        self.collectionView.collectionViewLayout.invalidateLayout()
        self.adjustHashTagCollectionView()
        self.delegate?.tableViewShouldReloadData()

        self.productViewModel.getProductListWithFilter(filter: String(format: Constants.defaultQueryProductList, selectedSort, "\(self.categoryID ?? ""):\(CurrentFacet.shared.queryFilterTmp)"), nextPageEnabled: false) { isSuccess, _ in
            if isSuccess {
                self.updateFilterButton(filterValue: CurrentFacet.shared.filterValue)
            } else {
                let alertController: UIAlertController = UIAlertController(title: "Ooops", message: "An Error Occured", dismissActionTitle: "Fermer", dismissActionBlock: {})
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
}

//
//  CarouselTableViewCell.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 07/05/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

protocol CarouselTableViewCellDelegate: class {
    func didCellTapped(indexPath: IndexPath, cell: CarouselTableViewCell)
}

class CarouselTableViewCell: UITableViewCell {

    // MARK: Properties
    weak var delegate: CarouselTableViewCellDelegate?
    internal var currentSection: Int?
    var module: Module?
    var carouselViewModel = CarouselViewModel()
    let productViewModel = ProductViewModel()

    // MARK: IBOutlets
    @IBOutlet weak var titleSectionLabel: UILabel!
    @IBOutlet weak var seeAllButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            layout.itemSize = CGSize(width: 150, height: 280)

            layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 1)
            layout.scrollDirection = .horizontal
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0

            collectionView.collectionViewLayout = layout
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none

        self.collectionView.register(UINib(nibName: "CarouselCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CarouselCollectionViewCellID")
        self.collectionView.reloadData()
    }

    func setupUpCell(with module: Module) {
        self.module = module
        self.setupTitleSection()
        self.setupSeeAllButton()
        self.setupCollectionView()
    }

    func setupTitleSection() {
        self.titleSectionLabel.text = carouselViewModel.getTitleForCarouselItem(contentType: (module?.contentType)!)
        self.titleSectionLabel.font = UIFont.boldSystemFont(ofSize: 18)
    }

    func setupSeeAllButton() {
//        self.seeAllButton.setTitle("Tout voir", for: .normal)
//        self.seeAllButton.titleLabel?.textColor = .lpPurple
        self.seeAllButton.isEnabled = false
        self.seeAllButton.isHidden = true
        // ADD Action ?
    }

    func setupCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.reloadData()
    }
}

extension CarouselTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "CarouselCollectionViewCellID", for: indexPath) as! CarouselCollectionViewCell
        cell.contentType = module?.contentType
        cell.setUpCell(with: (module?.items![indexPath.row])!, and: productViewModel)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (module?.items?.count)!
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func heightForCell() -> CGFloat {
        return 280
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let currentSection = self.currentSection else { return }
        
        if ((module?.contentType = .bestSellCarousel) != nil) {
            // ATInternet
            ATInternetTaggingManager.sharedManager.sendTrackClick(clickLibelle: TaggingData.kMeilleuresVentes,
                                                                  pageName: nil,
                                                                  chapter1: TaggingData.kPushCrossSelling,
                                                                  chapter2: nil,
                                                                  level2: TaggingData.kTransverseLevel)
        }

        
        let currentIndexPath = IndexPath(row: indexPath.row, section: currentSection)
        self.delegate?.didCellTapped(indexPath: currentIndexPath, cell: self)
    }

}

//
//  LocationFilterTableViewCell.swift
//  LaPostePro
//
//  Created by Mohamed Helmi Ben Jabeur on 03/08/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

enum FilterType {
    case day
    case pointType
    case pointTypeBp
}

class LocationFilterTableViewCell: UITableViewCell {

    @IBOutlet weak var filterTitleLabel: UILabel!
    @IBOutlet weak var filterValueCollectionView: UICollectionView!
    
    //PROPRETIES
    let viewModel = LocationFilterViewModel()
    var cellType: FilterType?
    var itemSelectedIndex = 0
    var delegate: LocationFilterDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 10) / 4, height: 50)
        layout.minimumInteritemSpacing = 0
        if filterValueCollectionView != nil {
            filterValueCollectionView.collectionViewLayout = layout
        }
        filterValueCollectionView.delegate = self
        filterValueCollectionView.dataSource = self
        
    }
    
    func setup(with type: FilterType) {
        filterTitleLabel.text = viewModel.getFilterTitle(type: type)
        cellType = type
        setupCollectionViewLayout(withItemNumber: viewModel.getNumberOfItems(type: type))
    }
    
    private func setupCollectionViewLayout(withItemNumber number: CGFloat) {
        if let collectionViewLayout = filterValueCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            collectionViewLayout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 10) / number, height: 50)
            collectionViewLayout.prepare()
            collectionViewLayout.invalidateLayout()
        }
    }
    
    func resetContent() {
        self.itemSelectedIndex = 0
        self.filterValueCollectionView.reloadData()
    }
}

extension LocationFilterTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch cellType! {
        case .day:
            return Constants.daysList.count
        case .pointType:
            return Constants.pointTypeList.count
        case .pointTypeBp:
            return Constants.pointTypeList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LocationFilterValueCollectionViewCell", for: indexPath) as! LocationFilterValueCollectionViewCell
        cell.setup(with: cellType!, index: indexPath.row, isSelected: indexPath.row == itemSelectedIndex)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        itemSelectedIndex = indexPath.row
        delegate?.filterSelected()
        collectionView.reloadData()
    }
}

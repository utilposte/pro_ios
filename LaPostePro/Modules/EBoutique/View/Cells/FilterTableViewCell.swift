//
//  FilterTableViewCell.swift
//  LaPostePro
//
//  Created by Lassad Tiss on 29/05/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

protocol FilterTableViewCellDelegate: class {
    func itemDidTapped(cell: FilterTableViewCell, indexPath: IndexPath, item: ConditionChoice)
}

enum SizeConditionCell {
    case tall
    case small
}

class FilterTableViewCell: UITableViewCell {

    var productArray = [ConditionChoice]()
    var sizeCell: SizeConditionCell?
    var currentSection: Int?

    weak var delegate: FilterTableViewCellDelegate?

    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
            layout.scrollDirection = .vertical
            layout.minimumInteritemSpacing = 1

            collectionView.collectionViewLayout = layout
            collectionView.isScrollEnabled = false
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.reloadData()
        self.collectionView.collectionViewLayout.invalidateLayout()
    }

    private func smallSizeItem() -> CGSize {
        return CGSize(width: (Int(UIScreen.main.bounds.width / 4)) - 15, height: 50)
    }

    private func tallSizeItem() -> CGSize {
        return CGSize(width: (Int(UIScreen.main.bounds.width / 2)) - 25, height: 50)
    }
    
    func getFilterEnum(string: String) -> String {
        return filters.init(rawValue: string)?.realName ?? ""
    }
}

extension FilterTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ConditionsCollectionViewCell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "ConditionsCollectionViewCellID", for: indexPath) as! ConditionsCollectionViewCell

        let item = self.productArray[indexPath.row]
        
        if item.choiceName == "true" || item.choiceName == "false" {
            cell.conditionLabel.text = self.getFilterEnum(string: item.choiceName!)
        } else {
            cell.conditionLabel.text = item.choiceName
        }
        cell.conditionLabel.numberOfLines = 2
        cell.conditionLabel.textAlignment = .center
        cell.customView.layer.borderWidth = 1
        cell.customView.layer.cornerRadius = 5

        if item.isChecked {
            cell.conditionLabel.textColor = .black
            cell.conditionLabel.font = UIFont.boldSystemFont(ofSize: 14)
            cell.customView.layer.borderColor = UIColor.lpPurple.cgColor
            cell.checkImage.isHidden = false
            cell.checkImage.tintImageColor(color: .lpPurple)
        } else {
            cell.conditionLabel.textColor = UIColor.lpGrey
            cell.conditionLabel.font = UIFont.systemFont(ofSize: 14)
            cell.customView.layer.borderColor = UIColor.lpGrayShadow.cgColor
            cell.checkImage.isHidden = true
            cell.checkImage.tintImageColor(color: .lpPurple)
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = self.productArray[indexPath.row]
        self.delegate?.itemDidTapped(cell: self, indexPath: IndexPath.init(row: indexPath.row, section: self.currentSection ?? 0), item: item)
    }
}

extension FilterTableViewCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.productArray.count
    }
}

extension FilterTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if sizeCell == .tall {
//            return self.tallSizeItem()
//        } else {
//        return self.smallSizeItem()
        return self.tallSizeItem()
//        }
    }
}

//
//  ColissimoHomeServices.swift
//  LPColissimoUI
//
//  Created by Issam DAHECH on 19/10/2018.
//

import UIKit
import LPColissimo

class ColissimoHomeServices: NSObject {
    
    func getImagesForPager() -> [UIImage] {
        let images = [ColissimoHomeServices.loadImage(name: "hp-colissimo1.jpg"), ColissimoHomeServices.loadImage(name: "hp-colissimo2.jpg"), ColissimoHomeServices.loadImage(name: "hp-colissimo3.jpg"), ColissimoHomeServices.loadImage(name: "hp-colissimo4.jpg"), ColissimoHomeServices.loadImage(name: "hp-colissimo5.jpg")]
        
        return images as? [UIImage] ?? [UIImage]()
    }
    
    class func loadImage(name: String) -> UIImage? {
        let podBundle = Bundle(for: self.classForCoder())
        if let bundleURL = podBundle.url(forResource: "LPColissimoUI_Images", withExtension: "bundle") {
            if let bundle = Bundle(url: bundleURL) {
                return UIImage(named: name, in: bundle, compatibleWith: nil)
            }
        }
        return nil
    }
    
    func getTutorialGuideData() -> [HomeGuideViewModel]{
        var result = [HomeGuideViewModel]()
        // First Guide Part
        var firstGuide = HomeGuideViewModel(idGuide: 1)
        firstGuide.title = LocalizedColissimoUI(key: "k_home_guide_title_1")
        firstGuide.isExpanded = true
        var firstGuideDetailOne = HomeGuideDetailViewModel(idGuide: 11)
        firstGuideDetailOne.text = LocalizedColissimoUI(key: "k_home_guide_detail_text_1")
        firstGuideDetailOne.images = ["icon-guide-colis01.png","icon-guide-colis02.png"]
        firstGuide.details.append(firstGuideDetailOne)
        result.append(firstGuide)
        
        // Second Guide Part
        var secondGuide = HomeGuideViewModel(idGuide: 2)
        secondGuide.title = LocalizedColissimoUI(key: "k_home_guide_title_2")
        secondGuide.subTitle = LocalizedColissimoUI(key: "k_home_guide_sub_title_2")
        var secondGuideDetailOne = HomeGuideDetailViewModel(idGuide: 21)
        secondGuideDetailOne.title = LocalizedColissimoUI(key: "k_home_guide_detail_title_2_1")
        secondGuideDetailOne.text = LocalizedColissimoUI(key: "k_home_guide_detail_text_2_1")
        secondGuideDetailOne.images = ["icon-guide-colis03.png","icon-guide-colis04.png"]
        secondGuideDetailOne.isExpandable = true
        secondGuideDetailOne.isExpanded = true
        secondGuide.details.append(secondGuideDetailOne)
        var secondGuideDetailTwo = HomeGuideDetailViewModel(idGuide: 22)
        secondGuideDetailTwo.title = LocalizedColissimoUI(key: "k_home_guide_detail_title_2_2")
        secondGuideDetailTwo.text = LocalizedColissimoUI(key: "k_home_guide_detail_text_2_2")
        secondGuideDetailTwo.images = ["icon-guide-colis05.png","icon-guide-colis04.png"]
        secondGuideDetailTwo.isExpandable = true
        secondGuide.details.append(secondGuideDetailTwo)
        var secondGuideDetailThree = HomeGuideDetailViewModel(idGuide: 23)
        secondGuideDetailThree.title = LocalizedColissimoUI(key: "k_home_guide_detail_title_2_3")
        secondGuideDetailThree.text = LocalizedColissimoUI(key: "k_home_guide_detail_text_2_3")
        secondGuideDetailThree.images = ["icon-guide-colis06.png"]
        secondGuideDetailThree.isExpandable = true
        secondGuide.details.append(secondGuideDetailThree)
        result.append(secondGuide)
        
        // Third Guide Part
        var thirdGuide = HomeGuideViewModel(idGuide: 3)
        thirdGuide.title = LocalizedColissimoUI(key: "k_home_guide_title_3")
        var thirdGuideDetailOne = HomeGuideDetailViewModel(idGuide: 31)
        thirdGuideDetailOne.text = LocalizedColissimoUI(key: "k_home_guide_detail_text_3")
        thirdGuideDetailOne.images = ["icon-guide-colis07.png"]
        thirdGuide.details.append(thirdGuideDetailOne)
        result.append(thirdGuide)
        
        return result
    }
    
    func getAdvantagesData() -> [HomeAdvantageViewModel]{
        var result = [HomeAdvantageViewModel]()
        for i in 1...7 {
            var advantage = HomeAdvantageViewModel()
            advantage.title = LocalizedColissimoUI(key: "k_home_advantage_title_\(i)")
            advantage.description = LocalizedColissimoUI(key: "k_home_advantage_description_\(i)")
            if i == 1 {
                advantage.icon = ColissimoHomeServices.loadImage(name: "icon-livraison.png")
            }
            else if i == 2 {
                advantage.icon = ColissimoHomeServices.loadImage(name: "icon-send-colis.png")
            }
            result.append(advantage)
        }
        return result
    }
}

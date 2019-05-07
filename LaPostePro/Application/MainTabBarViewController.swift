//
//  MainTabBarViewController.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 04/05/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // ATInternet
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let index = tabBar.items?.index(of: item)
        switch index {
        case 0:
            ATInternetTaggingManager.sharedManager.sendTrackClick(clickLibelle: TaggingData.kHomePro,
                                                                  pageName: nil,
                                                                  chapter1: TaggingData.kTabBar,
                                                                  chapter2: nil,
                                                                  level2: TaggingData.kTransverseLevel)
        case 1:
            ATInternetTaggingManager.sharedManager.sendTrackClick(clickLibelle: TaggingData.kBoutique,
                                                                  pageName: nil,
                                                                  chapter1: TaggingData.kTabBar,
                                                                  chapter2: nil,
                                                                  level2: TaggingData.kTransverseLevel)
        case 2:
            ATInternetTaggingManager.sharedManager.sendTrackClick(clickLibelle: TaggingData.kKocaliser,
                                                                  pageName: nil,
                                                                  chapter1: TaggingData.kTabBar,
                                                                  chapter2: nil,
                                                                  level2: TaggingData.kTransverseLevel)
        case 3:
            ATInternetTaggingManager.sharedManager.sendTrackClick(clickLibelle: TaggingData.kSuivre,
                                                                  pageName: nil,
                                                                  chapter1: TaggingData.kTabBar,
                                                                  chapter2: nil,
                                                                  level2: TaggingData.kTransverseLevel)
        default:
            ATInternetTaggingManager.sharedManager.sendTrackClick(clickLibelle: TaggingData.kHomePro,
                                                                  pageName: nil,
                                                                  chapter1: TaggingData.kTabBar,
                                                                  chapter2: nil,
                                                                  level2: TaggingData.kTransverseLevel)
        }
    }

    func showTab(_ tab: TabBarItem) {
        self.selectedIndex = tab.rawValue
    }
    
    func pushCart() {
        self.selectedIndex = TabBarItem.home.rawValue
        NotificationCenter.default.post(name: NSNotification.Name.init("laposte.deeplink.showcart"), object: nil)
    }
    
    func pushOrders() {
        self.selectedIndex = TabBarItem.home.rawValue
        NotificationCenter.default.post(name: NSNotification.Name.init("laposte.deeplink.showorders"), object: nil)
    }
}

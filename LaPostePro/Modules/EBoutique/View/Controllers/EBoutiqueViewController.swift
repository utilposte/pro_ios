//
//  EBoutiqueViewController.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 17/05/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

class EBoutiqueViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLogoNavigationBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }

    @IBAction func redirectToCart(_ sender: Any) {
        let viewController = R.storyboard.cart.cartViewControllerID()!
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

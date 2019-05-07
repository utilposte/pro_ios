//
//  HomeViewController.swift
//  LaPostePro
//
//  Created by Yonael Tordjman on 04/05/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    // MARK: IBOutlet
    @IBOutlet weak var cartButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.cartButton.setTitle("Allez au panier", for: .normal)
    }

    // MARK: Actions
    @IBAction func cartButtonTapped(_ sender: Any) {
        guard let viewController = R.storyboard.cart.cartViewControllerID() else { return }
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

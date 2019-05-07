//
//  DisconnectionViewController.swift
//  LaPostePro
//
//  Created by Lassad Tiss on 09/07/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit
import RealmSwift

class DisconnectionViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var speechLabel: UILabel!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.headerView.roundCorners([.topLeft, .topRight], radius: 20)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.animate(withDuration: 0, delay: 0, options: [], animations: {
            self.backgroundView.alpha = 0
            
            //self.containerView.backgroundColor = .clear
            self.view.backgroundColor = .clear
        }) { isFinished in
            if isFinished {
                UIView.animate(withDuration: 0.7, animations: {
                    self.backgroundView.alpha = 0.7
                    self.backgroundView.backgroundColor = .lpGrey
                })
            }
        }
        
        // ATInternet
        ATInternetTaggingManager.sharedManager.sendTrackPage(pageName: TaggingData.kPopinDisconnect,
                                                             chapter1: nil,
                                                             chapter2: nil,
                                                             level2: TaggingData.kAccountLevel)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.speechLabel.text = "Rassurez-vous, vos données resteront accessibles après la déconnexion. À très bientôt \(UserAccount.shared.customerInfo?.firstName ?? "") !"
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(ForgottenPasswordViewController.closeButtonTapped(_:)))
        swipeGesture.direction = .down
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ForgottenPasswordViewController.closeButtonTapped(_:)))
        
        self.backgroundView.addGestureRecognizer(tapGesture)
        self.headerView.addGestureRecognizer(swipeGesture)
    }
    
    func hide() {
        UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
            self.backgroundView.alpha = 0
        }) { isFinished in
            if isFinished {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

    @IBAction func closeButtonTapped(_ sender: UIButton) {
        hide()
    }
    
    @IBAction func disconnectButtonTapped(_ sender: UIButton) {
        // Reset Home Frandole's data
        FrandoleViewModel.sharedInstance.list = [Frandole]()
        let viewController = R.storyboard.account.connectionViewControllerID()!
        KeychainService().deleteTokens()
        self.present(viewController, animated: true, completion: nil)
        
        // ATInternet
        ATInternetTaggingManager.sharedManager.sendTrackClick(clickLibelle: TaggingData.kDeconnexion , pageName: TaggingData.kPopinDisconnect, chapter1: nil, chapter2: nil, level2: TaggingData.kAccountLevel)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        hide()
    }
    
}

//
//  OnBoardingViewController.swift
//  LaPostePro
//
//  Created by Mohamed Helmi Ben Jabeur on 02/07/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

class OnBoardingViewController: BaseViewController {

    @IBOutlet weak var redirectionToInscriptionLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            let layout = UICollectionViewFlowLayout()
            layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: collectionView.frame.height)
            layout.scrollDirection = .horizontal
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
            
            collectionView.collectionViewLayout = layout
        }
    }
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var connexionButton: UIButton!
    @IBOutlet weak var escapeButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupCollectionView()
        disableConnexion()
        //hide skip button
        escapeButton.isHidden = false
        
        //Send Weborama tag
        PixelWeboramaManager().sendWeboramaTag(tagToSend: Constants.allWeboramaKey, ccuIDCryptedValue: "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else
        {
            return
        }
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: collectionView.frame.height)
        layout.prepare()
        layout.invalidateLayout()
    }
    func setupView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(goToInscription))
        redirectionToInscriptionLabel.addGestureRecognizer(tapGesture)
        redirectionToInscriptionLabel.isUserInteractionEnabled = true
        pageController.numberOfPages = 3
        connexionButton.cornerRadius = connexionButton.frame.height / 2
        pageController.currentPage = 0
        pageController.currentPageIndicatorTintColor = .lpPurple
        pageController.pageIndicatorTintColor = .lpGrey
    }
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    @IBAction func escapeButtonClicked(_ sender: Any) {
        showConnectionView()
        //self.dismiss(animated: true, completion: nil)
    }
    @IBAction func connexionButtonClicked(_ sender: Any) {
        showConnectionView()
    }
    @objc private func goToInscription() {
        guard let inscriptionViewController = R.storyboard.account.firstPartViewControllerID() else {
            return
        }
        
        inscriptionViewController.formType = .create
        
        let navigationController = UINavigationController(rootViewController: inscriptionViewController)
        self.present(navigationController, animated: true, completion: nil)
    }
    func showConnectionView() {
        let connectionViewController = R.storyboard.account.connectionViewControllerID()
        present(connectionViewController!, animated: true, completion: nil)
    }
}

extension OnBoardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnBoardingCollectionViewCell", for: indexPath) as! OnBoardingCollectionViewCell
        cell.confugure(with: indexPath)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        pageController.currentPage = indexPath.row
        if indexPath.row != 2 {
            escapeButton.isHidden = false
            disableConnexion()
        } else {
            escapeButton.isHidden = true
            enableConnexion()
        }
    }
    //enable and disable connexion button
    func enableConnexion() {
        connexionButton.isEnabled = true
        connexionButton.backgroundColor = .lpPurple
        connexionButton.setTitleColor(.white, for: .normal)
    }
    func disableConnexion() {
        connexionButton.isEnabled = false
        connexionButton.backgroundColor = .lpGrayShadow
        connexionButton.setTitleColor(.lpGrey, for: .normal)
    }
}

//
//  ThirdStepHelpViewController.swift
//  LPColissimoUI
//
//  Created by Yonael Tordjman on 08/11/2018.
//

import UIKit

class ThirdStepHelpViewController: UIViewController {
    
    @IBOutlet weak var stackView: UIStackView!
    // HEADERVIEW
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var headerImage: UIImageView!
    
    // KITCHENVIEW
    @IBOutlet weak var kitchenView: UIView!
    @IBOutlet weak var kitchenContainer: UIView!
    @IBOutlet weak var kitchenImage: UIImageView!
    @IBOutlet weak var kitchenTitle: UILabel!
    @IBOutlet weak var kitchenInfo: UILabel!
    
    // WEIGHTVIEW
    @IBOutlet weak var weightView: UIView!
    @IBOutlet weak var weightContainer: UIView!
    @IBOutlet weak var weightImage: UIImageView!
    @IBOutlet weak var weightTitle: UILabel!
    @IBOutlet weak var weightInfo: UILabel!
    
    // LUGGAGEVIEW
    @IBOutlet weak var luggageView: UIView!
    @IBOutlet weak var luggageContainer: UIView!
    @IBOutlet weak var luggageImage: UIImageView!
    @IBOutlet weak var luggageTitle: UILabel!
    @IBOutlet weak var luggageInfo: UILabel!
    
    
    // BUTTONVIEW
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupHeader()
        self.setupKitchenView()
        self.setupWeightView()
        self.setupLuggageView()
        self.setupButtonView()
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // ATInternet
        ATInternetTaggingManager.sharedManager.sendTrackPage(pageName: TaggingData.kPoids,
                                                             chapter1: TaggingData.kChapter1,
                                                             chapter2: TaggingData.kChapter2,
                                                             chapter3: TaggingData.kChapter3,
                                                             level2: TaggingData.kColissimoLevel)
    }
    
    private func setupHeader() {
        //self.headerTitle
        self.closeButton.setImage(ColissimoHomeServices.loadImage(name: "IconCloseWhite.png"), for: .normal)
        self.headerImage.image = ColissimoHomeServices.loadImage(name: "IconCloseWhite.png")
    }
    
    private func setupKitchenView() {
        self.kitchenContainer.layer.cornerRadius = 10
        self.kitchenContainer.layer.masksToBounds = true
        // LOAD IMAGE
        
        // LOAD STRING
    }
    
    private func setupWeightView() {
        self.weightContainer.layer.cornerRadius = 10
        self.weightContainer.layer.masksToBounds = true
        // LOAD IMAGE
        
        // LOAD STRING
    }
    
    private func setupLuggageView() {
        self.luggageContainer.layer.cornerRadius = 10
        self.luggageContainer.layer.masksToBounds = true
        // LOAD IMAGE
        
        // LOAD STRING
    }
    
    private func setupButtonView() {
        self.doneButton.addTarget(self, action: #selector(ThirdStepHelpViewController.close), for: .touchUpInside)
        self.doneButton.layer.masksToBounds = true
        self.doneButton.cornerRadius = self.doneButton.frame.height / 2
    }
    
    @objc private func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        self.close()
    }
    
}

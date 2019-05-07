//
//  ColissimoDimensioViewController.swift
//  LPColissimoUI
//
//  Created by Khaled El Abed on 29/10/2018.
//

import LPColissimo
import UIKit

enum Dimension: Int {
    case standard = 0
    case big = 1
    case tube = 2
    
    var title: String {
        switch self {
        case .standard:
            return "Standard"
        case .big:
            return "Volumineux"
        case .tube:
            return "Tube"
        }
    }
    
    var image: String {
        switch self {
        case .standard:
            return "ic_standard_help_size.png"
        case .big:
            return "ic_volumineux_help_size.png"
        case .tube:
            return "ic_tube_help_size.png"
        }
    }
    
    var description: String {
        switch self {
        case .standard:
            return "Vérifiez que la somme de la longueur (L), largeur (l) et hauteur (h) est comprise entre 0 et 150cm ET que le côté le plus long ne dépasse pas 100cm."
        case .big:
            return "Vérifiez que la somme de la longueur (L), largeur (l) et hauteur (h) est comprise entre 151 et 200 cm ET/OU que l’un des côtés est supérieur à 100cm."
        case .tube:
            return "Vérifiez que la longueur (L) ne dépasse pas 150cm."
        }
    }
    
    var help: String {
        switch self {
        case .standard:
            return " La somme de la longueur (L), largeur (l) et hauteur (H) du colis ne dépasse pas 150 cm et le côté le plus long ne dépasse pas 100 cm."
        case .big:
            return "La somme de la longuer (L), largeur (l) et hauteur (H) du colis est comprise entre 150 et 200 cm."
        case .tube:
            return "La longueur (L) du colis ne dépasse pas 150 cm."
        }
    }
    
    var format: ConvertedFormat {
        let formats = setupFormat()
        switch self {
        case .standard:
            return formats.0
        case .big:
            return formats.1
        case .tube:
            return formats.2
        }
    }
    
    func setupFormat() -> (ConvertedFormat, ConvertedFormat, ConvertedFormat) {
        var formats: [ConvertedFormat] = [ConvertedFormat]()
        let colisFormat: [CLFormat] = ColissimoManager.sharedManager.initData?.colisFormats ?? [CLFormat]()
        for format in colisFormat {
            let c: ConvertedFormat = ConvertedFormat(format: format)
            formats.append(c)
        }
        
        let volumineux = formats.filter({ format -> Bool in
            format.type == "VOLUMINEUX" // country.isocode! == isoDeparture
        }).first!
        let standard = formats.filter({ format -> Bool in
            format.type == "STANDARD"
        }).first!
        let tube = formats.filter({ format -> Bool in
            format.type == "ROULEAU"
        }).first!
        return (standard, volumineux, tube)
    }
    
    func toString() {
        print("👀  SelectedDimension 👀 image:\(self.image) \(self.description)")
    }
}

public class ColissimoDimensionViewController: UIViewController {
    var isAllowedCountry: Bool = true
//    var selectedDimension: Dimension = .big
    //    public var data: HomeColissimoSavedData! = HomeColissimoSavedData() {
    //        didSet {
    //            isAllowedCountry = data.arrivalCountry != "be"
    //        }
    //    }
    
    @IBOutlet var headerView: CLHeaderView!
    @IBOutlet var floatingView: FloatingView!
    @IBOutlet var roundButton: RoundButton!
    
    @IBOutlet weak var footerContainerView: UIView!
    @IBOutlet weak var footerHeightContraint: NSLayoutConstraint!
    @IBOutlet var dimensionSlider: VerticalSlider!
    @IBOutlet var dimensionView: [DimensionView]!
    
    var dimensions: [Dimension] = [Dimension]()
    
    //    MARK: - Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        getPrice()
        setFooterView()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Retour", style: .plain, target: nil, action: nil)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectDimension(ColissimoData.shared.dimension)
        
        // ATInternet
        ATInternetTaggingManager.sharedManager.sendTrackPage(pageName: TaggingData.kE2Dimensions,
                                                             chapter1: TaggingData.kChapter1,
                                                             chapter2: TaggingData.kChapter2,
                                                             chapter3: nil,
                                                             level2: TaggingData.kColissimoLevel)
    }
    
    public override func viewDidLayoutSubviews() {
        floatingView.layoutSubviews()
    }
    
    func setFooterView() {
        if let footer = ColissimoManager.sharedManager.delegate?.getFooterView() {
            footerHeightContraint.constant = footer.bounds.height
            footerContainerView.addSubview(footer)
        }
    }
    
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let departureCountry = ColissimoData.shared.departureCountry, let arrivalCountry = ColissimoData.shared.arrivalCountry {
            let selected = ColissimoManager.sharedManager.getCountries(isoDeparture: departureCountry, isoArrival: arrivalCountry)
            let vc = segue.destination as! HelpDimensionViewController
            vc.arrivalCountry = selected.1
        }
    }
    
    //    MARK: - Setup
    
    func setup() {
        if let arrivalCountry = ColissimoData.shared.arrivalCountry {
            isAllowedCountry = arrivalCountry != "be"
        }
        
        if let departureCountry = ColissimoData.shared.departureCountry, let arrivalCountry = ColissimoData.shared.arrivalCountry, var selectedSenderAddress = ColissimoData.shared.selectedSenderAddress, var selectedReceiverAddress = ColissimoData.shared.selectedReceiverAddress {
            let selected = ColissimoManager.sharedManager.getCountries(isoDeparture: departureCountry, isoArrival: arrivalCountry)
            
            selectedSenderAddress = selected.0
            selectedReceiverAddress = selected.1
        }
        
        dimensions = [.big, .standard, .tube]
        if !isAllowedCountry {
            dimensions = [.standard, .big, .tube]
            ColissimoData.shared.dimension = dimensions[0]
        }
        
        headerView.setup(title: "Dimensions de votre colis", icon: "ic_step_2.png", step: 2)
        ColissimoData.shared.dimension.toString()
        
        setupDimension()
        setupSlider()
        setupFloatingView()
        
        roundButton.customColor = UIColor.lpGreen
    }
    
    func setupFloatingView() {
        if let price = ColissimoData.shared.price {
            floatingView.price = price
            floatingView.productImageNamed = "ic_standard_help_size"
            floatingView.progress = 0.3
            view.layoutIfNeeded()
            //        floatingView.animate()
            
            floatingView.onClickListner = { () in
                print("👀  \(#function) : Floating Touch 👀")
            }
        }
    }
    
    func setupSlider() {
        dimensionSlider.delegate = self
        if isAllowedCountry {
            dimensionSlider.maxValue = 2.0
            dimensionSlider.value = 2.0
        } else {
            dimensionSlider.maxValue = 1.0
            dimensionSlider.value = 1.0
        }
    }
    
    func setupDimensionView(index: Int, dimension: Dimension, isSelected: Bool) {
        (dimensionView[index]).dimension = dimension
        (dimensionView[index]).setpPrice()
        dimensionView[0].isSelected = isSelected
    }
    
    func setupDimension() {
        if isAllowedCountry {
            setupDimensionView(index: 0, dimension: dimensions[0], isSelected: true)
            setupDimensionView(index: 1, dimension: dimensions[1], isSelected: false)
            setupDimensionView(index: 2, dimension: dimensions[2], isSelected: false)
        } else {
            setupDimensionView(index: 0, dimension: dimensions[0], isSelected: true)
            setupDimensionView(index: 1, dimension: dimensions[1], isSelected: false)
            setupDimensionView(index: 2, dimension: dimensions[2], isSelected: false)
        }
        
        if !isAllowedCountry {
            dimensionView[1].desactivate()
        }
        
        dimensionView[0].onClickListner = { () in
            self.selectDimension(self.dimensions[0])
        }
        dimensionView[1].onClickListner = { () in
            if self.isAllowedCountry {
                self.selectDimension(self.dimensions[1])
            }
        }
        dimensionView[2].onClickListner = { () in
            self.selectDimension(self.dimensions[2])
        }
    }
    
    func selectDimension(_ dimension: Dimension) {
        let index = dimensions.lastIndex(of: dimension)
        ColissimoData.shared.dimension = dimension
        ColissimoData.shared.dimension.toString()
        
        dimensionSlider.value = CGFloat(2 - index!)
        
        dimensionView[0].isSelected = dimension == dimensions[0]
        if isAllowedCountry {
            dimensionView[1].isSelected = dimension == dimensions[1]
        }
        dimensionView[2].isSelected = dimension == dimensions[2]
        floatingView.productImageNamed = ColissimoData.shared.dimension.image
        ColissimoData.shared.dimension = ColissimoData.shared.dimension
        getPrice()
    }
    
    func postPrice(_ price: CLPrice) {
        ColissimoData.shared.price = price.totalHT
        if price.surcout > 0 {
            ColissimoData.shared.isSurcout = true
        } else {
            ColissimoData.shared.isSurcout = false
        }
        floatingView.price = price.totalHT
    }
    
    func getPrice() {
        if let selectedSenderAddress = ColissimoData.shared.selectedSenderAddress, let selectedReceiverAddress = ColissimoData.shared.selectedReceiverAddress, let weight = ColissimoData.shared.weight {
            
            ColissimoManager.sharedManager.getPrice(fromIsoCode: selectedSenderAddress.isocode, toIsoCode: selectedReceiverAddress.isocode, weight: weight, deposit: "", insuredValue: 0.0, withSignature: false, indemnitePlus: false, withSurcout: ColissimoData.shared.dimension.format.additionalCost != nil,
                                                    success: { (price: CLPrice) in
                                                        self.postPrice(price)                                                        
            },
                                                    failure: { (error: Error) in
                                                        print("Error: \(error)")
                                                        
            })
        }
    }
    
    @IBAction func nextStepButtonTapped(_ sender: Any) {
        if CLRouter.shared.areEqual() {
            ColissimoManager.sharedManager.delegate?.homeViewDidCallDirectlyRecap(containsFormalities: ColissimoData.shared.containsFormalities(), step: 2)
        } else {
            ColissimoManager.sharedManager.delegate?.homeViewDidCallStep3With()
        }
    }
    
    @IBAction func demandeInfoAction(_ sender: Any) {}
}

// MARK: - VerticalSliderDelegate

extension ColissimoDimensionViewController: VerticalSliderDelegate {
    func didValueChanged(step: Int) {
        if !isAllowedCountry {
            selectDimension(dimensions[step == 1 ? 2 : 0])
        } else {
            selectDimension(dimensions[step])
        }
    }
}

//
//  CTBaseTableViewCell.swift
//  laposte
//
//  Created by Issam DAHECH on 04/12/2017.
//  Copyright © 2017 laposte. All rights reserved.
//

import UIKit
protocol CTFormDelegate {
    func filterValueDidChange(step : CTStep)
    func weightTextFieldEndEditing(step : CTStep)
    func locationButtonPressed (step : CTStep)
    func hideFilterAfterError (step : CTStep)
}

struct CTConstants {
    static let databasename = "calculator_database"
    static let colisDatabaseName = "Parcours_Colis"
    static let lettreRecommandeeDatabaseName = "Parcours_LR"
    static let lettreAndPoDatabaseName = "Parcours_Lettres_PO"
    
    static let informationForLPOShippementTypeText = "Moins de 3 cm d'épaisseur"
    static let informationForColisShippementTypeText = "Jusqu'à 30 kg"
    static let informationForLRShippementTypeText = "Documents importants, remis contre signature"
    
    static let coefPetoleValueForAirline = 1.1805
    static let coefPetoleValueForLandline = 1.1220
    
    static let coefPetoleStringForAirline = "avion"
    static let coefPetoleStringForLandline = "route"
    
    static let filterNameDictionaryKey = "filterName"
    static let filterValuesDictionaryKey = "filterValues"
    static let filterTypeDictionaryKey = "filterType"
    static let filterDataDictionaryKey = "filterData"
    static let filterActionDictionaryKey = "filterAction"
    static let filterStatusDictionaryKey = "filterStatus"
    static let filterDefaultValueDictionaryKey = "filterDefaultValue"
    static let filterStepNumberDictionaryKey = "stepNumber"
    
    static let produitParentDictionaryKey = "Produits_parents"
    static let produitEnfantDictionaryKey = "Produits_enfants"
    static let idProduitParentDictionaryKey = "ID_Produits_parents"
    static let idProduitEnfantDictionaryKey = "ID_Produits_enfants"
    static let postOfficeproductPriceDictionaryKey = "Tarif_final_bureau_de_poste"
    static let enLigneProductPriceDictionaryKey = "Tarif_en_ligne"
    static let postOfficePriceExtentionDictionaryKey = "Prix_bureau_extension"
    static let enlignePriceExtentionDictionaryKey = "Prix_web_extension"
    static let coefPetroleDictionaryKey = "Coef_petrole"
    static let aPartirExacteDictionaryKey = "Prix_a_partir_de_ou_prix_precis"
    static let stickerSuiviDictionaryKey = "Sticker_suivi"
    
    static let escapeFilter = "escapeFilter"
    static let displayFilter = "displayFilter"
    static let noAction = "noActionNeeded"
    static let addFilterToListAction = "addFilterToListAction"
    
    static let filterSwitchType = "switch"
    static let filterListType = "list"
    static let filterLocationType = "location"
    static let filterLocationLabelType = "locationLabel"
    static let filterTextFieldType = "text_field"
    static let filterTwoButtonType = "two_buttons"
    static let filterThreeTextButtonType = "three_text_buttons"
    static let filterFoorTextButtonType = "four_buttons"
    static let filterUnknownType = "unknown"
    
    static let productSpecJsonKey = "produitSpecs"
    
    static let validationButtonStatusChangeNotificationName = "validationButtonChangeStatus"
    static let validationButtonLabel = "Validation"
    
    static let adValoremFilterName = "Montant_Advalorem_mini"
    
    static let CTTracking_Layout_ID_Acceuil = "CTTracking_Layout_ID_Acceuil"
    static let CTTracking_Layout_ID_Resultat = "CTTracking_Layout_ID_Result"
    static let CTTracking_Calculator_Level = "6"
    
    static let CTTracking_ID_Dictionary_Name = "ATTagCalculatorKeys"
    
    static let ColisParameters = ["Label","Destination","Affranchissement_Pret_a_envoyer","Mode_Colissimo_Chronopost_pour_Pret_a_envoyer_vers_outre_mer","Poid_min","Poid_max","Envoi_express_Chronopost_Oui_Non","Envoi_express_Type_Mode_Colissimo_Chronopost","Option_recommandation_Advalorem","Indemnisation_complementaire","Montant_de_l_indemnisation_en_cas_de_perte_ou_d_avarie","Indeminisation_complementaire_Ad_Valorem","Niveau_indemnisation_en_cas_de_perte_ou_avarie","Montant_Advalorem_mini","Montant_Advalorem_maxi","Advalorem_montant_fixe","Ar","Option_livraison_avant_10_heure","Produits_parents","ID_Produits_parents","Produits_enfants","ID_Produits_enfants","Prix_bureau_extension","Tarif_final_bureau_de_poste","Prix_web_extension","Tarif_en_ligne","Image","Label_lien","Url","Banniere_Modulo","Emballer_votre_envoi","Voir_aussi","Coef_petrole"]
    
    static let LRParameters = ["Label","Destination","Poid_min","Poid_max","Type_reco","Ar","Produits_parents","ID_Produits_parents","Prix_bureau_extension","Tarif_final_bureau_de_poste","Prix_web_extension","Tarif_en_ligne","Prix_a_partir_de_ou_prix_precis","Banniere_Modulo","Emballer_votre_envoi","Voir_aussi","Coef_petrole","tranches","taux","tarif","total"]
    
    static let LPOParameters = ["Label","Destination","Affranchissement_Pret_a_envoyer","Poid_min","Poid_max","Option_Suivi_Non_suivi","Mode_envoi_express_Chronopost_Oui_Non","Option_recommandation","Indemnisation_complementaire","Contre_signature","Indeminisation_complementaire_Ad_Valorem","Niveau_indemnisation_en_cas_de_perte_ou_avarie","Montant_Advalorem_mini","Montant_Advalorem_maxi","Ar","Option_enveloppes_papiers_enveloppes_souples","Montant_de_l_indemnisation_en_cas_de_perte_ou_d_avarie","Option_livraison_avant_10_heure","Produits_parents","ID_Produits_parents","Produits_enfants","ID_Produits_enfants","Prix_bureau_extension","Tarif_final_bureau_de_poste","Prix_web_extension","Tarif_en_ligne","complements_tarifaires","image","label_lien","url","Banniere_Modulo","Emballer_votre_envoi","Voir_aussi","Sticker_suivi","Coef_petrole"]
    
    static let ColisData = ["Destination","","Type d'envoi","Mode d'envoi","Poids de l'envoi","","Envoi express Chronopost","Mode envoi express","Option recommandation Advalorem","Indemnisation complémentaire","Montant de l'indemnisation","Indemnisation complémentaire AdValorem","Niveau d'indemnisation","Montant Advalorem","","Advalorem montant fixe","Avis de réception","Livraison avant 10 heures","Produits_parents","ID_Produits_parents","Produits_enfants","ID_Produits_enfants","Prix_bureau_extension","Tarif_final_bureau_de_poste","Prix_web_extension","Tarif_en_ligne","Image","Label_lien","Url","Banniere_Modulo","Emballer_votre_envoi","Voir_aussi","Coef_petrole"]
    
    static let LPOData = ["Destination","","Type d'envoi","Poids de l'envoi","","Suivi de l'envoi","Envoi express Chronopost","Option recommandation","Indemnisation complémentaire","Contre-signature","Indeminisation complémentaire AdValorem","Niveau d'indemnisation","Montant Advalorem","Montant AdValorem","Avis de réception","Type d'enveloppe","Montant de l'indemnisation","Livraison avant 10 heures","Produits_parents","ID_Produits_parents","Produits_enfants","ID_Produits_enfants","Prix_bureau_extension","Tarif_final_bureau_de_poste","Prix_web_extension","Tarif_en_ligne","complements_tarifaires","image","label_lien","url","Banniere_Modulo","Emballer_votre_envoi","Voir_aussi","Coef_petrole"]
    
    static let LRData = ["Destination","","Poids de l'envoi","","Niveau de recommandation","Avis de réception","Produits_parents","ID_Produits_parents","Prix_bureau_extension","Tarif_final_bureau_de_poste","Prix_web_extension","Tarif_en_ligne","Prix_a_partir_de_ou_prix_precis","Banniere_Modulo","Emballer_votre_envoi","Voir_aussi","Coef_petrole","tranches","taux","tarif","total"]
    
}


class CTStep: NSObject {
    
    var name : String = ""
    var type : String = ""
    var data : String = ""
    var value = ""
    var stepNumber : Int = 0
    var defaultValue : Any?
    var listChoise : [String] = [String]()
    var displayAction : String = ""
    
    
    
    public init(aDic : NSDictionary) {
        if let aName : String = aDic.object(forKey: CTConstants.filterNameDictionaryKey) as? String {
            name = aName
        }
        if let aType : String = aDic.object(forKey: CTConstants.filterTypeDictionaryKey) as? String {
            type = aType
        }
        if let aValue : String = aDic.object(forKey: CTConstants.filterValuesDictionaryKey) as? String {
            value = aValue
        }
        if let aData : String = aDic.object(forKey: CTConstants.filterDataDictionaryKey) as? String {
            data = aData
        }
        if let aValue  = aDic.object(forKey: CTConstants.filterDefaultValueDictionaryKey) {
            defaultValue = aValue
        }
        if let aValue : Int = aDic.object(forKey: CTConstants.filterStepNumberDictionaryKey) as? Int {
            stepNumber = aValue
        }
        if let aList : [String] = aDic.object(forKey: CTConstants.filterValuesDictionaryKey) as? [String] {
            listChoise = aList
        }
        if let aDisplayAction : String = aDic.object(forKey: CTConstants.filterStatusDictionaryKey) as? String {
            displayAction = aDisplayAction
        }
    }
}

class CTBaseTableViewCell: UITableViewCell {

    var currentColor        : UIColor!
    var step1Value          : Int!
    
    var currentStepValue    : Int!
    var currentStep         : CTStep!
    
    var formDelegate : CTFormDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCellStep(_ step: CTStep, firstStep : Int) {
        self.selectionStyle = .none
        step1Value = firstStep
        currentStep = step
        currentColor = CTDataWrapper.sharedInstanse.getCurrentColor(step1: step1Value)
        if currentStepValue == nil {
            currentStepValue = 1
        }
        
    }

}

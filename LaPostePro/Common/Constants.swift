//
//  Constants.swift
//  LaPostePro
//
//  Created by Mohamed Helmi Ben Jabeur on 01/06/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import Foundation

class Constants: NSObject {
    //used in get products list web service
    static let defaultQueryProductList = ":%@:allCategories:%@"
    //used to show the total request results in get product list
    static let totalProductNumberText = "%i résultats"
    //useed in home page for lists
    static let oneHiddenProducts = "+ 1 autre produit"
    static let numberofHiddenProducts = "+ %i autres produits"
    static let numberofHiddenProduct = "+ %i autre produit"
    static let textForHomeCartList = " dans votre panier"
    static let textForHomeFavoriteList = " dans vos favoris"
    static let degressivityText = "Soumis à dégressivité"
    static let lowStockProductText = "Stock faible"
    static let notAvailableProductText = "Indisponible"
    static let stickerUnitProductCode = "018202"
    static let stickerSmallPackCode = "018203"
    static let stickerBigPackCode = "018205"
    static let initDataForInscriptionUrl = "/initDataForMobile"
    static let updateProUser = "/updateProUser"
    static let updatePassword = "/changeCustomerProPassword"
    static let updateEmail = "/login"
    static let wishlist = "/wishlist"
    static let EnvironmentsHybrisPlistFileName = "Environments_Hybris"
    static let DefaultPlistDictionary = "Defaults"
    static let webServiceKeyForConfiguration = "REST_URL_ATTRIBUTE_KEY"
    static let boutiqueTypeKeyForConfiguration = "CURRENT_STORE_ATTRIBUTE_KEY"
    static let requiredSiretCompanyTypeList = ["EURL","SARL","SNC","SCI","SA","SAS","SASU","Secteur Public"]
    static let requiredTVACompanyTypeList = ["EURL","SARL","SNC","SCI","SA","SAS","SASU"]
    static let associationCompanyTypeKey = "Association"
    static let publicSectorCompanyTypeKey = "Secteur Public"
    static let defaultCountryForInscription = "France Métropolitaine"
    static let hybris_address_dict_title_key = "titleCode";
    static let hybris_address_dict_first_name_key = "firstName";
    static let hybris_address_dict_last_name_key = "lastName";
    static let hybris_address_dict_apartment_key = "apartment";
    static let hybris_address_dict_building_key = "building";
    static let hybris_address_dict_street_key = "line1";
    static let hybris_address_dict_locality_key = "line2";
    static let hybris_address_dict_postal_code_key = "postalCode";
    static let hybris_address_dict_town_key = "town";
    static let hybris_address_dict_country_key = "country.isocode";
    static let createAccountButtonText = "Créer mon compte"
    static let rgbdText = "Les champs marqués d’un « * » sont obligatoires et les services liés à Mon Compte et aux autres services souscrits ne pourront pas être exécutés s’ils ne sont pas complétés.\n\nPour la création de Mon Compte La Poste, les données vous concernant font l’objet d’un traitement dont le responsable est La Poste, 9 rue du Colonel Pierre Avia 75015 PARIS. Elles seront utilisées pour l’exécution du contrat, la fourniture des services de Mon Compte et des autres services souscrits, l’optimisation de la distribution, ainsi que l’animation commerciale et la gestion de la relation client. Par ailleurs, un profilage à des fins d’analyses de performance commerciale et de marketing ciblé est réalisé. Pour certains services, des informations complémentaires pourront être demandées. Vous pouvez consulter la liste ici. Vos données seront conservées pendant 5 ans après la fin de la relation commerciale pour les données liées à l’utilisation des services ou 3 ans pour les données liées à Mon Compte. Les données liées à Mon Compte seront supprimées après la clôture de votre compte, dans la mesure où tous les services qui y sont associés auront été fermés au préalable.\n\nVos données sont destinées aux services internes de La Poste, ainsi qu’aux prestataires externes, en charge de la réalisation des services souscrits et du suivi de la relation client. La maintenance des applications nécessaires aux services, ainsi qu’une partie du Service Clients sont réalisés par des prestataires situés hors UE qui peuvent également avoir accès ponctuellement à vos données. Les accès aux données sont encadrés par les clauses contractuelles type établies par la Commission Européenne.\n\nConformément à la réglementation applicable en matière de protection des données personnelles, vous disposez d’un droit d’accès, de rectification, d’opposition, de limitation du traitement, de portabilité pour demander le transfert de vos données lorsque cela est possible et d’effacement. Vous pouvez donner des instructions sur le sort de vos données après votre décès. Ces droits peuvent être exercés à l’adresse suivante : \(WebViewURL.pro.rawValue) ou en utilisant notre formulaire de contact. Veillez à préciser vos nom, prénom, adresse postale et à joindre une copie recto-verso de votre pièce d’identité à votre demande.\n\nDans le cadre de la politique de protection des données personnelles de La Poste, vous pouvez contacter Madame la Déléguée à la Protection des Données, CP C703, 9 rue du Colonel Pierre Avia 75015 PARIS. En cas de difficulté dans la gestion de vos données personnelles, vous pouvez introduire une réclamation auprès de la CNIL.\n\nVous êtes informé de l’existence de la liste d’opposition au démarchage téléphonique « bloctel » sur laquelle vous pouvez vous inscrire : https://conso.bloctel.fr"
    static let cguText = "J’ai lu et j’accepte les Conditions Générales Courrier-Colis, les Conditions Spécifiques Boutique  et les Conditions Générales d'Utilisation du Compte La Poste."
    static let cgvText = "J'ai lu et j'accepte les Conditions Générales de Vente de la Boutique et atteste avoir pris connaissance de l'information concernant les marchandises dangereuses et interdites."
    
    //Filter for Location
    static let daysList = ["Tous", "lundi", "mardi", "mercredi", "jeudi", "vendredi", "samedi", "dimanche"]
    static let hoursList = ["Toutes","00:00","01:00","02:00","03:00","04:00","05:00","06:00","07:00","08:00","09:00","10:00","11:00","12:00","13:00","14:00","15:00","16:00","17:00","18:00","19:00","20:00","21:00","22:00","23:00"]
    static let pointTypeListForBp = [ "TOUS","BUREAUX DE POSTE","ÉTABLISSEMENTS COURRIER"]
    static let pointTypeList = ["TOUS","BUREAUX DE POSTE","COMMERÇANTS"]
    
//    static let trackErrorLabelText = "Votre numéro est incorrect. Veuillez le ressaisir en respectant le format."
    static let trackErrorLabelText = "format invalide / numéro introuvable  "    
    
    //****** Weborama *******\\
    static let weboramaBaseUrl = "https://wamfactory.solution.weborama.fr/inappstream"
    static let weboramaUrl = "%@/?wamid=1362&g.did=%@&Wvar=%@&d.r=[%d]"
    static let weboramaId = 1362
    static let weboramaAdvertizingId = ""
    
    // Tag key for pixel weborama
    static let allWeboramaKey = "ALL_"
    static let accountWeboramaKey = "MonCompte_Vis"
    static let trackingWeboramaKey = "Suivi_Vis"
    static let localiserWeboramaKey = "Localiser"
    static let checkAddressWeboramaKey = "Verifier_Adresse"
    static let contactUsWeboramaKey = "Contact_Vis"
    static let marianneVisWeboramaKey = "Marianne_Vis"
    static let marianneAddToCartWeboramaKey = "Marianne_Map"
    static let marianneBuyWeboramaKey = "Marianne_Achat"
    static let beautifulTimbreVisWeboramaKey = "BeauxTimbres_Vis"
    static let beautifulTimbreAddToCartWeboramaKey = "BeauxTimbres_Map"
    static let beautifulTimbreBuyWeboramaKey = "BeauxTimbres_Achat"
    static let envpaVisWeboramaKey = "ENVPA_Vis"
    static let envpaAddToCartWeboramaKey = "ENVPA_Map"
    static let envpaBuyWeboramaKey = "ENVPA_Achat"
    static let embapaVisWeboramaKey = "EMBAPA_Vis"
    static let embapaAddToCartWeboramaKey = "EMBAPA_Map"
    static let embapaBuyWeboramaKey = "EMBAPA_Achat"
    static let stickerVisWeboramaKey = "StickersSuivi_Vis"
    static let stickerAddToCartWeboramaKey = "StickersSuivi_Map"
    static let stickerBuyWeboramaKey = "StickersSuivi_Achat"
    
    //Categories ID
    static let beautifulTimbreCategoryId = ["314","376","375","377"]
    static let marianneTimbreCategoryId = ["312","373","372","374","391","334"]
    static let stickerCategoryId = ["394"]
    static let embpaCategoryId = ["380","381","344","333"]
    static let envpaCategoryId = ["313","321","322","378","318"]
    

    static let shortcuts = [UIMutableApplicationShortcutItem(type: "EBoutique", localizedTitle: "Rechercher un produit", localizedSubtitle: "", icon: UIApplicationShortcutIcon(templateImageName: "shortcut_search"), userInfo: nil),
    UIMutableApplicationShortcutItem(type: "Location", localizedTitle: "Localiser un bureau de poste", localizedSubtitle: "", icon: UIApplicationShortcutIcon(templateImageName: "locator-inactive"), userInfo: nil),
    UIMutableApplicationShortcutItem(type: "Cart", localizedTitle: "Mon panier", localizedSubtitle: "", icon: UIApplicationShortcutIcon(templateImageName: "shortcut_cart"), userInfo: nil),
    UIMutableApplicationShortcutItem(type: "Orders", localizedTitle: "Mes commandes", localizedSubtitle: "", icon: UIApplicationShortcutIcon(templateImageName: "shortcut_orders"), userInfo: nil)]

    //indcription
    static let chorusButtonDefaultText = "Code Service*"
    static let timeForsignature = "05102018"
    static let koForSignature = "HYB_2018"

    static let availabilityNotificationMessage = "Votre demande a bien été prise en compte. Vous allez bientôt recevoir un email d'information"
    
    static let colissimoProductType = "AELC"
    
}

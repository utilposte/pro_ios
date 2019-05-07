//
//  MCMDefine.h
//  laposte
//
//  Created by Jerilyn Goncalves Figueira on 18/08/16.
//  Copyright © 2016 laposte. All rights reserved.
//

#ifndef MCMDefine_h
#define MCMDefine_h

/// Check iOS version of device
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

/// Name for MCM's storyboard file
#define MCM_UIStoryboard_Name @"Hybris"


/// CCU Keys
#define kCCU_Param_Saisie                       @"saisie"
#define kCCU_Param_Civilite                     @"civilite"
#define kCCU_Param_NameNom                      @"nom"
#define kCCU_Param_NamePrenom                   @"prenom"
#define kCCU_Param_Ligne1                       @"ligne1"
#define kCCU_Param_Ligne2                       @"ligne2"
#define kCCU_Param_Ligne3                       @"ligne3"
#define kCCU_Param_Ligne4                       @"ligne4"
#define kCCU_Param_Ligne5                       @"ligne5"
#define kCCU_Param_Ligne6                       @"ligne6"
#define kCCU_Param_Ligne7                       @"ligne7"

// Mascadia keys
#define kJsonValue_CodesEtMessages                  @"codesEtMessages"
#define kJsonValue_Feu                              @"feu"
#define kJsonValue_Retour                           @"retour"
#define kJsonValue_BlocAdresse                      @"blocAdresse"
#define kJsonValue_Adresse                          @"adresse"
#define kJsonValue_General                          @"general"
#define kJsonValue_Ligne1                           @"ligne1"
#define kJsonValue_Ligne2                           @"ligne2"
#define kJsonValue_Ligne3                           @"ligne3"
#define kJsonValue_Ligne4                           @"ligne4"
#define kJsonValue_Ligne5                           @"ligne5"
#define kJsonValue_Ligne6                           @"ligne6"
#define kJsonValue_Ligne7                           @"ligne7"
#define kJsonValue_Value                            @"value"
#define kJsonValue_libelleVoie                      @"libelleVoie"
#define kJsonValue_CodePostal                       @"codePostal"
#define kJsonValue_LibelleAcheminement              @"libelleAcheminement"
#define kJsonValue_CodeISO                          @"codeIso"
#define kJsonValue_Numero                           @"numero"
#define kJsonValue_Verifie                          @"verifie"
#define kJsonValue_Code_Insee                       @"codeInsee"
#define kJsonValue_Quartier_Lettre                  @"quartierLettre"
#define kJsonValue_Divers                           @"divers"

// Ad4Push Tracking
#define kAd4Push_date_derniere_visite               @"date_derniere_visite"
#define kAd4Push_date_dernier_achat                 @"date_dernier_achat"
#define kAd4Push_nb_achats_app                      @"nb_achats_app"
#define kAd4Push_nom_produits                       @"nom_produits"
#define kAd4Push_gamme_produits                     @"gamme_produits"
#define kAd4Push_code_promo                         @"code_promo"
#define kAd4Push_montant_derniere_commande          @"montant_derniere_commande"

/// Handy sizes
#define kView_BackButtonWidth                       40
#define kView_BackButtonHeight                      40
#define kButton_ImageEdgeInsetRight                 15

// Segues
#define kSegue_PushCommandeDetail                   @"pushCommandeDetail"
#define kSegue_PushIpadCommandeDetail                   @"pushIpadCommandeDetail"
#define kSegue_Push_ProductDetailFromCatalogue      @"segue_Push_ProductDetailFromCatalogue"
#define kNotificationCenter_closeIpadMenuDetails    @"kNotificationCenter_closeIpadMenuDetails"
#define kNotificationCenter_voucherCodeEdited    @"kNotificationCenter_voucherCodeEdited"

// possible titles of filtres
#define filtresTitles @{@"listProductRegions":@"Région", @"listThematiques":@"Thématique", @"poidsMaxEnvoiEnveloppe":@"Poids max de l'envoi", @"poidsMaxEnvoiTimbre":@"Poids max de l'envoi", @"typeProduit":@"Type de produit", @"delaiEnvoi":@"Nature de l'envoi", @"destinationEnvoi":@"Destination de l'envoi", @"valeurPermanente":@"Valeur permanente", @"typeCollage":@"Type de collage", @"packaging":@"Packaging", @"nbTimbreParPresentation":@"Nombre de timbres dans le produit", @"dateAnneeEmissionLegales":@"Année d'émission", @"accuseReception":@"Accusé de récéption", @"assurance":@"Assurance", @"bulle":@"Bulle", @"destinationEnvoi2":@"Destination de l'envoi 2", @"famille":@"Famille", @"fenetre":@"Fenêtre", @"marchandiseCourrier":@"Marchandise / courrier", @"numerossuivi":@"Numéro suivi", @"price":@"Prix", @"techniqueImpression":@"Technique impression", @"typeEnveloppe":@"Type d'enveloppe", @"auteur":@"Auteur", @"lastDaysForProduct":@"Derniers jours", @"allCategories":@"Toutes catégories", @"categoryPath":@"Accès catégorie"}



#define BORDER_GREY_COLOR [UIColor colorWithRed:233.0f/255.0f green:233.0f/255.0f blue:233.0f/255.0f alpha:1]
#define BACKGROUND_GREY_COLOR [UIColor colorWithRed:239.0f/255.0f green:239.0f/255.0f blue:239.0f/255.0f alpha:1]
#define GREEN_NAVBAR_COLOR [UIColor colorWithRed:25.0f/255.0f green:177.0f/255.0f blue:188.0f/255.0f alpha:1]

#pragma mark - MobileAppTracking SDK
//--------------------------------------------------------------
// Accengage ID
#define kA4ST_PartnerId_PROD                             @"laposte7703bbe2e899923"
#define kA4ST_PrivateKey_PROD                            @"097cfe0a26e75376ffd941151cb8bcdb5524845b"

#define kA4ST_PartnerID_TEST                             @"laposte0cb3dc79c7d05ac"
#define kA4ST_PrivateKey_TEST                            @"b37ed81411184b520404d61599d66fdf0d28096d"

#pragma mark - Google Analytics
//--------------------------------------------------------------
#define kGAI_Name                                   @"laposte"
#define kGAI_TrackingID                             @"UA-50898709-2" //@"UA-50898709-3"


#pragma mark - Google Analytics
//--------------------------------------------------------------

#pragma mark - Rating App
//--------------------------------------------------------------
#define kApp_ID                                     @"431602927"

#pragma mark - Adjust Sdk

#undef kAdjust_AppToken
#define kAdjust_AppToken                            @"w582e2xlgs8z"
#undef kAdjust_Success_Payment_Token
#define kAdjust_Success_Payment_Token               @"o7ypyf"

#define kAdjust_LauchAppToken                       @"xc1tz8"

#define kStoryboard_Main                            @"Main"

//--------------------------------------------------------------
//      Push Seque Key
//

/**
 *  Push Main Menu View
 */
#define kSegue_PushMainView                         @"pushMainView"
#define kSegue_PushMainViewFromMenu                 @"menuPushMainView"

/**
 *  Push Notification View
 */
#define kSegue_PushNotificationsView                @"pushNotificationView"

#define kSegue_PushMemoryView                       @"pushMemoryView"

/**
 *  Push Suivit View
 */
#define kSegue_PushSuivitView                       @"pushSuivitView"

#define kSegue_PushPVWebView                        @"pushPvWebview"
#define kSegue_PushPopinPVWebView                   @"pushPopinPvWebview"

/**
 *  Push splash module
 */
#define kSegue_PushCustomSplashModuleView           @"pushCustomSplashModuleView"
#define kSegue_PushPopinSplashModule                @"pushPopinSlashModuleView"
#define kSegue_PushNavSplashModule                  @"pushSplashModuleView"

/**
 *  Push Pv Web View
 */
#define kSegue_PushPVWebViewFromMainView                    @"mainMenuPushPVWebView"
#define kSegue_PushPVWebViewFromMainViewWithoutAnimation    @"mainMenuPushPVWebViewWithoutAnimation"
#define kSegue_PushPvWebViewFromFavorite                    @"pushPVWebViewFromFavorite"
#define kSegue_PushOuterWebView                             @"pushOuterWebView"
#define kSegue_PushPVWebViewFromMemory                      @"pushPVWebViewFromMemory"
#define kSegue_PushConnectionViewFromWebView                @"pushConnectViewFromWebView"
#define kSegue_PushInscriptionViewFromWebView               @"pushInscriptionViewFromWebView"
#define kSegue_PushScanBarCodeView                          @"pushScanBarCodeView"
#define kSegue_PushDashBoardView                            @"pushToDashboardView"
#define kSegue_PushToWebViewFromConsultation                @"pushToWebViewFromConsultation"

/**
 *  Push Favorite View
 */
#define kSegue_PushFavoriteView                     @"pushFavoriteView"
#define kSegue_PushFavoriteFromLocaliser            @"pushFavoriteFromLocaliser"

/**
 *  Push Aplication Services
 */
#define kSegue_PushAplicationServicesView           @"pushAplicationServicesView"
#define kSegue_PushPopinAplicationServicesView      @"pushPopinAplicationServicesView"


/**
 *  Push CGU Controller
 */
#define kSegue_PushPopinCGUView                     @"pushPopinCguView"
#define kSegue_PushNavigationCGUView                @"pushCguView"

/**
 *  Push Detail Aplication Service
 */
#define kSegue_PushDetailAplicationServicesView     @"pushDetailAplicationServicesView"

/**
 *  Push Didacticiel View Controller
 */
#define kSegue_PushDidacticielFromSplash            @"pushDidacticielFromSplash"
#define kSegue_PushMainViewFromDidacticiel          @"pushMainViewFromDidacticiel"


/**
 *  Push Account View Controller
 */
#define kSegue_PushAccountViewFromMain              @"pushAccountViewFromMain"

/**
 *  Push Notification View Controller
 */
#define kSegue_PushNotificationFromAccount          @"pushNotificationFromAccount"
/**
 *  Push Suivit View Controller
 */
#define kSegue_PushSuivitFromAccount                @"pushSuivitFromAccount"
/**
 *  Push SuivisEnregistres View Controller
 */
#define kSegue_PushSavedTrackings                   @"pushSuivisEnregistres"
#define kSegue_PushOngoingTracking                  @"pushEnCoursSuivi"
#define kSegue_PushNewTracking                      @"pushNouveauSuivi"
#define kSegue_PushOldTracking                      @"pushAncienSuivi"
/**
 *  Push Favorite View Controller
 */
#define kSegue_PushFavoriteFromAccount              @"pushFavoriteFromAccount"
/**
 *  Push Memory View Controller
 */
#define kSegue_PushMemoryFromAccount                @"pushMemoryFromAccount"

/**
 *  Push Connection View Controller
 */
#define kSegue_PushConnectionFromAccount            @"pushConnectionFromAccount"

/**
 *  Push ForgotPassword View Controller
 */
#define kSegue_PushForgotPasswordFromConnection     @"pushForgotPasswordFromConnection"

#define kSegue_PushEmailConfirmFromForgot           @"pushEmailConfirmFromForgot"

#define kSegue_PushLogoutFromAccount                @"pushLogoutFromAccount"

#define kSegue_PushLoginFavorFromAccount            @"pushLoginFavorFromAccount"

#define kSegue_PushMemoryFromLoginFavorite          @"pushMemoryFromLoginFavorite"

#define kSegue_PushFavoriteFromLoginFavorite        @"pushFavoriteFromLoginFavorite"

#define kSegue_PushSuivitFromLoginFavorite          @"pushSuivitFromLoginFavorite"

#define kSegue_PushSuviDesServicesFromAccount       @"pushSuviDesServicesFromAccount"

#define kSegue_PushNouvelleLivraison                @"pushNouvelleLivraison"

#define kSegue_PushLettreRecommandeeMobile          @"pushLettreRecommandeeMobile"

#define kSegue_PushLettreRecommandeeDetail          @"pushLettreRecommandeeDetail"

#define kSegue_PushPreuveDepotView                  @"pushPreuveDepotView"

#define kSegue_PushAvisReceptionView                @"pushAvisReceptionView"

#define kSegue_PushCommandes                        @"pushCommandes"

#define kSegue_PushExternalLinkFromSuviDesService   @"pushExternalLinkFromSuviDesService"

#define kSegue_PushCommandeDetail                   @"pushCommandeDetail"

#define kSegue_PushExternalLinkFromCommande         @"pushExternalLinkFromCommande"

#define kSegue_PushParameterFromAccount             @"pushParameterFromAccount"

#define kSegue_PushIdentifiantFromParameter         @"pushIdentifiantFromParameter"

#define kSegue_PushInfosPersonnelleFromParameter    @"pushInfosPersonnelleFromParameter"

#define kSegue_PushAdressFromParameter              @"pushAdressePostaleFromParamaterViewController"

#define kSegue_PushAddresseEmailFromIdentifiant     @"pushAddresseEmailFromIdentifiant"

#define kSegue_PushConfirmEditionFromAddressEmail   @"pushConfirmEditionFromAddressEmail"

#define kSegue_PushConfirmEditionFromMotDePasse     @"pushConfirmEditionFromMotDePasse"

#define kSegue_PushMotDePasseFromIdentifiant        @"pushMotDePasseFromIdentifiant"

#define kSegue_PushConfirmEditionFromInfosPersonnelle   @"pushConfirmEditionFromInfosPersonnelle"
#define kSegue_pushConfirmEditionFromAdresseIndiquee @"pushConfirmEditionFromAdresseIndiquee"
#define kSegue_pushConfirmEditionFromAdressePostale @"pushConfirmEditionFromAdressePostale"

#define kSegue_PushConfirmEditionFromInfosPersonnelle   @"pushConfirmEditionFromInfosPersonnelle"

#define kSegue_PushAdressePostaleFromInfo @"pushAdressePostaleFromInfo"
#define kSegue_PushAdresseIndiqueeFromAdressePostale @"pushAdresseIndiqueeFromAdressePostale"

#define kSegue_PushConfirmEditionFromConnection     @"pushConfirmEditionFromConnection"

#define kSegue_PushUser2Step1FromInscription        @"pushUser2Step1FromInscription"

#define kSegue_PushForgotPasswordFromUser2Step1     @"pushForgotPasswordFromUser2Step1"

#define kSegue_PushPreferencesFromSuiviDesService   @"pushPreferencesFromSuiviDesService"

#define kSegue_PushProcurationFromSuiviDesService   @"pushProcurationFromSuiviDesService"

#define kSegue_PushCguCCUFromInscriptionUser1Step3  @"pushCguCCUFromInscriptionUser1Step3"

/*
 * External links
 */

#define kLaPoste_Web_Link @"http://www.laposte.fr/particulier/preferences-de-livraison"

/*
 *  Push Hybris Catalog
 */

#define kSegue_Push_HybrisCatalog                    @"pushHybrisCatalog"
#define kSegue_Push_HybrisItemDetail                 @"pushHybrisItemDetail"
#define kSegue_Push_HybrisItemDetailFromCartDetail   @"pushHybrisItemDetailFromCartDetail"
#define kSegue_Push_HybrisItemDetailFromCartSummary  @"pushHybrisItemDetailFromCartSummary"
#define kSegue_Push_HybrisCartFromCatalogList        @"pushHybrisCartFromCatalogList"
#define kSegue_Push_HybrisCartFromCatalogItemDetail  @"pushHybrisCartFromCatalogItemDetail"
#define kSegue_Push_HybrisDeliveryAddressFromCart    @"pushHybrisDeliveryAddressFromCart"
#define kSegue_Push_HybrisDeliveryModeFromDelivyerAddress @"pushHybrisDeliveryModeFromDeliveryAddress"
#define kSegue_Push_HybrisCartSummaryFromAddressSelection @"pushHybrisCartSummaryFromAddressSelection"
#define kSegue_Push_HybrisCartSummaryFromAdresseIndiquee @"pushHybrisCartSummaryFromAdresseIndiquee"
#define kSegue_Push_HybrisCartSummaryFromDeliveryMode @"pushHybrisCartSummaryFromDeliveryMode"
#define kSegue_Push_HybrisPaymentWebviewFromCartSummary @"pushHybrisPaymentWebviewFromSummary"
#define kSegue_Unwind_HybrisPaymentWebviewToCartSummary @"unwindHybrisPaymentWebviewToSummary"
#define kSegue_Unwind_HybrisPaymentSummaryToCartSummary @"unwindHybrisPaymentSummaryToSummary"
#define kSegue_Modal_ConnectionFromHybrisCart @"modalConnectionFromHybrisCart"
#define kSegue_Modal_RegistrationFromHybrisCart @"modalRegistrationFromHybrisCart"
#define kSegue_Push_HybrisDeliveryAddressSelectionFromDeliveryAddress @"pushHybrisDeliveryAddressSelectionFromDeliveryAddress"
#define kSegue_Push_HybrisAddressCreateAndEditFromAddressSelection @"pushHybrisAddressCreateAndEditFromAddressSelection"
#define kSegue_Push_HybrisDeliveryAddressSelectionFromCartSummary @"pushHybrisDeliveryAddressSelectionFromCartSummary"
#define kSegue_Push_HybrisPromotionCodeFromCart @"pushHybrisPromotionFromCart"
#define kSegue_Push_UseMyLocationFromAddressSelection @"pushUseMyLocationAddressFromAddressSelection"
#define kSegue_Push_CreateEditAddressFromUseMyLocationAddress @"pushCreateEditAddressFromUseMyLocationAddress"

#define kSegue_Push_HybrisDeliveryAddressFromCartSummary @"pushHybrisDeliveryAddressFromCartSummary"
#define kSegue_Push_HybrisAddressSelectionOldFromAddressCreateAndEdit @"pushHybrisAddressSelectionOldFromAddressCreateAndEdit"

/*
 * Unwind Segues
 */

#define kSegue_Unwind_ToAddressSelection @"UnwindToAddressSelectionSegue"

/*
 * Inscription Section
 */
#pragma mark - Inscription Section
#define kSegue_Push_Account_Inscription                             @"segue_Push_Account_Inscription"
#define kSegue_Push_Inscription_InscriptionUser1Step1               @"segue_Push_Inscription_InscriptionUser1Step1"
#define kSegue_Push_InscriptionUser1Step1_InscriptionUser1Step2     @"segue_Push_InscriptionUser1Step1_InscriptionUser1Step2"
#define kSegue_Push_InscriptionUser1Step2_InscriptionUser1Step3     @"segue_Push_InscriptionUser1Step2_InscriptionUser1Step3"

#define kSegue_Push_Inscription_InscriptionUser3Step1               @"segue_Push_Inscription_InscriptionUser3Step1"
#define kSegue_Push_InscriptionUser3Step1_InscriptionUser3Step2     @"segue_Push_InscriptionUser3Step1_InscriptionUser3Step2"
#define kSegue_Push_InscriptionUser3Step1_ForgotPassword            @"segue_Push_InscriptionUser3Step1_ForgotPassword"

#define kSegue_Push_Inscription_InscriptionUser4Step1               @"segue_Push_Inscription_InscriptionUser4Step1"
#define kSegue_Push_InscriptionUser4Step1_InscriptionUser4Step2     @"segue_Push_InscriptionUser4Step1_InscriptionUser4Step2"
#define kSegue_Push_InscriptionUser4Step2_InscriptionUser4Step3     @"segue_Push_InscriptionUser4Step2_InscriptionUser4Step3"
#define kSegue_Push_InscriptionUser4Step1_ForgotPassword            @"segue_Push_InscriptionUser4Step1_ForgotPassword"


#define kSegue_Push_Inscription_InscriptionUser5Step1               @"segue_Push_Inscription_InscriptionUser5Step1"
#define kSegue_Push_InscriptionUser5Step1_InscriptionUser5Step2     @"segue_Push_InscriptionUser5Step1_InscriptionUser5Step2"
#define kSegue_Push_InscriptionUser5Step1_ForgotPassword            @"segue_Push_InscriptionUser5Step1_ForgotPassword"

#define kSegue_PushUser06Step01FromInscription                      @"pushUser06Step01FromInscription"
#define kSegue_PushForgotPasswordFromUser6Step1                     @"pushForgotPasswordFromUser6Step1"
#define kSegue_PushUser6Step2FromUser6Step1                         @"pushUser6Step2FromUser6Step1"
#define kSegue_PushUser6Step3FromUser6Step2                         @"pushUser6Step3FromUser6Step2"
#define kSegue_PushForgotPasswordFromUser6Step3                     @"pushForgotPasswordFromUser6Step3"

#define kSegue_Push_InscriptionUser1Step1_InscriptionUser2Step1     @"segue_Push_InscriptionUser1Step1_InscriptionUser2Step1"
#define kSegue_Push_InscriptionUser1Step1_InscriptionUser3Step1     @"segue_Push_InscriptionUser1Step1_InscriptionUser3Step1"
#define kSegue_Push_InscriptionUser1Step1_InscriptionUser4Step1     @"segue_Push_InscriptionUser1Step1_InscriptionUser4Step1"
#define kSegue_Push_InscriptionUser1Step1_InscriptionUser6Step1     @"segue_Push_InscriptionUser1Step1_InscriptionUser6Step1"


#define kLocalizedString_Inscription_NavTitle                       @"inscription_nav_title"
#define kLocalizedString_Inscription_Continue_Button                @"inscription_continue_button"
#define kLocalizedString_Inscription_Note_Label                     @"inscription_note_label"
#define kLocalizedString_Inscription_Title_OtherLogin               @"inscription_note_title_otherlogin"

#define kLocalizedString_Inscription_User1_Step1_StatusTitleLabel   @"inscription_user1_step1_status_title_label"
#define kLocalizedString_Inscription_input_email_address            @"inscription_input_email_address"
#define kLocalizedString_Inscription_input_confirm_email_address    @"inscription_input_confirm_email_address"
#define kLocalizedString_Inscription_input_password                 @"inscription_input_password"
#define kLocalizedString_Inscription_input_confirm_password         @"inscription_input_confirm_password"
#define kLocalizedString_Inscription_input_help_password            @"inscription_input_help_password"

#define kLocalizedString_Inscription_User1_Step2_StatusTitleLabel   @"inscription_user1_step2_status_title_label"
#define kLocalizedString_Inscription_input_name                     @"inscription_input_name"
#define kLocalizedString_Inscription_input_prename                  @"inscription_input_prename"
#define kLocalizedString_Inscription_input_phone                    @"inscription_input_phone"
#define kLocalizedString_Inscription_input_help_phone               @"inscription_input_help_phone"
#define input_error_postal_format                   @"format_postal_invalide"
#define kLocalizedString_Inscription_User1_Step3_StatusTitleLabel   @"inscription_user1_step3_status_title_label"
#define kLocalizedString_Inscription_Complete_Button                @"inscription_complete_button"
#define kLocalizedString_Inscription_Checkbox_Condition             @"inscription_checkbox_condition"
#define kLocalizedString_Inscription_Checkbox_Condition_Underline   @"inscription_checkbox_condition_underline"
#define kLocalizedString_Inscription_Checkbox_Accept_LaPoste_Email  @"inscription_checkbox_accept_receive_laposte_email"
#define kLocalizedString_Inscription_Checkbox_Accept_Other_Email    @"inscription_checkbox_accept_receive_other_email"
#define kLocalizedString_Inscription_Info_1             @"inscription_checkbox_info_1"
#define kLocalizedString_Inscription_Info_2             @"inscription_checkbox_info_2"
#define kLocalizedString_Inscription_Info_3             @"inscription_text_info_3"
#define kLocalizedString_Inscription_Info_4             @"inscription_text_info_4"

#define kLocalizedString_Inscription_User3_Step1_TitleStepLabel     @"inscription_user3_step1_title_step_label"
#define kLocalizedString_Inscription_User3_Step1_DesStepLabel       @"inscription_user3_step1_description_step_label"
#define kLocalizedString_Inscription_User3_Step1_ContinueButton     @"inscription_user3_step1_continue_button"

#define kLocalizedString_Inscription_User3_Step2_TitleStepLabel     @"inscription_user3_step2_title_step_label"
#define kLocalizedString_Inscription_User3_Step2_DesStepLabel       @"inscription_user3_step2_description_step_label"
#define kLocalizedString_Inscription_User3_Step2_TitleStepLabel_Connection     @"inscription_user3_step2_title_step_label_connection"
#define kLocalizedString_Inscription_User3_Step2_DesStepLabel_Connection       @"inscription_user3_step2_description_step_label_connection"

#define kLocalizedString_Inscription_User4_Step1_TitleStepLabel     @"inscription_user4_step1_title_step_label"
#define kLocalizedString_Inscription_User4_Step1_DesStepLabel       @"inscription_user4_step1_description_step_label"
#define kLocalizedString_Inscription_User4_Step1_ContinueButton     @"inscription_user4_step1_continue_button"

#define kLocalizedString_Inscription_User4_Step2_TitleStepLabel     @"inscription_user4_step2_title_step_label"

#define kLocalizedString_Inscription_User5_Step1_TitleStepLabel     @"inscription_user5_step1_title_step_label"
#define kLocalizedString_Inscription_User5_Step1_DesStepLabel       @"inscription_user5_step1_description_step_label"
#define kLocalizedString_Inscription_User5_Step1_ContinueButton     @"inscription_user5_step1_continue_button"

#define kLocalizedString_Inscription_User5_Step2_TitleStepLabel     @"inscription_user5_step2_title_step_label"
#define kLocalizedString_Inscription_User5_Step2_DesStepLabel       @"inscription_user5_step2_description_step_label"

#define kLocalizedString_LettreRecommande_NoData                    @"lettre_recommandee_no_data"

#pragma mark -

/**
 *  View Controller Identifier
 */
#define kIdentifier_PVWebViewControllerID           @"PVWebViewControllerID"
#define kIdentifier_DidacticielControllerID         @"didacticielControllerID"

// id of menus
#define kManifest_MenuId_Suivre_un_envoi            @"2"
#define kManifest_MenuId_Sub_suivre_un_envoi        @"13"
#define kManifest_MenuId_affranchir                 @"22"
#define kManifest_MenuId_CartePerso                 @"17"
#define kManifest_MenuId_Messagerie                 @"25"

// module of menus
#define kManifest_Module_Suivre_un_envoi            @"mod3"
#define kManifest_Module_affranchir                 @"mod4"
#define kManifest_Module_CartePerso                 @"mod7"

//-----------------------------------------------------------------
//      Manifest Json Node Define
//
#define kManifest_KeyManifest                       @"manifest"
#define kManifest_KeyMd5                            @"md5"
#define kManifest_KeyMenu                           @"menu"
#define kManifest_KeyIcone                          @"icone"
#define kManifest_KeyId                             @"id"
#define kManifest_KeyItem                           @"item"
#define kManifest_KeyTitle                          @"title"
#define kManifest_KeyDescription                    @"description"
#define kManifest_KeyLocale                         @"locale"
#define kManifest_KeyText                           @"text"
#define kManifest_KeyTag                            @"tag"

#define kManifest_KeyLevel                          @"level"
#define kManifest_KeyBackground_Color               @"background-color"
#define kManifest_KeyTargetLevel                    @"targetlevel"
#define kManifest_KeyParent                         @"parent"
#define kManifest_KeyModule                         @"module"
#define kManifest_KeyURL                            @"url"
#define kManifest_KeyColor                          @"color"
#define kManifest_KeyId                             @"id"
#define kManifest_KeyStatus                         @"status"
#define kManifest_KeyTrackingID                     @"trackingid"

#define kManifest_KeyModules                        @"modules"
#define kManifest_KeyRef                            @"ref"
#define kManifest_KeyDownload                       @"download"
#define kManifest_KeyAction                         @"action"
#define kManifest_KeyActionFavoris                  @"openfavoris"
#define kManifest_KeyParams                         @"params"
#define kManifest_KeyTypeFavorite                   @"typeFavorite"
#define kManifest_KeyFavoris                        @"favoris"
#define kManifest_KeyTypeFavoriteLOC                @"LOC"
#define kManifest_KeyTypeFavoriteLOC_BP             @"LOC_BP"
#define kManifest_KeyTypeFavoriteSVE                @"SVE"
#define kManifest_KeyTypeFavoriteSVE_NUM            @"SVE_NUM"
#define kManifest_KeyTypeFavoriteAFF_RCH            @"AFF_RCH"
#define kManifest_KeyTypeFavoritePAPLR              @"PAPLR"
#define kManifest_KeyTypeFavorite_Unlock            @"unlock"

#define kManifest_KeyReferences                     @"references"
#define kManifest_KeyFile                           @"file"
#define kManifest_KeyLink                           @"link"

// -----------------------
#define kManifest_KeyNumber                         @"number"
#define kManifest_KeyDate                           @"date"
#define kManifest_KeyDetail                         @"detail"

#define kManifest_KeyNavColor                       @"navcolor"


#define kManifest_KeyJsonNode                       @"jsonnode"
#define kManifest_KeyDisplay                        @"display"
#define kManifest_KeyAplicationsServices            @"aplicationsservices"
#define kManifest_ValueAplicationsServices          @"aplicationsservices"
#define kManifest_ValueCGU                          @"CGU"
#define kManifest_KeySections                       @"sections"
#define kManifest_KeySection                        @"section"
#define kManifest_KeyApp                            @"app"
#define kManifest_KeySubTitle                       @"subtitle"
#define kManifest_KeyDesc                           @"desc"
#define kManifest_KeyAppStore                       @"appstore"
#define kManifest_KeyGooglePlay                     @"googleplay"
#define kManifest_KeyStoreUrl                       @"store_url"
#define kManifest_KeyIconeUrl                       @"icone_url"

#define kManifest_KeyMonetisation                   @"monetisation"
#define kManifest_KeyBannieres                      @"bannieres"
#define kManifest_KeyPubid                          @"pubid"
#define kManifest_KeyMoneid                         @"moneid"
#define kManifest_KeyAppid                          @"appid"
#define kManifest_KeyIPhone                         @"iphone"
#define kManifest_KeyDeepLink                       @"deeplink"
//-------------------------------------------------------------------
// Define Json Node in Favorite Data
#define kFavoriteData_codeSite                      @"codeSite"
#define kFavoriteData_libelleSite                   @"libelleSite"
#define kFavoriteData_adresse                       @"adresse"
#define kFavoriteData_codePostal                    @"codePostal"
#define kFavoriteData_localite                      @"localite"
#define kFavoriteData_telephoneIndigo               @"telephoneIndigo"
#define kFavoriteData_telephoneStandard             @"telephoneStandard"
#define kFavoriteData_lng                           @"lng"
#define kFavoriteData_lat                           @"lat"
#define kFavoriteData_etat                          @"etat"
#define kFavoriteData_etat_date                     @"date"
#define kFavoriteData_etat_ouvert                   @"ouvert"
#define kFavoriteData_etat_dateChangement           @"dateChangement"
#define kFavoriteData_IsLast                        @"isLast"


//-------------------------------------------------------------------
// Define Json Node in cgu.json
#define kCGUNode_CGU                                @"cgu"
#define kCGUNode_Sections                           @"sections"
#define kCGUNode_Section                            @"section"
#define kCGUNode_App                                @"app"

//-------------------------------------------------------------------
//      Configuration Define
#define kConfiguration_Category_Url_Http            @"Category_Url_Http"
#define kConfiguration_Category_Url_Https           @"Category_Url_Https"
#define kConfiguration_Category_Url_INT             @"Category_Url_INT"
#define kConfiguration_Category_Url_RU              @"Category_Url_RU"
#define kConfiguration_Category_Url_Hide            @"Category_Url_Hide"
#define kConfiguration_Category_Url_DEV             @"Category_Url_Dev"
#define kConfiguration_Category_Url_PPROD           @"Category_Url_PPRD"
#define kConfiguration_Category_Url_Hybris_Token_1  @"Category_Url_Hybris_Token_1"
#define kConfiguration_Category_Url_Hybris_Token_2  @"Category_Url_Hybris_Token_2"

#define kConfiguration_PushMode                     @"pushMod"
#define kConfiguration_RegisterPush                 @"registerPush"
#define kConfiguration_UnRegisterPush               @"unRegisterPush"
#define kConfiguration_PushServer                   @"pushServer"
#define kConfiguration_MockServer                   @"mockServer"
#define kConfoguration_UpdatePush                   @"updatePush"
#define kConfoguration_SubScribe                    @"subscribe"
#define kConfoguration_UnSubScribe                  @"unsubscribe"


//------------------------------------------------------------------
//      Color Define
//
#define kColor_Localier_Blue                        @"#0093d9"
#define kColor_MainView_Gray                        @"#e3e3e3"
#define kColor_SuivitGray                           @"#e8e8e8"
#define kColor_SuiviGreen                           @"#22AF47"
#define kColor_BurgerMenu                           @"#48484a"
#define kColor_AplicationService_Gray               @"#666666"
#define kColor_Recevoir_Red                         @"#EF4238"
#define kColor_DefaultColor                         @"#FFC526"
#define kColor_WhiteColor                           @"#FFFFFF"
#define kColor_LightGray                            @"#797979"
#define kColor_NavBar                               @"#FECE13"
#define kColor_LightYellowHeaderBackground          @"#FFEDAB"
#define kColor_LightGreyHeaderBackground            @"#F2F2F2"


//-------------------------------------------------------------------
//      Folder and File
//
#define kFolder_Modules                             @"laposte_modules"
#define kFile_ManifestJson                          @"lapostemanifestapp.json"
#define kFile_ManifestJsonBackup                    @"lapostemanifestapp_backup.json"
#define kFile_BoutiqueManifest                      @"boutique_menu_item"
#define kFile_RocsManifest                          @"rocs_menu_item"
#define kFile_LocaliserManifest                          @"localiser_menu_item"
#define kFile_CguJson                               @"cgu.json"
#define kFile_CguCcuJson                            @"cgu_ccu.json"
#define kFile_MentionLegalJson                      @"mention_legal.json"
#define kFolder_Common                              @"common"
#define kFileType_Zip                               @"zip"
#define kFile_TempJson                              @"temp.json"
#define kFolder_CommonData                          @"common/data/"
#define kFolder_AplicationService                   @"aplicationService"
#define kFolder_DataJsonToken                       @"common/data/fr_FR/"
#define kFile_DataJson                              @"data.json"
#define kFile_TrackingApp                           @"trackingapp.json"
#define kFile_TrackingCCU                           @"tracking_ccu.json"
#define kFile_Countries                             @"countries.json"

// ------------------------------------------------------------------
//      Tracking Define
//

#define kTracking_level2                                   @"level2"

#define kClick_tracking                                     @"click_tracking"

#define kClick_key_click_type                               @"click_type"
#define kClick_key_click_name                               @"click_name"

#define kClick_link_inscription_cgu_cgu                     @"inscription_cgu_cgu"
#define kClick_key_inscription                              @"inscription"
#define kClick_key_inscription_formulaire                   @"inscription_formulaire"
#define kClick_key_compte_boutique_devient_compte_LP        @"compte_boutique_devient_compte_LP"
#define kClick_key_global_ccu                               @"global_ccu"
#define kClick_key_parametres_compte                        @"parametres_compte"
#define kClick_key_compte_espace_client_devient_compte_LP   @"compte_espace_client_devient_compte_LP"
#define kClick_key_connexion                                @"connexion"
#define kClick_key_confirmation_compte_LP_existant          @"confirmation_compte_LP_existant"
#define kClick_key_mdp_oublie                               @"mdp_oublie"
#define kClick_key_lier_compte_espace_client                @"lier_compte_espace_client"
#define kClick_key_suivi_services                           @"suivi_services"
#define kClick_key_deconnexion                              @"deconnexion"
#define kClick_key_suivi_des_envois                         @"suivi_des_envois"
#define kClick_key_bandeau_message_cookies                  @"bandeau_message_cookies"
#define kClick_key_inscription                              @"inscription"
#define kClick_key_date                                     @"date"

#define kClick_field_champ_email                            @"champ_email"
#define kClick_field_champ_email_user6                      @"champ_email_user6"
#define kClick_field_champ_repeter_email                    @"champ_repeter_email"
#define kClick_field_coche_champ_email                      @"coche_champ_email"
#define kClick_field_champ_mdp                              @"champ_mdp"
#define kClick_field_champ_mdp_user6                        @"champ_mdp_user6"
#define kClick_field_champ_repeter_mdp                      @"champ_repeter_mdp"
#define kClick_field_coche_madame                           @"coche_madame"
#define kClick_field_champ_nom                              @"champ_nom"
#define kClick_field_champ_lieu_dit                         @"champ_lieu_dit"
#define kClick_field_coche_emails_partenaires               @"coche_emails_partenaires"
#define kClick_field_nouveau_mdp_champ_nouveau_mdp          @"nouveau_mdp_champ_nouveau_mdp"
#define kClick_field_champ_telephone                        @"champ_telephone"
#define kClick_field_champ_batiment                         @"champ_batiment"
#define kClick_field_nouveau_mdp_champ_mdp                  @"nouveau_mdp_champ_mdp"
#define kClick_field_champ_mdp_actuel                       @"champ_mdp_actuel"
#define kClick_field_champ_ville                            @"champ_ville"
#define kClick_field_cocher_rester_connecte                 @"cocher_rester_connecte"
#define kClick_field_coche_cgu                              @"coche_cgu"
#define kClick_field_champ_code_postal                      @"champ_code_postal"
#define kClick_field_champ_appartement                      @"champ_appartement"
#define kClick_field_coche_emails_la_poste                  @"coche_emails_la_poste"
#define kClick_field_cocher_valider_cgu                     @"cocher_valider_cgu"
#define kClick_field_cocher_valider_cgu_user6               @"cocher_valider_user6"
#define kClick_field_champ_numero_libelle                   @"champ_numero_libelle"
#define kClick_field_champ_nouveau_mdp                      @"champ_nouveau_mdp"
#define kClick_field_redirect_ma_boite_mail                 @"redirect_ma_boite_mail"
#define kClick_field_champ_prenom                           @"champ_prenom"
#define kClick_field_coche_monsieur                         @"coche_monsieur"
#define kClick_field_faire_plus_tard                        @"faire_plus_tard"
#define kClick_field_description_info                       @"description_info"
#define kClick_field_redirect_espace                        @"redirect_espace"
#define kClick_field_redirect_boutique                      @"redirect_boutique"
#define kClick_field_deconnexion                            @"deconnexion"
#define kClick_field_supprimer_dernier_suivi_consulte       @"supprimer_dernier_suivi_consulte"
#define kClick_field_fermer                                 @"fermer"
#define kClick_field_savoir_plus                            @"savoir_plus"
#define kClick_field_vous_avez_un_compte_mon_espace_client  @"vous_avez_un_compte_mon_espace_client"
#define kClick_field_vous_avez_un_compte_la_boutique        @"vous_avez_un_compte_la_boutique"
#define kClick_field_day                                    @"day"
#define kClick_field_month                                  @"month"
#define kClick_field_year                                   @"year"

#define kClick_field_identifiant_connexion_champ_email                              @"identifiant_connexion_champ_email"
#define kClick_field_identifiant_connexion_champ_repeter_email                      @"identifiant_connexion_champ_repeter_email"
#define kClick_field_identifiant_connexion_champ_mdp                                @"identifiant_connexion_champ_mdp"
#define kClick_field_identifiant_connexion_champ_repeter_mdp                        @"identifiant_connexion_champ_repeter_mdp"

#define kClick_field_infos_perso_coche_madame                                       @"infos_perso_coche_madame"
#define kClick_field_infos_perso_coche_monsieur                                     @"infos_perso_coche_monsieur"
#define kClick_field_infos_perso_coche_madame_inscription                                       @"infos_perso_coche_madame_inscription"
#define kClick_field_infos_perso_coche_monsieur_inscription                                     @"infos_perso_coche_monsieur_inscription"

#define kClick_field_infos_perso_champ_nom                                          @"infos_perso_champ_nom"
#define kClick_field_infos_perso_champ_prenom                                       @"infos_perso_champ_prenom"
#define kClick_field_infos_perso_champ_telephone                                    @"infos_perso_champ_telephone"

#define kClick_field_confirmer_adresse_postale @"confirmer_adresse_postale"

#define kClick_field_cgu_coche_cgu                                                  @"cgu_coche_cgu"
#define kClick_field_validation_CGU                                                  @"validation_CGU"
#define kClick_link_inscription_cgu_cgu                                             @"inscription_cgu_cgu"
#define kClick_field_cgu_coche_emails_la_poste                                      @"cgu_coche_emails_la_poste"
#define kClick_field_cgu_coche_emails_partenaires                                   @"cgu_coche_emails_partenaires"
#define kClick_field_compte_LP_existant_champ_mdp                                   @"compte_LP_existant_champ_mdp"
#define kClick_field_compte_LP_existant_cocher_rester_connecte                      @"compte_LP_existant_cocher_rester_connecte"
#define kClick_field_compte_boutique_devient_compte_LP_champ_email                  @"compte_boutique_devient_compte_LP_champ_email"
#define kClick_field_compte_boutique_devient_compte_LP_champ_mdp                    @"compte_boutique_devient_compte_LP_champ_mdp"
#define kClick_field_lier_compte_espace_client_champ_email                          @"lier_compte_espace_client_champ_email"
#define kClick_field_lier_compte_espace_client_champ_mdp                            @"lier_compte_espace_client_champ_mdp"
#define kClick_field_validation_CGU_cgu                                             @"validation_CGU_cgu"
#define kClick_field_compte_espace_client_devient_compte_LP_champ_mdp               @"compte_espace_client_devient_compte_LP_champ_mdp"
#define kClick_field_compte_espace_client_devient_compte_LP_champ_email             @"compte_espace_client_devient_compte_LP_champ_email"
#define kClick_field_compte_boutique_devient_compte_LP_cocher_rester_connecte       @"compte_boutique_devient_compte_LP_cocher_rester_connecte"
#define kClick_field_lier_compte_espace_client_s_identifier_depuis_mon_compte_LP    @"lier_compte_espace_client_s_identifier_depuis_mon_compte_LP"
#define kClick_field_lier_compte_espace_client_s_identifier_faire_plus_tard @"lier_compte_espace_client_s_identifier_faire_plus_tard"

#define kPage_group_inscription                             @"inscription"
#define kPage_group_mon_compte                              @"mon_compte"
#define kPage_group_connexion                               @"connexion"

//Added on 12.12.2018 CCU-V2
#define kPage_group_lpc_connexion                           @"connexion::lpc_webview"
#define kPage_group_lpc_inscription                         @"inscription::lpc_webview"

#define kPage_id_formulaire_inscription                     @"formulaire_inscription"
#define kPage_id_formulaire_login                           @"formulaire_login"
#define kPage_id_mdp_oublie                                 @"mdp_oublie"
//

#define kPage_id_modif_email                                @"modif_email"
#define kPage_id_mon_compte_connecte                        @"mon_compte_connecte"
#define kPage_id_confirmation_deconnexion                   @"confirmation_deconnexion"
#define kPage_id_popin_redirect_prestation_service          @"popin_redirect_prestation_service"
#define kPage_id_popin_redirect_nouvelle_livraison          @"popin_redirect_nouvelle_livraison"
#define kPage_id_identifiant_de_connexion                   @"identifiant_de_connexion"
#define kPage_id_modif_email_confirmation                   @"modif_email_confirmation"
#define kPage_id_popin_redirect_procuration                 @"popin_redirect_procuration"
#define kPage_id_popin_redirect_espace_client_modif_livraison   @"popin_redirect_espace_client_modif_livraison"
#define kPage_id_nouveau_mdp                                @"nouveau_mdp"
#define kPage_id_suivi_services                             @"suivi_services"
#define kPage_id_saisie_email_ou_social_connect             @"saisie_email_ou_social_connect"
#define kPage_id_compte_boutique_devient_compte_LP          @"compte_boutique_devient_compte_LP"
#define kPage_id_communications_acceptation_cgu             @"communications_acceptation_cgu"
#define kPage_id_modif_mdp_confirmation                     @"modif_mdp_confirmation"
#define kPage_id_favoris_connecte                           @"favoris_connecte"
#define kPage_id_identifiants_connexion                     @"identifiants_connexion"
#define kPage_id_compte_espace_client_devient_compte_LP     @"compte_espace_client_devient_compte_LP"
#define kPage_id_validation_CGU                             @"validation_CGU"
#define kPage_id_popin_redirect_preferences_livraison       @"popin_redirect_preferences_livraison"
#define kPage_id_modif_infos_perso_confirmation             @"modif_infos_perso_confirmation"
#define kPage_id_validation                                 @"validation"
#define kPage_id_popin_redirect_espace_client_modif_commande    @"popin_redirect_espace_client_modif_commande"
#define kPage_id_parametres                                 @"parametres"
#define kPage_id_detail_commande                            @"detail_commande"
#define kPage_id_modif_mdp                                  @"modif_mdp"
#define kPage_id_mon_compte_non_connecte                    @"mon_compte_non_connecte"
#define kPage_id_confirmation_inscription                   @"confirmation_inscription"
#define kPage_id_saisie_email                               @"saisie_email"
#define kPage_id_lier_mon_compte                            @"lier_mon_compte"
#define kPage_id_lier_mon_compte_confirmation               @"lier_mon_compte_confirmation"
#define kPage_id_infos_perso                                @"infos_perso"

#define kPage_id_adresse_postale @"adresse_postale"
#define kPage_id_adresse_postale_confirmation_suggestions @"adresse_postale::confirmation_suggestions"
#define kPage_id_adresse_postale_confirmation @"adresse_postale::confirmation"

#define kPage_id_confirmation_compte_LP_existant            @"confirmation_compte_LP_existant"
#define kPage_id_lier_compte_espace_client                  @"lier_compte_espace_client"
#define kPage_id_mon_compte_parametres_compte_compte_espace_client_devient_compte_LP               @"mon_compte_parametres_compte_compte_espace_client_devient_compte_LP"
#define kPage_id_liste_nouvelle_livraison                   @"liste_nouvelle_livraison"
#define kPage_id_modif_infos_perso                          @"modif_infos_perso"
#define kPage_id_liste_mes_commandes                        @"liste_mes_commandes"
#define kPage_id_connexion                                  @"connexion"

// parametres_compte                        - inscription form - user1 step 1, 2;
// inscription_formulaire                   - user 1 step 3
// connexion                                - connexion
// confirmation_compte_LP_existant          - user 2
// compte_boutique_devient_compte_LP        - user 3
// compte_espace_client_devient_compte_LP   - user 4
// lier_compte_espace_client                - user 6


// ------------------------------------------------------------------
//      Font Define
//
#define kFontSize_Date                              14
#define kFontSize_Title                             18
#define kFontSize_Description                       14
#define kFontSize_NavTitle                          20
#define kFontSize_MenuItemTitle                     22
#define kFontSize_19px                              19
#define kFontSize_MenuItemSubTitle                  18
#define kFontSize_15px                              15
#define kFontSize_20px                              20
#define kFontSize_11px                              11
#define kFontSize_10px                              10
#define kFontSize_12px                              12
#define kFontSize_17px                              17
#define kFontSize_18px                              18
//-------------------------------------------------------------------
//      Notification Content width
//
#define kView_NotificationContentWidth              ([[UIScreen mainScreen] bounds].size.width-40)
#define kView_NavBarTitleWitdh                      ([[UIScreen mainScreen] bounds].size.width-120)

#define kView_BackButtonWidth                       40
#define kView_BackButtonHeight                      40
#define kView_NavigationExpandHeight                64
#define kView_NavigationHeightPlus                  20
#define kView_NavigationBarHeight                   44

//--------------------------------------------------------------------
//      Store time to download
//
#define kDownload_MD5Manifest                       @"md5"
#define kDownload_MD5AplicationService              @"md5AplicationService"
#define kDownload_MD5CGU                            @"md5CGU"

//--------------------------------------------------------------------
//      Control Name
//
#define kResource_BackButton                        @"back_button"
#define kResource_BackButtonBlack                   @"back_button_black"
#define kResource_MenuButton                        @"menu_white"
#define kResource_MenuButtonBlack                   @"menu_black"
#define kResource_HomeButtonBlack                   @"home-icon"
#define kResource_HomeButton                        @"home_button"
#define kResource_AccountHomeButton                 @"btn_home_black"
#define kResource_HomeButtonBlack                   @"home_button_black"
#define kResource_AccountButton                     @"account"
#define kResource_AccountConnectedButton            @"account_connected"
#define kResource_BackButtonX                       @"btn_X"
#define kResource_AddButtonX                        @"add_button_white"
#define kResource_CartCloseButton                   @"cartCloseIcon"
/**
 *  Font Design
 */
#define kFont_DinPro_Regular                        @"DINPro-Regular"
#define kFont_DinPro_Bold                           @"DINPro-Bold"
#define kFont_Helvetica_Neue                        @"Helvetica Neue"
/**
 *  UIView Define tag
 */
#define kTagView_NavBarBG                           100

#define kTagAlertView_DownloadFileError             101

#define kTagAlertView_Popin                         102
#define kTagAlertView_CardIo                       104
#define kTagAlertView_NoConnection                  103

/**
 *  UIWebview Prefix
 */

#define kWebViewHost_IsPageExists                   @"isPageExists"
#define kWebViewHost_WriteJson                      @"writejson"
#define kWebViewHost_WriteToken                     @"writetoken"
#define kWebViewHost_WriteTempJSON                  @"writetempjson"
#define kWebViewHost_SetFavorite                    @"setfavorite"
//LPOSTAPP-730: Get notif
#define kWebViewHost_GetNotif                       @"getnotif"
#define kWebViewHost_RemoveFavorite                 @"removefavorite"
#define kWebViewHost_DisplayPopin                   @"displaypopin"
#define kWebViewHost_ClosePopin                     @"closepopin"
#define kWebViewHost_RemoveTempJSON                 @"removetempjson"
#define kWebViewHost_NavigationTitle                @"navigationtitle"
#define kWebViewHost_DisplayLoader                  @"displayloader"
#define kWebViewHost_HideLoader                     @"hideloader"
#define kWebViewHost_AlertPopin                     @"alertpopin"
#define kWebViewHost_RefreshWebview                 @"refreshwebview"
#define kWebViewHost_Tracking                       @"tracking"
#define kWebViewHost_TrackingWithCustoms            @"trackingwithcustoms"
#define kWebViewHost_Redirect                       @"redirect"
#define kWebViewHost_Externallink                   @"externallink"
#define kWebViewHost_ExternalPopin                  @"externalPopin"
#define kWebViewHost_Switchmodule                   @"switchmodule"
#define kWebViewHost_GetUserLocation                @"getuserlocation"
#define kWebViewHost_NavigationBack                 @"navBack"
#define kWebViewHost_PopToFirstPage                 @"popToFirstPage"
#define kWebViewHost_OpenCamera                     @"opencamera"
#define kWebViewHost_OpenPhotoLibrary               @"openphotolibrary"
#define kWebViewHost_AccessToken                    @"access_token"
#define kWebViewHost_SocialNetWorkCNX               @"socialnetworkcnx"
#define kWebViewHost_PaiementMacarte                @"web.macarteamoi"
#define kWebViewHost_TrackingLink                   @"%@.xiti.com"
#define kWebViewHost_Ad4PushTracking                @"ad4pushtracker"
#define kWebViewHost_BackFirstModule                @"backtofirstmodulepageloaded"
#define kWebViewHost_OpenCardIo                     @"opencardio"
#define kWebViewHost_TriggerTutorial                @"triggerTutorial"
#define kWebViewHost_UserIsLogged                   @"userislogged"
#define kWebViewHost_OpenPage                       @"openpage"
#define kWebViewHost_ScanBarCode                    @"scanbarcode"
#define kWebViewHost_GetUserData                    @"getuserdata"
#define kWebViewHost_UpdateUserData                 @"updateuserdata"
#define kWebViewHost_GetStatusNotif                 @"getstatusnotif"
#define kWebViewHost_PopToFirstPage                 @"popToFirstPage"
#define kWebViewHost_ResetForm                      @"resetform"
/**
 *  Paiement Page
 */
#define kConfirmationPage                           @"views/confirmation.html"
#define kComplet                                    @"complete"
#define kCancel                                     @"cancel"
#define kLoginInscriptionPage                       @"lrmo-login-inscription.html"
/**
 *  JSon Node - Write Token
 */
#define kJsonNode_Data                              @"data"
#define kJsonNode_Webservices                       @"webservices"
#define kJsonNode_Key                               @"key"
#define kJsonNode_Token                             @"token"
#define kJsonNode_Favo                              @"favo"

/**
 *  JSon Node - Write Json
 *  Defined at Define_Common in shared project
 */

/**
 *  Json node - display popin
 */
#define kJsonNode_NameViewURL                       @"nameViewURL"

/**
 *  Json Node - Alert Popin
 */
#define kJsonNode_Title                             @"title"
#define kJsonNode_Message                           @"message"
#define kJsonNode_btnObj1                           @"btnObj1"
#define kJsonNode_btnObj2                           @"btnObj2"
#define kJsonNode_btnTitle                          @"title"
#define kJsonNode_Favorite                          @"favorite"
#define kJsonNode_Detail                            @"details"
#define kJsonNode_Destination                       @"destination"
/**
 *  Json node - Picture picker
 */
#define kJsonNode_Image64                            @"image"
#define kJsonNode_Image64Key                         @"original"
#define kJsonNode_Image64DataFormat                  @"data:image/png;base64,%@"

/**
 *  Json node - social network
 */
#define kJsonNode_APPURL                            @"appurl"
#define kJsonNode_NetworkUrl                        @"networkurl"

/**
 *  Json node - navigation back
 */
#define kJsonNode_NavigationBackView                @"view"
#define kJsonNode_NavigationBackRoot                @"root"

/**
 *  Json node - trigger tutorial
 */
#define kJsonNode_IdTuto                            @"id_tuto"
#define kJsonNode_IdTuto_Favourite                  @"Calculateur"
#define kJsonNode_IdTuto_Map                        @"Localisation"
#define kJsonNode_IdTuto_Suivre                     @"Suivre_envoi"

/**
 *  Set Favorite
 */
#define kJsonNode_Id                                @"id"
#define kJsonNode_TypeFavorite                      @"typeFavorite"
#define kJsonNode_FavoriteUrl                       @"urldetailpage"
#define kJsonNode_Status                            @"status"
#define kJsonNode_Null                              @"null"

#define kJsonNode_IdSuivi                           @"idSuivi"

/**
 *  User Notifications
 */
#define kJsonNode_Alerts                            @"alertes"
#define kJsonNode_AlertsInner                       @"rocs1"

/**
 
 
 /**
 *  Protocol Tracking
 *  Defined at Define_Common in the common shared project
 */
#define kJsonNode_Type                              @"type"
#define kJsonNode_MyPageLabel                       @"myPageLabel"
#define kJsonNode_AndPageChapter                    @"andPageChapter"
#define kJsonNode_SetLevel2                         @"setLevel2"
#define kJsonNode_Clicktype                         @"clicktype"
#define kJsonNode_ClickName                         @"click_name"
#define kJsonNode_TypeIn                            @"typein"
#define kJsonNode_Level2                            @"level2"

#define kJsonNode_ChangePage                        @"changePage"
#define kJsonNode_Link                              @"link"
#define kJsonNode_Colisid                           @"colisid"

#define kJsonNode_Path                              @"path"
#define kJsonNode_Module                            @"module"

#define kJsonValue_SubScribe                        @"subscribe"
#define kJsonValue_UnSubScribe                      @"unsubscribe"


#define kJsonNode_CardIoURL                        @"callbackpaiement"
#define kJsonNode_IsPageExists                      @"isPageExists"

/**
 *  Protocol Browers
 */
#define kUrlHttp                                    @"http://"
#define kUrlHttps                                   @"https://"

/**
 *  Core Data
 */
#define kDataModel_Name                             @"Laposte"
#define kData_SQLite_FileName                       @"Laposte.sqlite"

/**
 *  Table Favorite
 */
#define kTable_Favorite_UID                         @"uid"
#define kTable_Favorite_Type                        @"favorite_type"
#define kTable_Favorite_ID                          @"favorite_id"
#define kTable_Favorite_Data                        @"favorite_data"
#define kTable_Favorite_Date                        @"date"
#define kTable_Favorite_Url                         @"favorite_url"
#define kTable_Favorite_Date_Change                 @"date_change"
#define kTable_Favorite_Is_Subscribe                @"is_subscribe"
#define kTable_Favorite_Status_Add                  1
#define kTable_Favorite_Status_Remove               0
#define kTable_Favorite_Status_Timestamp            @"timestamp"
#define kTable_Favorite_Popin_Text                  @"popin_text"
#define kTable_Favorite_Popin_Tag                   @"popin_tag"

#define kB4SEvent_Favorite_Suivi                    @"favo_suivi"
#define kB4SEvent_Favorite_Localiser                @"favo_envoyer"
#define kB4SEvent_Favorite_Envoyer                  @"favo_suivi"
#define kB4SEvent_Favorite_PAPLR                    @"favo_paplr"
//B4S Tracking
#define kCCU_TrackingB4S_KeyEvent           @"event"
#define kCCU_TrackingB4S_KeyUserData        @"userData"
#define kCCU_TrackingB4S_Dictionary         @"B4STag"

/**
 *  Table Notifications
 */
#define kTable_Notifications_UID                    @"uid"
#define kTable_Notifications_Date                   @"date"
#define kTable_Notifications_Title                  @"title"
#define kTable_Notifications_Msg                    @"msg"
#define kTable_Notifications_Already_Read           @"already_read"
#define kTable_Notifications_Notif_ID               @"notif_id"

#pragma mark - NSUserDefault-Key
/**
 *  NSUserDefault - Key
 */
#define kUserDefault_UserVersion                    @"user_version"
#define kUserDefault_Favorite_UID                   @"favorite_uid"
#define kUserDefault_Notifications_UID              @"notifications_uid"
#define kUserDefault_NotificationId                 @"notificationId"
#define kUserDefault_LoadCache                      @"webViewLoadCache"
#define kUserDefault_AppUpdate_attempt              @"appUpdateAttempt"
#define kUserDefault_CacheModule                    @"cacheModule"
#define kUserDefault_LoadCached                     10
#define kUserDefault_CacheModule                    @"cacheModule"
#define kUserDefault_CurrenToken                    @"currentUserTocken"
#define kAFHTTPError_401                            401

#define kNotification_Title                         @"title"
#define kNotification_Msg                           @"msg"
#define kUserDefault_HandleDeeplink                 @"handleOpenDeepLink"

/**
 *  DevMode
 */
#define kUserDefault_DevMode                        @"devmode"
#define kUserDefault_PushDidacticiel                @"pushDidacticiel"
#define kUserDefault_PushDidacticiel_Value          11
#define kUserDefault_PopInStack                     @"displayPopInStack"
#define kUserDefault_OpenPageCCUIndex               @"kOpenPageCCUIndex"

/**
 *  Link Define
 */
#define kLink_AppStore                              @"itms-apps://itunes.apple.com/app/%@"


#define kAdmod_ID                                   @"10787"
#define kAdmod_FullBanner_ID                        @"10788";

/**
 *  Navigation Controller Type
 */
#define kNavigation_Push_Popin                      @"popin"
#define kNavigation_Push_Navigation                 @"navigation"
#define kNavigation_Push_Custom                     @"custom"

/**
 *  Burger menu index
 */
#define kBurgerMenu_Accueil                         0
#define kBurgerMenu_Favoris                         1
#define kBurgerMenu_Memory                          2
#define kBurgerMenu_Suivit                          3
#define kBurgerMenu_Notifications                   4
#define kBurgerMenu_Didactitiel                     5

//#define kBurgerMenu_Produit                         2


#define kNavigation_TitleColor                      [Utils colorFromHexString:kColor_BurgerMenu]

//define color navigation for Recevoir
#define kNavigation_Recevoir_TitleColor             [Utils colorFromHexString:kColor_Recevoir_Red]
#define kNavigation_DefaultColor                    [Utils colorFromHexString:kColor_DefaultColor]

#define kLocaliserController                        10

#define kTime_Delay_PushMainMenu                    3.0

#define kTracking_Type_Page                         @"page"
#define kTracking_Type_Event                        @"click"
#define kTracking_Type_Order                        @"order"
#define kTracking_Type_Tarif                        @"tarif"

/**
 *  Define Tracking Field
 */
#define kTracking_tracking                          @"tracking"
#define kTracking_accueil                           @"accueil"
#define kTracking_interstitiel                      @"interstitiel"
#define kTracking_lexique_interstitiel                      @"lexique_interstitiel"
#define kTracking_fermeture                         @"fermeture"
#define kTracking_background                        @"background"
#define kTracking_burgersection                     @"burgersection"
#define kTracking_calcultarif                       @"calcultarif"
#define kTracking_bureaufavoris                     @"bureaufavoris"
#define kTracking_bureaufavorisAccount              @"bureaufavorisfromAccount"
#define kTracking_produitfavoris                    @"produitfavoris"
#define kTracking_suiviencours                      @"suiviencours"
#define kTracking_suivipopin_favorite               @"suivi_envois_en_cours"
#define kTracking_suivipopin_module                 @"suivi_des_envois"
#define kTracking_notifications                     @"notifications"
#define kTracking_moduleapplication                 @"moduleapplication"
#define kTracking_splash                            @"splash"
#define kTracking_submenu                           @"submenu"
#define kTracking_mentionlegal                      @"mentionlegal"
#define kTracking_myPageLabel                       @"myPageLabel"
#define kTracking_andPageChapter                    @"andPageChapter"
#define kTracking_autreapplication                  @"autreapplication"
#define kTracking_autreapplicationList              @"liste"
#define kTracking_autreapplicationDetails           @"details"
#define kTracking_autreapplicationDetailsPageLabel  @"myPageLabel"

#define kTracking_Title                             @"<thenavigationname>"
#define kTracking_appName                           @"<application_name>"

#define kTracking_SubcribeFavourite                 @"suiviencours_notif_subscrib"
#define kTracking_UnSubcribeFavourite               @"suiviencours_notif_unsubscrib"

#define kNotificationCenterPreloadWebView           @"NotificationCenterPreloadWebView"
#define kNotificationCenterPreloadWebViewFromPW     @"kNotificationCenterPreloadWebViewFromPW"
#define kNotificationCenterImageDidUpdate           @"kNotificationCenterImageDidUpdate"
#define kNotificationCenter_UpdateErrorView         @"kNotificationCenter_UpdateErrorView"
#define kNotificationCenter_UpdateDynamicView       @"kNotificationCenter_UpdateDynamicView"
#define kNotificationCenter_CheckOriginalValue      @"kNotificationCenter_CheckOriginalValue"
#define kNotificationCenter_ClosePopIn              @"kNotificationCenter_ClosePopIn"

#define kTracking_AppClick                          @"appclickevent"

// Burger menu click
#define kTracking_Click_Calcultarif                 @"burger_calcultarif"
#define kTracking_Click_Bureaufavoris               @"burger_bureaufavoris"
#define kTracking_Click_Produitfavoris              @"burger_produitfavoris"
#define kTracking_Click_Suiviencours                @"burger_suiviencours"
#define kTracking_Click_Notification                @"burger_notification"
#define kTracking_Click_VisiteGuide                 @"burger_visiteguide"

#define kTracking_Click_Didacticiel_Quitter         @"didacticiel_quitter"
#define kTracking_Click_SubscribePushSuiviencours   @"suiviencours_notif_unsubscrib"
#define kTracking_Click_UnSubscribePushSuiviencours @"suiviencours_notif_subscrib"
#define kTracking_Click_Popin_Suivi_Des_Envois      @"suivi_des_envois"

#define kTracking_Click_Didacticiel_Quitter @"didacticiel_quitter"

// Module
#define kModule_Messagerie                          @"external-messagerie"
#define kModule_Banquepostale                       @"external-banque"


/**
 *  Ad4Push Tracking
 */

#define kAd4Push_DataObj                            @"dataObj"
#define kAd4Push_Cle1                               @"cle1"
#define kAd4Push_Valeur1                            @"valeur1"
#define kAd4Push_Cle2                               @"cle2"
#define kAd4Push_Valeur2                            @"valeur2"
#define kAd4Push_inscription                        @"inscription"
#define kAd4Push_insYValue                          @"Y"
#define kAd4Push_insNValue                          @"N"
#define kAd4Push_client_id                          @"client_id"
#define kAd4Push_email                              @"email"

#define kAd4Push_inscription_success                @"inscription=successful"
#define kAd4Push_connextion_success                 @"connexion=successful"
#define kAd4Push_user_type                          @"usertype"
#define kAd4Push_user_id                            @"userid"

#define kAd4Push_profile                            @"profil"
#define kAd4Push_profile_user1                      @"nouveau"
#define kAd4Push_profile_user3                      @"boutique"
#define kAd4Push_profile_user4                      @"client"
#define kAd4Push_profile_user5                      @"compte lié"
#define kAd4Push_profile_user6                      @"compte non lié"

#define kAd4Push_lead_inscription_label             @"10"
#define kAd4Push_lead_inscription_value_Yes         @"YES"

//Boutique Tracking
//#define kAd4Push_date_derniere_visite               @"date_derniere_visite"
//#define kAd4Push_date_dernier_achat                 @"date_dernier_achat"
//#define kAd4Push_nb_achats_app                      @"nb_achats_app"
//#define kAd4Push_nom_produits                       @"nom_produits"
//#define kAd4Push_gamme_produits                     @"gamme_produits"
//#define kAd4Push_code_promo                         @"code_promo"
//#define kAd4Push_montant_derniere_commande          @"montant_derniere_commande"


/**
 *  Banner attri
 */
#define kBanners_Burger                             @"burger"
#define kBanners_Interstitiel                       @"interstitiel"


/**
 *  Notification Push Key
 */
#define kNotifications_aps                          @"aps"
#define kNotifications_alert                        @"alert"
#define kNotifications_notifId                      @"id"


#define kBugTracking_Key                            @"AD-AAB-AAA-EUH"

#define kCountryCode                                @"FR"
#define kFranceISOCode                                @"FR"

/**
 *  External link for cgu cookies
 */

#define kExternal_Cookies                           @"externallink_cookies"


#define kUser_Email                             @"UserEmail"
#define kUser_Password                          @"UserPassword"
#define kUser_FirstName                         @"User_FirstName"
#define kUser_LastName                          @"User_LastName"
#define kUser_PhoneNumber                       @"User_PhoneNumber"
#define kUser_Birthday                          @"User_Birthday"
#define kUser_Gender                            @"User_Gender"

/**
 *  Input field define
 */
#define kInput_Type                             @"type"
#define kInput_Type_Email                       @"email"
#define kInput_Type_Password                    @"password"
#define kInput_Type_Text                        @"text"
#define kInput_Type_Number                      @"number"
#define kInput_Type_Phone_Number                @"phoneNumber"
#define kInput_Type_Name                        @"name"
#define kInput_Type_Default                     @"default"
#define kInput_PlaceHolder                      @"placeholder"
#define kInput_Error                            @"error"
#define kInput_Error_Message                    @"error_message"
#define kInput_Tracking_field                   @"tracking_field"
#define kInput_Tracking_key                     @"tracking_key"
#define kInput_Level2                           @"level2"
#define kInput_ClickType                        @"clickType"
#define kInput_CountryCode                      @"countryCode"
#define kInput_ReturnType                       @"returnType"

#define kInput_FieldName                        @"field_name"
#define kInput_Field_Email                      @"email"
#define kInput_Field_Password                   @"password"
#define kInput_Field_ConfirmPasswod             @"confirm_password"
#define kInput_Field_ConfirmEmail               @"confirm_email"
#define kInput_Field_Telephone                  @"telephone"
#define kInput_Field_Firstname                  @"firstname"
#define kInput_Field_Lastname                   @"lastname"
#define kInput_Field_Sna2                       @"sna2"
#define kInput_Field_Sna3                       @"sna3"
#define kInput_Field_Sna4                       @"numero_libelle"
#define kInput_Field_Sna5                       @"sna5"
#define kInput_Field_Ville                      @"ville"
#define kInput_Field_PostalCode                 @"postal"
#define kInput_Field_Pays                       @"pays"
#define kInput_Field_NewPassword                @"new_password"
#define kInput_Field_NewEmail                   @"new_email"
#define kInput_Field_Civility                   @"civility"
#define kInput_Field_Date                       @"date"

#define kInput_Validate                         @"validate"
#define kInput_Dynamic                          @"dynamic"
#define kInput_Static                           @"static"
#define kInput_ValidateType                     @"validateType"
#define kInput_ValidateMatch                    @"validateMatch"
#define kInput_ValidateValue                    @"validateValue"
#define kInput_Help                             @"help"
#define kInput_HelpValue                        @"helpValue"
#define kInput_IsRequired                       @"isRequired"
#define kInput_Tag                              @"tag"
#define kInput_ContentString                    @"content_string"
#define kInput_ContentString_Underline          @"content_string_underline"
#define kInput_Editable                         @"Editable"

#define kInput_cbDescription                    @"cbDescription"
#define kInput_cbText1                          @"cbText1"
#define kInput_cbText2                          @"cbText2"
#define kInput_Original                         @"original"
#define kInput_OldOriginal                      @"old_original"
#define kInput_IsInitUnselect                   @"is_init_unselect"
#define kInput_IsEnableTouch                    @"is_enable_touch"


#pragma mark - CCU Webservice

#define kCCU_Param_ClientID                     @"client_id"
#define kCCU_Param_ClientSecret                 @"client_secret"
#define kCCU_Param_GrantType                    @"grant_type"

#define kCCU_Param_TokenDict                    @"token_dict"
#define kCCU_Param_PartCustomer                 @"PartCustomer"

// comande

#define kCCU_Param_eBoutiqueCustomerOrders      @"eBoutiqueCustomerOrders"
#define kCCU_Param_lELOrders                    @"lELOrders"
#define kCCU_Param_mTELOrders                   @"mTELOrders"
#define kCCU_Param_lREOrderLine                 @"lREOrderLine"
#define kCCU_Param_mTELOrder                    @"mTELOrder"
#define kCCU_Param_OrderID                      @"orderID"
#define kCCU_Param_TotalPrice                   @"totalPrice"
#define kCCU_Param_OrderDate                    @"orderDate"
#define kCCU_Param_Quantity                     @"quantity"
#define kCCU_Param_SupportName                  @"supportName"
#define kCCU_Param_FormatName                   @"formatName"
#define kCCU_Param_CommandDetailUrl             @"commandDetailUrl"

#define kCCU_Param_UserType                     @"user_type"
#define kCCU_Param_Oauth2Token                  @"oauth2Token"
#define kCCU_Param_OldEmail                     @"old_email"
#define kCCU_Param_NewEmail                     @"new_email"
#define kCCU_Param_BirthDate                    @"birthDate"

// create user ccu

#define kCCU_Param_Type                         @"type"
#define kCCU_Param_Migrated                     @"migrated"
#define kCCU_Param_AcceptCgu                    @"acceptCgu"
#define kCCU_Param_EmailMigratedCcmu            @"emailMigratedCcmu"
#define kCCU_Param_Token                        @"token"
#define kCCU_Param_Email                        @"email"


#define kCCU_Param_From                         @"from"
#define kCCU_Param_Dashboard                    @"dashboard"
#define kCCU_Param_Register                     @"register"


// ccmu login

#define kCCU_Param_Format                       @"format"
#define kCCU_Param_RememberMe                   @"rememberMe"
#define kCCU_Param_Success                      @"success"
#define kCCU_Param_RedirectUri                  @"redirect_uri"

// ccmu migrate
#define kCCU_Param_CCUID                        @"ccuId"

// ccmu user
#define kCCU_Param_CCMUCivility                 @"civility"
#define kCCU_Param_Message                      @"message"
#define kCCU_Param_CCMUFirstName                @"firstName"
#define kCCU_Param_CCMULastName                 @"lastName"
#define kCCU_Param_CCMUPersonalPhone            @"personalPhone"
#define kCCU_Param_CCMUGroupBySms               @"groupBySms"
#define kCCU_Param_CCMUGroupByEmail             @"groupByEmail"
#define kCCU_Param_CCMUPartnerByEmail           @"partnerByEmail"
#define kCCU_Param_CCMUUserData                 @"userData"

// Tutorial ccu

#define kTutorial_CirclePos                     @"turorial_circle_pos"
#define kTutorial_CirclePosIP4                  @"turorial_circle_pos_ip4"

#define kTutorial_Header                        @"tutorial_header"
#define kTutorial_Description                   @"tutorial_description"
#define kTutorial_NextButtonColor               @"tutorial_nextButton_color"
#define kTutorial_NextButtonTextColor           @"tutorial_nextButton_text_color"
#define kTutorial_ContainerViewPosY             @"tutorial_containerView_posY"
#define kTutorial_ContainerViewPosYIP4          @"tutorial_containerView_posY_ip4"
#define kTutorial_BackgroundImage               @"tutorial_background_image"
#define kTutorial_BackgroundImageIP4            @"tutorial_background_image_ip4"

#define kTutorial_CircleRadius                  @"tutorial_rarius"
#define kTutorial_IsCircleAnimate               @"circle_animate"
#define kTutorial_NeedScrollTableView           @"tutorial_scroll"

#define kTutorial_MainScreen                    @"tutorial_main_screen"
#define kTutorial_Connection                    @"tutorial_connection"
#define kTutorial_MapScreen                     @"tutorial_map_screen"
#define kTutorial_SuiviScreen                   @"tutorial_suivi_screen"
#define kTutorial_TarifScreen                   @"tutorial_tarif_screen"

#define kNotificationCenter_TutorialScrollTableView @"tutorial_scroll_tableview"
#define kNotificationCenter_TutorialNextSelectedItemNumber @"tutorial_scroll_tableview_ItemSelected"
#define kNotificationCenter_TutorialWillClose @"tutorial_scroll_tableview_will_close"

// View controller Identifier

#define kIdentifier_User1Step01VC               @"inscriptionUser1Step1VCIdentifier"
#define kIdentifier_User3Step02VC               @"inscriptionUser3Step2VCIdentifier"
#define kIdentifier_User4Step02VC               @"inscriptionUser4Step2VCIdentifier"
#define kIdentifier_User5Step02VC               @"inscriptionUser5Step2VCIdentifier"
#define kIdentifier_User6Step02VC               @"inscriptionUser6Step2VCIdentifier"
#define kIdentifier_User6Step03VC               @"inscriptionUser6Step3VCIdentifier"
#define kIdentifier_ConfirmEdition              @"confirmEditionVCIdentifier"
#define kIdentifier_CguCCUVCIdentifier          @"cguCCUVCIdentifier"

// CCU Popup view

#define kCCUPopup_Message                       @"ccu_popup_message"
#define kCCUPopup_BoldString                    @"ccu_popup_bold"
#define kCCUPopup_Url                           @"ccu_popup_url"
#define kCCUPopup_TrackingKey                   @"tracking_key"
#define kCCUPopup_TrackingField                 @"tracking_field"


#define kSchema_Laposte                         @"laposte"
#define kURL_Identifier                         @"com.laposte.laposte"

//updateDeviceInfo tracking
#define kJsonNode_Localisation_bureauposte                              @"Bureau de poste"
#define kUpdateInfoTracking_Localisation_bureauposte                    @"date_bureauposte"

#define kJsonNode_Localisation_pointretrait                             @"Point de retrait ou dépôt colis"
#define kUpdateInfoTracking_Localisation_pointretrait                   @"date_pointretrait"

#define kJsonNode_Calculateur_tarif                                     @"Calcul de tarif"
#define kUpdateInfoTracking_Calculateur_tarif                           @"date_clic_tarif"


#define kJsonNode_preparer_recherche_cp_commune                         @"Recherche de code postal ou commune"
#define kUpdateInfoTracking_preparer_recherche_cp_commune               @"recherche_cp_commune"

#define kJsonNode_preparer_recherche_test_adresse                       @"Test d'adresse"
#define kUpdateInfoTracking_preparer_test_adresse                       @"test_adresse"

#define kJsonNode_suivi_d_envoi                                         @"Suivi d'envoi "
#define kUpdateInfoTracking_suivi_d_envoi                               @"suivi_d_envoi"
#define kDescription_Text_scan_suivi_d_envoi                            @"Alignez le lecteur sur le code-barre de l'enveloppe ou du colis."

#define kJsonNode_Macartamoi                                            @"Commencer la personnalisation"
#define kUpdateInfoTracking_Macartamoi_commencer_personnalisation       @"commencer_personnalisation"

#define kUpdateInfoTracking_Boutique_Access_Date                        @"date_visite_boutique"
// Inscription user 4
#define kJsonNode_Disabled_Account @"DISABLED_ACCOUNT"


//-------
#define kCCU_Param_TypeFavo                         @"typefavo"
#define kCCU_Param_Ids                              @"ids"

#define kCCU_Param_Sync_Id                               @"id"
#define kCCU_Param_Sync_Status                           @"status"
#define kCCU_Param_Sync_Timestamp                        @"timestamp"
#define kCCU_Param_Sync_Is_Subcribe                      @"is_subscribe"

#define kCCU_UserDefaults_ChangeFavorite                 @"ChangeFavorite"
#define kCCU_UserDefaults_DownLoadModule                 @"DownLoadModule"
#define kCCU_UserDefaults_ModuleUnzip                    @"ModuleUnzip"

#define APPID_B4S                                        @"ff516690-6602-11e4-9c72-1fb60f738b39"
//B4S Tracking
#define kCCU_TrackingB4S_KeyEvent           @"event"
#define kCCU_TrackingB4S_KeyUserData        @"userData"
#define kCCU_TrackingB4S_Dictionary         @"B4STag"


//TEST UESR_ID
#define TEST_USER_ID                @"5357488637043"

#define disabled_account @"DISABLED_ACCOUNT"

/**
 *  Countries
 */
#define kJsonValue_Code                             @"code"
#define kJsonValue_Name                             @"name"
#define kLocalizedString_CCU_Input_Pays             @"CCU_Input_Pays"

/*
 *  E-mail update keys
 */
#pragma mark - E-mail update keys

//PAPLR Module Constants

#define LocalizedAddressFieldMandatory                  @"hybris_address_creation_field_mandatory_error"
#define LocalizedAddressFirstOptionUserCivility         @"hybris_address_creation_field_user_title_first_option"
#define LocalizedAddressSecondOptionUserCivility        @"hybris_address_creation_field_user_title_second_option"
#define Address_Creation_France_Code                    @"fr"
#define mascadiaErrorValueForTest                       -1
#define mascadiaCorrectValueForTest                     0
#define interface_title_sneder_backgroundColor          @"#F5B9A5"

#define address_dict_title_key                          @"titleCode"
#define address_dict_first_name_key                     @"firstName"
#define address_dict_last_name_key                      @"lastName"
#define address_dict_apartment_key                      @"apartment"
#define address_dict_building_key                       @"building"
#define address_dict_street_key                         @"line1"
#define address_dict_locality_key                       @"line2"
#define address_dict_postal_code_key                    @"postalCode"
#define address_dict_town_key                           @"town"
#define address_dict_country_key                        @"country.isocode"
#define address_dict_social_key                         @"raisonSociale"
#define address_dict_service_key                        @"service"
#define address_dict_email_key                          @"email"

#define AddressUserFirstOptionCode                      @"mrs"
#define AddressUserSecondOptionCode                     @"mr"

#define AddressTypeUserFirstOptionCode                  @"pro"
#define AddressTypeUserSecondOptionCode                 @"part"


// CCU
#define kCCU_Param_Saisie                       @"saisie"
#define kCCU_Param_Civilite                     @"civilite"
#define kCCU_Param_NameNom                      @"nom"
#define kCCU_Param_NamePrenom                   @"prenom"
#define kCCU_Param_Ligne1                       @"ligne1"
#define kCCU_Param_Ligne2                       @"ligne2"
#define kCCU_Param_Ligne3                       @"ligne3"
#define kCCU_Param_Ligne4                       @"ligne4"
#define kCCU_Param_Ligne5                       @"ligne5"
#define kCCU_Param_Ligne6                       @"ligne6"
#define kCCU_Param_Ligne7                       @"ligne7"

#endif /* MCMDefine_h */



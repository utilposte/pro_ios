//
//  TaggingData.swift
//  LaPostePro
//
//  Created by Lassad Tiss on 12/09/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import UIKit

class TaggingData: NSObject {
    
    // Config
    static let kATTagSubDomain = "logc409"
    
    // Level
    static let kHomeLevel:          Int32 = 1
    static let kTransverseLevel:    Int32 = 2
    static let kLocaliseLevel:      Int32 = 3
    static let kTrackingLevel:      Int32 = 4
    static let kCommerceLevel:      Int32 = 5
    static let kSearchLevel:        Int32 = 6
    static let kAccountLevel:       Int32 = 7
    
    //--------------------------------------------//
    // Chapter
    //--------------------------------------------//
    
    // Home
    static let kMeilleuresVentes = "meilleures_ventes"
    static let kEntreesServices = "entrees_services"
    static let kTousNosArticles = "tous_nos_articles"
    static let kSuivre          = "suivre"
    static let kKocaliser       = "localiser"
    static let kArticles        = "articles"
    static let kPro             = "pro"
    
    // Transverse
    static let kHeader          = "header"
    static let kTabBar          = "tab_bar"
    static let kFooter          = "footer"
    static let kChampRecherche  = "champ_recherche"
    
    // Localise
    static let kPostOffice      = "bureau_poste"
    static let kWithdrawalPoint = "point_retrait"
    static let kBal             = "bal"
    static let kDepositPoint    = "point_depot"
    static let kGeolocalisation = "geolocalisation"
    
    static let kResume = "resume"
    static let kFicheDetail = "fiche_detail"
    
    // Tracking
    static let kTrackingHomeChapter = "accueil::suivi"
    
    // Commerce
    static let kProductsList    = "liste_produits"
    static let kProductDetails  = "fiche_produit"
    static let kTunnel          = "tunnel"
    static let kZoom            = "zoom_visuel"
    static let kTri             = "tri"
    static let kFiltre          = "filtre"
    static let kCrossSelling    = "cross_selling"
    static let kTimbreDuMoment  = "timbre_du_moment"
    static let kRecommandation  = "recommandation"
    static let kAjoutArticleAssocie  = "ajout_article_associe"
    
    // Search
    static let kKeyboard        = "clavier"
    static let kVoiceCommand    = "commande_vocale"
    
    // Account
    static let kRegister        = "inscription"
    static let kYourProfile     = "votre_profil"
    static let kMyOrders        = "mes_commandes"
    static let kMyAddressBook   = "mon_carnet_adresse"
    static let kMyFavorites     = "mes_favoris"
    static let kPersonal        = "personnel"
    static let kEntreprise      = "entreprise"
    static let kFicheContact    = "fiche_contact"
    static let kCreerContactHeader = "creer_contact_header"
    static let kContactUs = "contactez_nous"
    

    //--------------------------------------------//
    // Page
    //--------------------------------------------//
    
    // Home
    static let kHomeNotConnected = "home_non_connecte"
    static let kHomeConnected = "home_connecte"
    static let kPopinForgottenPassword = "popin_mdp_oublie"
    
    // Localise
    static let kLocaliserHome = "accueil_localisateur"
    static let kFiltredTypePoint = "filtrer_type_point"
    static let kCalendar = "calendrier_des_horaires"
    
    // Tracking
    static let kTrackingHome = "accueil_suivi"
    static let kNewTracking = "suivre_nouvel_envoi"
    static let kTrackingDetails = "detail_suivi"
    static let kFiltredByDate = "filtrer_par_dates"
    
    // Commerce
    static let kCommerceHome = "accueil_boutique"
    static let kCart = "panier"
    static let kContractDetails = "details_contrat"
    static let kAddressAndDeliveryType = "adresse_et_mode_de_livraison"
    static let kAddDelivreyAddress = "ajouter_adresse_livraison"
    static let kCardChoice = "choix_cb"
    static let kPaiementConfirmation = "confirmation_paiement"
    
    // Search
    static let kSearchHome = "accueil_recherche"
    static let kSearchPage = "page_recherche"
    static let kResultPage = "page_resultat"
    static let kPopinSearchHome = "popin_accueil_recherche"
    static let kPopinResult = "popin_resultat"
    
    // Account
    static let kHome = "accueil"
    static let kPopinCertificationInstruction = "popin_instruction_certification"
    static let kPopinDisconnect = "popin_deconnexion"
    static let kIdentifiers = "identifiants"
    static let kActivity = "activite"
    static let kInformations = "informations"
    static let kPopinDeleteAccount = "popin_suppression_compte"
    static let kEditEmail = "modifier_email"
    static let kEditPassword = "modifier_mdp"
    static let kEditInformations = "modifier_informations"
    static let kEditAddress = "modifier_adresse_postale"
    static let kOrderDetails = "details_commande"
    static let kReturnOrder = "retourner_commande"
    static let kNewOrder = "nouveau_contact"
    static let kEdit = "modifier"
    static let kContactManagement = "gestion_contact"
    static let kHomeWithoutFavotites = "accueil_sans_favori"
    static let kProducts = "produits"
    static let kPostalOffices = "bureaux_poste"
    
    //--------------------------------------------//
    // Click
    //--------------------------------------------//
    
    // Home
    static let kMdpOublie = "mdp_oublie"
    static let kEnvoyerMail = "envoyer_mail"
    static let kToutVoir = "tout_voir"
    static let kCommanderTimbres = "commander_timbres"
    static let kAjouterStickerSuivi = "ajouter_sticker_suivi"
    static let kEnvoyerColisAvecEmballage = "envoyer_colis_avec_emballage"
    static let kTimbresMarianne = "timbres_marianne"
    static let kBeauxTimbres = "beaux_timbres"
    static let kEnveloppesPreaffranchies = "enveloppes_preaffranchies"
    static let kEmballagesPreaffranchis = "emballages_preaffranchis"
    static let kStickerSuivi = "sticker_suivi"
    static let kNouveauColis = "nouveau_colis"
    static let kTousLesSuivis = "tous_les_suivis"
    static let kBureauxDePostePlusProches = "bureaux_de_poste_plus_proches"
    static let kFinaliserCommande = "finaliser_commande"
    static let kVoirDerniereCommande = "voir_derniere_commande"
    static let kVoirFavoris = "voir_favoris"
    static let kToutVoirDerniersArticles = "tout_voir_derniers_articles"
    static let kVoirSolutionsPersonnalisees = "voir_solutions_personnalisees"
    
    // Transverse
    static let kMonCompte = "mon_compte"
    static let kPictoLaposte = "picto_laposte"
    static let kBoutonRecherche = "bouton_recherche"
    static let kBoutonCommandeVocale = "bouton_commande_vocale"
    static let kProduitsRecommandations = "produits_recommandations"
    static let kPushCrossSelling = "push_cross_selling"
    static let kHomePro = "home_pro"
    static let kBoutique = "boutique"
    static let kLivraisonGratuite = "livraison_gratuite"
    static let kAideEnLignePro = "aide_en_ligne_pro"
    static let kAppelerServiceClient = "appeler_service_client"
    static let kComptePrepayePro = "compte_prepaye_pro"
    static let kSatisfaitOuRembourse = "satisfait_ou_rembourse"
    
    // Localise
    static let kAccepter = "accepter"
    static let kAnnuler = "annuler"
    static let kVueListe = "vue_liste"
    static let kVueListeAjoutFavori = "vue_liste_ajout_favori"
    static let kVueCarte = "vue_carte"
    static let kAjoutFavoris = "ajout_favoris"
    static let kCommentSYRendre = "comment_s_y_rendre"
    
    // Tracking
    static let kFiltreColissimo = "filtre_colissimo"
    static let kFiltreCourrierSuivi = "filtre_courrier_suivi"
    static let kFiltreChronopost = "filtre_chronopost"
    static let kFiltreTousTypes = "filtre_tous_types"
    static let kRechercherNumero = "rechercher_numero"
    static let kAppliquer = "appliquer"
    
    // Commerce
    static let kVoirResultats = "voir_resultats"
    static let kCtaAjoutPanier = "cta_ajout_panier"
    static let kPartager = "partager"
    static let kAjouterAuxFavoris = "ajouter_aux_favoris"
    static let kAlerteDisponibilite = "alerte_disponibilite"
    static let kAjoutProduitCrossSelling = "ajout_produit_cross_selling"
    static let kSaisirCodePromo = "saisir_code_promo"
    static let kAppliquerCodePromo = "appliquer_code_promo"
    static let kProfiterOffrePromo = "profiter_offre_promo"
    static let kValiderAdresseLivraison = "valider_adresse_livraison"
    
    // Search
    static let kBoutonCommande_vocale_on = "bouton_commande_vocale_on"
    static let kBoutonCommandeVocaleOff = "bouton_commande_vocale_off"
    static let kFermeture = "fermeture"
    
    // Account
    static let kDeconnexion = "deconnexion"
    static let kBesoinAide = "besoin_aide"
    static let kSupprimer = "supprimer"
    static let kConfirmerSuppressionCompte = "confirmer_suppression_compte"
    static let kConfirmerModificationEmail = "confirmer_modification_email"
    static let kConfirmerModificationMdp = "confirmer_modification_mdp"
    static let kConfirmerModificationInformations = "confirmer_modification_informations"
    static let kConfirmerAdressePostale = "confirmer_adresse_postale"
    static let kCommandeIdentique = "commande_identique"
    static let kRenouvellerAchatArticle = "renouveller_achat_article"
    static let kTelechargerFacture = "telecharger_facture"
    static let kValidationRetourCommande = "validation_retour_commande"
    static let kContactezNous = "contactez_nous"
    static let kValidation = "validation"
    static let kCreerContact = "creer_contact"
    static let kImporterContactTelephone = "importer_contact_telephone"
    static let kImporterContactLinkedin = "importer_contact_linkedin"
    static let kCreer = "créer"
    static let kValiderModification = "valider_modification"
    static let kSuppression = "suppression"
    
    
    //Order statuses
    static let kStatusNotSet:           Int32 = 0
    static let kStatusWaiting:          Int32 = 1
    static let kStatusCanceled:         Int32 = 2
    static let kStatusValidated:        Int32 = 3
    static let kStatusReturned:         Int32 = 3
    
    //Delivery modes
    static let kDelivryNotSet = "Non renseigné"
    static let kDelivryColissimo = "1[Colissimo]"
    static let kDelivryColissimoSo = "2[So_Colissimo]"
    static let kDelivryStandard = "3[Livraison_Standard]"
    static let kDelivryChronopost = "4[Livraison_Chronopost]"
    
}

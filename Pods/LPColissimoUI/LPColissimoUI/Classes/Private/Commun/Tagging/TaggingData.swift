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
    static let kColissimoLevel:     Int32 = 50

    

    // Chapters
    static let kChapter1 = "eservice"
    static let kChapter2 = "colissimo_en_ligne"
    static let kChapter3 = "aide_au_choix"

    //--------------------------------------------//
    // Pages
    //--------------------------------------------//
    
    static let kE0Accueil = "e0_accueil"
    static let kE1ArriveeDepart = "e1_arrivee_depart"
    static let kE2Dimensions = "e2_dimensions"
    static let kFormatSaisie = "format_saisie"
    static let kFormatResultat = "format_resultat"
    static let kE3Poids = "e3_poids"
    static let kPoids = "poids"
    static let kE31FormalitesDouanieres = "e31_formalites_douanieres"
    static let kE4CoordonneesExpediteur = "e4_coordonnees_expediteur"
    static let kSercadia = "sercadia"
    static let kE5CoordonneesDestinataire = "e5_coordonnees_destinataire"
    static let kE6DepotLivraison = "e6_depot_livraison"
    static let kPopinRetourColis = "popin_retour_colis"
    static let kPopinTarifsIndemnisation = "popin_tarifs_indemnisation"
    static let kE7Recapitulatif = "e7_recapitulatif"
    static let kPopinRecapitulatif = "popin_recapitulatif"
    
    
    //--------------------------------------------//
    // Clicks
    //--------------------------------------------//
    
    static let kAjouterArticle = "ajouter_article"
    static let kDestinataireProfessionnel = "destinataire_professionnel"
    static let kActiverIndemnisation = "activer_indemnisation"
    static let kActiverRetourColis = "activer_retour_colis"
    static let kDupliquerColis = "dupliquer_colis"
    static let kMettreFavoriColis = "mettre_favori_colis"
    static let kSupprimerColis = "supprimer_colis"
    static let kAjouterNouveauColis = "ajouter_nouveau_colis"
    
    
}

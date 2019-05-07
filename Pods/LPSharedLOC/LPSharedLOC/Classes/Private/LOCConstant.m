//
//  LOCConstant.m
//  laposte
//
//  Created by Sofien Azzouz on 26/07/2017.
//  Copyright © 2017 laposte. All rights reserved.
//

#import <Foundation/Foundation.h>

NSString *const kLOC_generic_key = @"5a87b191f508e4bae9d1d06e9e50c297";

// W.S urls
NSString *const kLOC_list_bureaux_token     = @"https://www.laposte.fr/api/acores/bureau_proche_v2/lat/lng";
NSString *const kLOC_list_bureaux_nearby    = @"https://www.laposte.fr/api/acores/bureau_proche_v2";

NSString *const kLOC_list_bureaux           = @"https://www.laposte.fr/api/acores/bureau_v2";
NSString *const kLOC_list_depot_retrait     = @"https://www.laposte.fr/api/acores/retrait-depot";
NSString *const kLOC_get_city_by_position   = @"https://maps.googleapis.com/maps/api/geocode/json?latlng=";
NSString *const kLOC_detailPostOffice       = @"http://www.laposte.fr/api/acores/bureau_detail_v2";
NSString *const kLOC_postal_box_search     = @"https://datanova.laposte.fr/api/records/1.0/search/?dataset=laposte_boiterue&rows=10000&q=";

// Segue
NSString *const kPushOfficeDetailViewController   = @"pushOfficeDetailViewController";
NSString *const kPushOfficeDetailVCFomMapVC   = @"pushOfficeDetailVCFomMapVC";

// Tracking
NSString *const LOCTracking_Layout_ID_Retrait_Depot_Colis_Liste_Points = @"LOCTracking_Layout_ID_Retrait_Depot_Colis_Liste_Points";
NSString *const LOCTracking_Layout_ID_Retrait_Depot_Colis_Accueil = @"LOCTracking_Layout_ID_Retrait_Depot_Colis_Accueil";
NSString *const LOCTracking_Layout_ID_Retrait_Depot_Colis_Google_Map = @"LOCTracking_Layout_ID_Retrait_Depot_Colis_Google_Map";
NSString *const LOCTracking_Layout_ID_Retrait_Depot_Colis = @"LOCTracking_Layout_ID_Retrait_Depot_Colis";
NSString *const LOCTracking_Layout_ID_BP = @"LOCTracking_Layout_ID_BP";
NSString *const LOCTracking_Layout_ID_BP_Liste_Bureaux = @"LOCTracking_Layout_ID_BP_Liste_Bureaux";
NSString *const LOCTracking_Layout_ID_BP_Google_Map = @"LOCTracking_Layout_ID_BP_Google_Map";
NSString *const LOCTracking_Layout_ID_BP_Accueil = @"LOCTracking_Layout_ID_BP_Accueil";
NSString *const LOCTracking_Layout_ID_List_Favoris = @"LOCTracking_Layout_ID_List_Favoris";

//
//  LOCConstant.h
//  laposte
//
//  Created by Issam DAHECH on 21/07/2017.
//  Copyright © 2017 laposte. All rights reserved.
//

#define kYellowColor [UIColor colorWithRed:239.0f/255.0f green:187.0f/255.0f blue:65.0f/255.0f alpha:1.0].CGColor
#define kLightGreyColor [UIColor colorWithRed:202.0f/255.0f green:202.0f/255.0f blue:202.0f/255.0f alpha:1.0].CGColor

#define LOCLocalizedString(key, comment) [[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:@"LOC_Localizable"]
extern NSString *const kLOC_generic_key;

// W.S urls
extern NSString *const kLOC_list_bureaux_token;
extern NSString *const kLOC_list_bureaux_nearby;
extern NSString *const kLOC_list_bureaux;
extern NSString *const kLOC_list_depot_retrait;
extern NSString *const kLOC_get_city_by_position;
extern NSString *const kLOC_detailPostOffice;
extern NSString *const kLOC_postal_box_nearby;
extern NSString *const kLOC_postal_box_search;

// Segue keys
extern NSString *const kPushOfficeDetailViewController;
extern NSString *const kPushOfficeDetailVCFomMapVC;

// Tracking
extern NSString *const LOCTracking_Layout_ID_Retrait_Depot_Colis_Liste_Points;
extern NSString *const LOCTracking_Layout_ID_Retrait_Depot_Colis_Accueil;
extern NSString *const LOCTracking_Layout_ID_Retrait_Depot_Colis_Google_Map;
extern NSString *const LOCTracking_Layout_ID_Retrait_Depot_Colis;
extern NSString *const LOCTracking_Layout_ID_BP;
extern NSString *const LOCTracking_Layout_ID_BP_Liste_Bureaux;
extern NSString *const LOCTracking_Layout_ID_BP_Google_Map;
extern NSString *const LOCTracking_Layout_ID_BP_Accueil;
extern NSString *const LOCTracking_Layout_ID_List_Favoris;


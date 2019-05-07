//
//  MCMConstants.m
//  laposte
//
//  Created by Sofien Azzouz on 08/02/2018.
//  Copyright © 2018 laposte. All rights reserved.
//

#import "MCMConstants.h"

// ---- CardIo
NSString *const MCMCardIo_CardNumber = @"CARD_NUMBER";
NSString *const MCMCardIo_CardMonth = @"CARD_VAL_MONTH";
NSString *const MCMCardIo_CardYear = @"CARD_VAL_YEAR";
NSString *const MCMCardIo_CardVV = @"CVV_KEY";

// ---- Segue
NSString *const MCMSegue_HybrisCatalog = @"pushHybrisCatalogFromCategoriesList";
NSString *const MCMSegue_HybrisItemDetail = @"pushHybrisItemDetail";
NSString *const MCMSegue_HybrisItemDetailFromCategories = @"pushHybrisItemDetailFromCategories";
NSString *const MCMSegue_HybrisCartFromCatalogList = @"pushHybrisCartFromCatalogList";
NSString *const MCMSegue_HybrisCartFromCategories = @"pushHybrisCartFromCategories";
NSString *const MCMSegue_HybrisCartFromCatalogItemDetail = @"pushHybrisCartFromCatalogItemDetail";
NSString *const MCMSegue_HybrisDeliveryAddressFromCart = @"pushHybrisDeliveryAddressFromCart";
NSString *const MCMSegue_HybrisCartSummaryAddressFromCart = @"pushHybrisCartSummarylFromCartDetail";
NSString *const MCMSegue_HybrisPaymentWebviewFromCartSummary = @"pushHybrisPaymentWebviewFromSummary";
NSString *const MCMSegue_Unwind_HybrisPaymentWebviewToCartSummary = @"unwindHybrisPaymentWebviewToSummary";
NSString *const MCMSegue_Modal_ConnectionFromHybrisCart = @"modalConnectionFromHybrisCart";
NSString *const MCMSegue_Modal_RegistrationFromHybrisCart = @"modalRegistrationFromHybrisCart";
NSString *const MCMSegue_HybrisAddressCreateAndEditFromAddressSelection = @"pushHybrisAddressCreateAndEditFromAddressSelection";
NSString *const MCMSegue_HybrisPromotionCodeFromCart = @"pushHybrisPromotionFromCart";
NSString *const MCMSegue_AdresseIndiqueeFromAddressCreateAndEdit = @"pushAdresseIndiqueeFromAddressCreateAndEdit";
NSString *const MCMSegue_Unwind_ToCartValidationFromAddressCreateAndEdit = @"UnwindToCartValidationFromAddressCreateAndEit";
NSString *const MCMSegue_HybrisItemDetailFromCartDetail = @"pushHybrisItemDetailFromCartDetail";
NSString *const MCMSegue_ReexContractDetailFromCartDetail = @"pushReexContractDetailFromCartDetail";
NSString *const MCMSegue_HybrisItemDetailFromCartSummary = @"pushHybrisItemDetailFromCartSummary";
NSString *const MCMSegue_HybrisCartSummaryFromAddressSelection = @"pushHybrisCartSummaryFromAddressSelection";
NSString *const MCMSegue_UseMyLocationFromAddressSelection = @"pushUseMyLocationAddressFromAddressSelection";
NSString *const MCMSegue_CreateEditAddressFromUseMyLocationAddress = @"pushCreateEditAddressFromUseMyLocationAddress";
NSString *const MCMSegue_HybrisAddressCreateAndEditFromCartSummary = @"pushHybrisAddressCreateAndEditFromCartSummary";
NSString *const MCMSegue_Unwind_ToAddressSelection = @"UnwindToAddressSelectionSegue";
NSString *const MCMSegue_Unwind_ToCartValidation = @"UnwindToCartValidation";

@implementation MCMConstants

@end

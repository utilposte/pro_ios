//
//  MCMConstants.h
//  laposte
//
//  Created by Sofien Azzouz on 08/02/2018.
//  Copyright © 2018 laposte. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CartRequestLogin) {
    none,
    RequestedToContinueToAddresses,
    RequesteToContinueToVoucher,
    RequestedToContinueToCartSummary,
    RequestedToQuitEmptyCard
};

typedef NS_ENUM(NSInteger, HybrisCartCellType) {
    HybrisCartHeaderCell = 0,
    HybrisConfirmationButtonCell,
    HybrisOrderInfoTitleCell,
    HybrisProductCell,
    HybrisReexCell,
    HybrisVoucherCodeCell,
    HybrisCartTotalCell,
    HybrisCrossSellingCell,
    HybrisRegroupQuantityCell
};

//// CardIo
extern NSString *const MCMCardIo_CardNumber;
extern NSString *const MCMCardIo_CardMonth;
extern NSString *const MCMCardIo_CardYear;
extern NSString *const MCMCardIo_CardVV;

//// Segues
extern NSString *const MCMSegue_HybrisCatalog;
extern NSString *const MCMSegue_HybrisItemDetail;
extern NSString *const MCMSegue_HybrisItemDetailFromCategories;
extern NSString *const MCMSegue_HybrisCartFromCatalogList;
extern NSString *const MCMSegue_HybrisCartFromCatalogItemDetail;
extern NSString *const MCMSegue_HybrisDeliveryAddressFromCart;
extern NSString *const MCMSegue_HybrisCartSummaryAddressFromCart;
extern NSString *const MCMSegue_HybrisPaymentWebviewFromCartSummary;
extern NSString *const MCMSegue_Unwind_HybrisPaymentWebviewToCartSummary;
extern NSString *const MCMSegue_Modal_ConnectionFromHybrisCart;
extern NSString *const MCMSegue_Modal_RegistrationFromHybrisCart;
extern NSString *const MCMSegue_HybrisAddressCreateAndEditFromAddressSelection;
extern NSString *const MCMSegue_HybrisPromotionCodeFromCart;
extern NSString *const MCMSegue_AdresseIndiqueeFromAddressCreateAndEdit;
extern NSString *const MCMSegue_Unwind_ToCartValidationFromAddressCreateAndEdit;
extern NSString *const MCMSegue_HybrisItemDetailFromCartDetail;
extern NSString *const MCMSegue_ReexContractDetailFromCartDetail;
extern NSString *const MCMSegue_HybrisItemDetailFromCartSummary;
extern NSString *const MCMSegue_HybrisCartSummaryFromAddressSelection;
extern NSString *const MCMSegue_UseMyLocationFromAddressSelection;
extern NSString *const MCMSegue_CreateEditAddressFromUseMyLocationAddress;
extern NSString *const MCMSegue_HybrisAddressCreateAndEditFromCartSummary;
extern NSString *const MCMSegue_Unwind_ToAddressSelection;
extern NSString *const MCMSegue_HybrisCartFromCategories;
extern NSString *const MCMSegue_Unwind_ToCartValidation;

@interface MCMConstants : NSObject

@end

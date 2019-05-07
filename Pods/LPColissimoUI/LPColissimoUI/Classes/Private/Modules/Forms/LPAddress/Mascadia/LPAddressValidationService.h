//
//  LPAddressValidationService.h
//  RefonteFormulaire
//
//  Created by Sofien Azzouz on 18/01/2018.
//  Copyright © 2018 Sofien Azzouz. All rights reserved.
//



#import <Foundation/Foundation.h>
#import <LPSharedMCM/MCMUser.h>
#import <LPSharedMCM/HYBAddress.h>
#import <LPSharedMCM/MascadiaValidationResult.h>
#import <LPSharedMCM/MCMLoadingManager.h>
#import <LPSharedMCM/MCMAddressToDictionaryMapper.h>
#import <LPSharedMCM/LPSharedMCM-umbrella.h>
#import "LPAddressEntity.h"
#import "CLDefine.h"
//#import <LPColissimoUI/LPColissimoUI-umbrella.h>
//#import "LPColissimoUI-Swift.h"
//#import <LPSharedMCM/MCMDefine.h>
//#import <GooglePlaces/GooglePlaces.h>

typedef NS_ENUM(NSInteger, HybrisAddressSectionType) {
    HybrisDeliveryAddressSection = 0,
    HybrisBillingAddressSection,
    HybrisAddressNumberOfSections
};

typedef NS_ENUM(NSInteger, HybrisAddressCreateAndEditMode) {
    CreateDelivery = 0,
    CreateBilling,
    Edit
};

@class LPAddressEntity;

@interface LPAddressValidationService : NSObject
//+ (void)searchAddresses:(NSString *)searchText withCompletion:(void (^)(NSArray *addressesArray, MascadiaValidationResult *validationResult,  NSError* error)) completion;
+ (BOOL)mascadiaResultHasError:(MascadiaValidationResult*) result;
+ (MCMUser *)createMCMUserFromMascadiaAddress:(NSDictionary *)mascadiaDictionary lpAddress:(LPAddressEntity *)lpAddress;
+ (LPAddressEntity *)configureLPAddressFromUserAccount:(MCMUser*) user;

+(LPAddressEntity *)configureWithHybriss:(HYBAddress *) hybAddress;

+ (HYBAddress *)configureHybAddressFromLPAddress:(LPAddressEntity*) lpAddress;
+ (LPAddressEntity *)configureLPAddressFromReexAddress:(NSDictionary *)address;
//+ (void)autocompleteDidSelectPlace:(GMSPlace *)place;

@end

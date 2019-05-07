//
//  MCMAddressToDictionaryMapper.h
//  laposteCommon
//
//  Created by Hobart Wong on 26/02/2016.
//  Copyright © 2016 DigitasLBi. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HYBAddress;
@class MCMUser;

typedef NS_ENUM(NSUInteger, HybrisNewAddressFieldType) {
    Title = 0,
    Name,
    Lastname,
    UseMyLocation,
    Apartment,
    Building,
    Street,
    Locality,
    PostalCode,
    Town,
    Country
};

typedef NS_ENUM(NSUInteger, AlertStockFieldType) {
    LastNameAlertStock = 0,
    FirstNameAlertStock,
    EmailAlertStock
};


extern NSString *const hybris_address_dict_title_key;
extern NSString *const hybris_address_dict_first_name_key;
extern NSString *const hybris_address_dict_last_name_key;
extern NSString *const hybris_address_dict_apartment_key;
extern NSString *const hybris_address_dict_building_key;
extern NSString *const hybris_address_dict_street_key;
extern NSString *const hybris_address_dict_locality_key;
extern NSString *const hybris_address_dict_postal_code_key;
extern NSString *const hybris_address_dict_town_key;
extern NSString *const hybris_address_dict_country_key;

extern NSString *const HybrisNewAddressUserTitleFirstOptionCode;
extern NSString *const HybrisNewAddressUserTitleSecondOptionCode;

@interface MCMAddressToDictionaryMapper : NSObject

+ (NSString *) dictionaryKeyForFieldType:(HybrisNewAddressFieldType) type;
+(NSMutableDictionary*) mapHYBAddressToDictionaryForHybrisAPI:(HYBAddress*) address;
+(NSMutableDictionary*) mapHYBAddressBillingAddressPrefixToDictionaryForHybrisAPI:(HYBAddress *)address;
+(void) mapDictionary:(NSDictionary*) dict ToHYBAddress:(HYBAddress*) address;
+(HYBAddress*) mapDictionaryToNewAddress:(NSDictionary*) dict;
+(NSMutableDictionary*) addDefaultTitleToDictionary:(NSMutableDictionary*) dict;
+(MCMUser*) mapHYBAddressToUserAccount:(HYBAddress*) address;
+(HYBAddress*) mapUserAccountToHYBAddress:(MCMUser*) account includeName:(BOOL) includeName;
+(NSString*) addressStringFromMascadiaDict:(NSDictionary*) dictionary;
+(NSDictionary*) mapUserAccountToDictionaryForCreateEditModel:(MCMUser*) auxUserAccount;

@end

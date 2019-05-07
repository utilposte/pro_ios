//
//  MCMUserAccountToDictionaryMapper.h
//  laposteCommon
//
//  Created by Francesco Petrungaro on 11/04/2016.
//  Copyright © 2016 DigitasLBi. All rights reserved.
//

#import <Foundation/Foundation.h>


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


@class MCMUser;

typedef NS_ENUM(NSUInteger, AddressFieldType) {
    AddressFieldTypeTitle = 0,
    AddressFieldTypeName,
    AddressFieldTypeLastname,
    AddressFieldTypeApartment,
    AddressFieldTypeBuilding,
    AddressFieldTypeStreet,
    AddressFieldTypeLocality,
    AddressFieldTypePostalCode,
    AddressFieldTypeTown,
    AddressFieldTypeCountry
};


extern NSString *const address_dict_secondPart_key;

extern NSString *const AddressUserTitleFirstOptionCode;
extern NSString *const AddressUserTitleSecondOptionCode;

@interface MCMUserAccountToDictionaryMapper : NSObject

+ (NSString *) dictionaryKeyForFieldType:(AddressFieldType) type;
+(NSDictionary*) mapUserAccountToDictionary:(MCMUser*) auxUserAccount;
+(MCMUser*) mapDictionaryToUserAccount:(NSDictionary*) dict;
+(NSMutableDictionary*) addDefaultTitleToDictionary:(NSMutableDictionary*) dict;
+(NSDictionary*) mapUserAccountToDictionaryForCreateEditModel:(MCMUser*) auxUserAccount;

@end

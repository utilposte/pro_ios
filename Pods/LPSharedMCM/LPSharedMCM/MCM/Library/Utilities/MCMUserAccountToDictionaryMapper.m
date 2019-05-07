//
//  MCMUserAccountToDictionaryMapper.m
//  laposteCommon
//
//  Created by Francesco Petrungaro on 11/04/2016.
//  Copyright © 2016 DigitasLBi. All rights reserved.
//

#import "MCMUserAccountToDictionaryMapper.h"
#import "MCMUser.h"
#import "MCMLocationService.h"
#import "MCMDefine.h"

NSString *const address_dict_secondPart_key = @"line2";
NSString *const AddressUserTitleFirstOptionCode = @"mrs";
NSString *const AddressUserTitleSecondOptionCode = @"mr";

@implementation MCMUserAccountToDictionaryMapper

+ (NSString *) dictionaryKeyForFieldType:(AddressFieldType) type {
    NSString *result = nil;
    switch (type) {
        case AddressFieldTypeTitle:
            result = address_dict_title_key;
            break;
        case AddressFieldTypeName:
            result = address_dict_first_name_key;
            break;
        case AddressFieldTypeLastname:
            result = address_dict_last_name_key;
            break;
        case AddressFieldTypeApartment:
            result = address_dict_apartment_key;
            break;
        case AddressFieldTypeBuilding:
            result = address_dict_building_key;
            break;
        case AddressFieldTypeStreet:
            result = address_dict_street_key;
            break;
        case AddressFieldTypeLocality:
            result = address_dict_secondPart_key;
            break;
        case AddressFieldTypePostalCode:
            result = address_dict_postal_code_key;
            break;
        case AddressFieldTypeTown:
            result = address_dict_town_key;
            break;
        case AddressFieldTypeCountry:
            result = address_dict_country_key;
            break;
        default:
            break;
    }
    
    return result;
}

+(NSMutableDictionary*) addDefaultTitleToDictionary:(NSMutableDictionary*) dict {
    [dict setValue:AddressUserTitleSecondOptionCode
            forKey:[MCMUserAccountToDictionaryMapper dictionaryKeyForFieldType:AddressFieldTypeTitle]];
    return dict;
}

+(MCMUser*) mapDictionaryToUserAccount:(NSDictionary*) dict
{
    MCMUser* auxUserAccount = [MCMUser new];
    if([dict valueForKey:[MCMUserAccountToDictionaryMapper dictionaryKeyForFieldType:AddressFieldTypeTitle]]){
        auxUserAccount.title = [dict valueForKey:[MCMUserAccountToDictionaryMapper dictionaryKeyForFieldType:AddressFieldTypeTitle]];
    }
    if ([dict valueForKey:[MCMUserAccountToDictionaryMapper dictionaryKeyForFieldType:AddressFieldTypeName]]) {
        auxUserAccount.firstName = [dict valueForKey:[MCMUserAccountToDictionaryMapper dictionaryKeyForFieldType:AddressFieldTypeName]];
    }
    
    if ([dict valueForKey:[MCMUserAccountToDictionaryMapper dictionaryKeyForFieldType:AddressFieldTypeLastname]]) {
        auxUserAccount.lastName = [dict valueForKey:[MCMUserAccountToDictionaryMapper dictionaryKeyForFieldType:AddressFieldTypeLastname]];
    }
    
    if ([dict valueForKey:[MCMUserAccountToDictionaryMapper dictionaryKeyForFieldType:AddressFieldTypeApartment]]) {
        auxUserAccount.floor = [dict valueForKey:[MCMUserAccountToDictionaryMapper dictionaryKeyForFieldType:AddressFieldTypeApartment]];
    }
    
    if ([dict valueForKey:[MCMUserAccountToDictionaryMapper dictionaryKeyForFieldType:AddressFieldTypeBuilding]]) {
        auxUserAccount.building = [dict valueForKey:[MCMUserAccountToDictionaryMapper dictionaryKeyForFieldType:AddressFieldTypeBuilding]];
    }
    
    if ([dict valueForKey:[MCMUserAccountToDictionaryMapper dictionaryKeyForFieldType:AddressFieldTypeStreet]]) {
        auxUserAccount.street = [dict valueForKey:[MCMUserAccountToDictionaryMapper dictionaryKeyForFieldType:AddressFieldTypeStreet]];
    }
    
    if ([dict valueForKey:[MCMUserAccountToDictionaryMapper dictionaryKeyForFieldType:AddressFieldTypeLocality]]) {
        auxUserAccount.town = [dict valueForKey:[MCMUserAccountToDictionaryMapper dictionaryKeyForFieldType:AddressFieldTypeLocality]];
    }
    
    if ([dict valueForKey:[MCMUserAccountToDictionaryMapper dictionaryKeyForFieldType:AddressFieldTypeTown]]) {
        auxUserAccount.locality = [dict valueForKey:[MCMUserAccountToDictionaryMapper dictionaryKeyForFieldType:AddressFieldTypeTown]];
    }
    
    if([dict valueForKey:[MCMUserAccountToDictionaryMapper dictionaryKeyForFieldType:AddressFieldTypePostalCode]]) {
        auxUserAccount.postalCode = [dict valueForKey:[MCMUserAccountToDictionaryMapper dictionaryKeyForFieldType:AddressFieldTypePostalCode]];
    }
    
    if ([dict valueForKey:[MCMUserAccountToDictionaryMapper dictionaryKeyForFieldType:AddressFieldTypeCountry]]) {
        auxUserAccount.countryIsoCode = [dict valueForKey:[MCMUserAccountToDictionaryMapper dictionaryKeyForFieldType:AddressFieldTypeCountry]];
        auxUserAccount.countryName = [MCMLocationService countryNameFromISOCode:auxUserAccount.countryIsoCode];
    }
    
    return auxUserAccount;
}


+(NSDictionary*) mapUserAccountToDictionary:(MCMUser*) auxUserAccount
{
    NSMutableDictionary* newDict = [NSMutableDictionary new];
    
    [newDict setValue:auxUserAccount.title.lowercaseString
               forKey:[MCMUserAccountToDictionaryMapper dictionaryKeyForFieldType:AddressFieldTypeTitle]];
    
    if (auxUserAccount.firstName.length > 0) {
        [newDict setValue:auxUserAccount.firstName
                   forKey:[MCMUserAccountToDictionaryMapper dictionaryKeyForFieldType:AddressFieldTypeName]];
    }
    
    if (auxUserAccount.lastName.length > 0) {
        [newDict setValue:auxUserAccount.lastName
                   forKey:[MCMUserAccountToDictionaryMapper dictionaryKeyForFieldType:AddressFieldTypeLastname]];
    }
    
    NSString *line1Composite = @"";
    
    if (auxUserAccount.street.length > 0) {
        line1Composite = [line1Composite stringByAppendingString:auxUserAccount.street];
    }
    
    if (auxUserAccount.town.length > 0) {
        line1Composite = [line1Composite stringByAppendingFormat:@" %@", auxUserAccount.town];
    }
    
    NSString *line2Composite = @"";
    
    if (auxUserAccount.floor.length > 0) {
        line2Composite = [line2Composite stringByAppendingString:auxUserAccount.floor];
    }
    
    if (auxUserAccount.building.length > 0) {
        line2Composite = [line2Composite stringByAppendingFormat:@" %@", auxUserAccount.building];
    }
    
    [newDict setValue:line1Composite
               forKey:address_dict_street_key];
    
    [newDict setValue:line2Composite
               forKey:address_dict_secondPart_key];
      
    if (auxUserAccount.locality.length > 0) {
        [newDict setValue:auxUserAccount.locality
                   forKey:[MCMUserAccountToDictionaryMapper dictionaryKeyForFieldType:AddressFieldTypeTown]];
    }
    
    if (auxUserAccount.postalCode.length > 0) {
        [newDict setValue:auxUserAccount.postalCode
                   forKey:[MCMUserAccountToDictionaryMapper dictionaryKeyForFieldType:AddressFieldTypePostalCode]];
    }
    
    if (auxUserAccount.countryIsoCode.length > 0) {
        [newDict setValue:auxUserAccount.countryIsoCode.lowercaseString
                   forKey:[MCMUserAccountToDictionaryMapper dictionaryKeyForFieldType:AddressFieldTypeCountry]];
    }
    
    return [newDict copy];
}

+(NSDictionary*) mapUserAccountToDictionaryForCreateEditModel:(MCMUser*) auxUserAccount
{
    NSMutableDictionary* newDict = [NSMutableDictionary new];
    
    [newDict setValue:auxUserAccount.title.lowercaseString
               forKey:[MCMUserAccountToDictionaryMapper dictionaryKeyForFieldType:AddressFieldTypeTitle]];
    
    if (auxUserAccount.firstName.length > 0) {
        [newDict setValue:auxUserAccount.firstName
                   forKey:[MCMUserAccountToDictionaryMapper dictionaryKeyForFieldType:AddressFieldTypeName]];
    }
    
    if (auxUserAccount.lastName.length > 0) {
        [newDict setValue:auxUserAccount.lastName
                   forKey:[MCMUserAccountToDictionaryMapper dictionaryKeyForFieldType:AddressFieldTypeLastname]];
    }

    if (auxUserAccount.street.length > 0) {
        [newDict setValue:auxUserAccount.street
                   forKey:[MCMUserAccountToDictionaryMapper dictionaryKeyForFieldType:AddressFieldTypeStreet]];
    }
    
    if (auxUserAccount.floor.length > 0) {
        [newDict setValue:auxUserAccount.floor
                   forKey:address_dict_apartment_key];
    }
    
    if (auxUserAccount.building.length > 0) {
        [newDict setValue:auxUserAccount.building
                   forKey:address_dict_building_key];
    }
    
    if (auxUserAccount.town.length > 0) {
        [newDict setValue:auxUserAccount.town
                   forKey:address_dict_secondPart_key];
    }
    
    if (auxUserAccount.locality.length > 0) {
        [newDict setValue:auxUserAccount.locality
                   forKey:[MCMUserAccountToDictionaryMapper dictionaryKeyForFieldType:AddressFieldTypeTown]];
    }
    
    if (auxUserAccount.postalCode.length > 0) {
        [newDict setValue:auxUserAccount.postalCode
                   forKey:[MCMUserAccountToDictionaryMapper dictionaryKeyForFieldType:AddressFieldTypePostalCode]];
    }
    
    if (auxUserAccount.countryIsoCode.length > 0) {
        [newDict setValue:auxUserAccount.countryIsoCode.lowercaseString
                   forKey:[MCMUserAccountToDictionaryMapper dictionaryKeyForFieldType:AddressFieldTypeCountry]];
    }
    
    return [newDict copy];
}


@end

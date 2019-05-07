//
//  MCMAddressToDictionaryMapper.m
//  laposteCommon
//
//  Created by Hobart Wong on 26/02/2016.
//  Copyright © 2016 DigitasLBi. All rights reserved.
//

#import "MCMAddressToDictionaryMapper.h"

#import "MCMUserAccountToDictionaryMapper.h"

#import "HYBAddress.h"
#import "HYBCountry.h"
#import "MCMUser.h"
#import "MCMLocationService.h"
#import "NSString+MCMCustom.h"
#import "HYBAddress+Custom.h"
#import "MCMDefine.h"

NSString *const hybris_address_dict_title_key = @"titleCode";
NSString *const hybris_address_dict_first_name_key = @"firstName";
NSString *const hybris_address_dict_last_name_key = @"lastName";
NSString *const hybris_address_dict_apartment_key = @"apartment";
NSString *const hybris_address_dict_building_key = @"building";
NSString *const hybris_address_dict_street_key = @"line1";
NSString *const hybris_address_dict_locality_key = @"line2";
NSString *const hybris_address_dict_postal_code_key = @"postalCode";
NSString *const hybris_address_dict_town_key = @"town";
NSString *const hybris_address_dict_country_key = @"country.isocode";

NSString *const HybrisNewAddressUserTitleFirstOptionCode = @"mrs";
NSString *const HybrisNewAddressUserTitleSecondOptionCode = @"mr";

@implementation MCMAddressToDictionaryMapper

+ (NSString *) dictionaryKeyForFieldType:(HybrisNewAddressFieldType) type {
    NSString *result = nil;
    switch (type) {
        case Title:
            result = hybris_address_dict_title_key;
            break;
        case Name:
            result = hybris_address_dict_first_name_key;
            break;
        case Lastname:
            result = hybris_address_dict_last_name_key;
            break;
        case Apartment:
            result = hybris_address_dict_apartment_key;
            break;
        case Building:
            result = hybris_address_dict_building_key;
            break;
        case Street:
            result = hybris_address_dict_street_key;
            break;
        case Locality:
            result = hybris_address_dict_locality_key;
            break;
        case PostalCode:
            result = hybris_address_dict_postal_code_key;
            break;
        case Town:
            result = hybris_address_dict_town_key;
            break;
        case Country:
            result = hybris_address_dict_country_key;
            break;
        default:
            break;
    }
    
    return result;
}

+(NSMutableDictionary*) addDefaultTitleToDictionary:(NSMutableDictionary*) dict {
    [dict setValue:HybrisNewAddressUserTitleSecondOptionCode
            forKey:[MCMAddressToDictionaryMapper dictionaryKeyForFieldType:Title]];
    return dict;
}

+(MCMUser*) mapHYBAddressToUserAccount:(HYBAddress*) address
{
    MCMUser* auxUserAccount = [MCMUser new];
    
    auxUserAccount.title = address.titleCode ? address.titleCode : HybrisNewAddressUserTitleSecondOptionCode;
    if (address.firstName.length) {
        auxUserAccount.firstName = address.firstName;
    }
    
    if (address.lastName.length) {
        auxUserAccount.lastName = address.lastName;
    }
    
    if (address.line1.length) {
        auxUserAccount.street = address.line1;
    }
    
    if(address.apartment.length) {
        auxUserAccount.building = address.apartment;
    }
    
    if(address.building.length) {
        auxUserAccount.building = address.building;
    }
    
    if(address.line2.length) {
        auxUserAccount.floor = address.line2;
    }
    
    if (address.town.length) {
        auxUserAccount.town = address.town;
    }
    
    if (address.postalCode.length) {
        auxUserAccount.postalCode = address.postalCode;
    }
    
    if (address.country.isocode.length) {
        auxUserAccount.countryIsoCode = address.country.isocode;
        auxUserAccount.countryName = [MCMLocationService countryNameFromISOCode:address.country.isocode];
    }
    
    return auxUserAccount;
}


+(HYBAddress*) mapUserAccountToHYBAddress:(MCMUser*) account includeName:(BOOL) includeName
{
    HYBAddress* newAddress = [HYBAddress new];
    
    if(includeName) {
        newAddress.title = [account.title copy];
        newAddress.firstName = [account.firstName copy];
        newAddress.lastName = [account.lastName copy];
    }
    
    if (account.floor.hasContent) {
        newAddress.apartment = [account.floor copy];
    }
    if (account.building.hasContent) {
        newAddress.building = [account.building copy];
    }
    if (account.street.hasContent) {
        newAddress.line1 = [account.street copy];
    }
    if (account.town.hasContent) {
        newAddress.line2 = [account.town copy];
    }
    
    newAddress.town = [account.locality copy];
    newAddress.postalCode = [account.postalCode copy];
    
    if (account.countryName.hasContent) {
        newAddress.country = [HYBCountry new];
        newAddress.country.isocode = [MCMLocationService isoCountryCodeFromName: account.countryName];
        newAddress.country.name = [account.countryName copy];
    } else if (account.countryIsoCode.hasContent) {
        newAddress.country = [HYBCountry new];
        newAddress.country.isocode = account.countryIsoCode;
        newAddress.country.name = [MCMLocationService countryNameFromISOCode:account.countryIsoCode];
    }
    
    newAddress.country.isocode = [newAddress.country.isocode lowercaseString];
    
    return newAddress;
}

+(NSMutableDictionary*) mapHYBAddressBillingAddressPrefixToDictionaryForHybrisAPI:(HYBAddress *)address {
    NSString *prefix = @"billingAddress.";
    return [self mapHYBAddressToDictionaryForHybrisAPI:address withPrefix:prefix];
}

+(NSMutableDictionary*) mapHYBAddressToDictionaryForHybrisAPI:(HYBAddress*) address withPrefix:(NSString*) prefix {
    NSMutableDictionary* newDict = [NSMutableDictionary new];
    
    NSString *key = [self prefixString:[MCMAddressToDictionaryMapper dictionaryKeyForFieldType:Title] WithPrefix:prefix];
    
    [newDict setValue:address.titleCode?address.titleCode:HybrisNewAddressUserTitleSecondOptionCode
               forKey:key];
    
    key = [self prefixString:[MCMAddressToDictionaryMapper dictionaryKeyForFieldType:Name] WithPrefix:prefix];
    if (address.firstName.length) {
        [newDict setValue:address.firstName
                   forKey:key];
    }
    
    key = [self prefixString:[MCMAddressToDictionaryMapper dictionaryKeyForFieldType:Lastname] WithPrefix:prefix];
    if (address.lastName.length) {
        [newDict setValue:address.lastName
                   forKey:key];
    }
    
    key = [self prefixString:[MCMAddressToDictionaryMapper dictionaryKeyForFieldType:Street] WithPrefix:prefix];
    NSMutableString* line1String = [NSMutableString string];
    if (address.line1.length) {
        [line1String appendFormat:@"%@", address.line1];
    }
    
    [newDict setValue:line1String
               forKey:key];
    
    key = [self prefixString:[MCMAddressToDictionaryMapper dictionaryKeyForFieldType:Locality] WithPrefix:prefix];
    NSMutableString* line2String = [NSMutableString string];
    if (address.line2.length) {
        [line2String appendFormat:@"%@ ", address.line2];
    }
    
    if(line2String.length > 0) {
        [newDict setValue:line2String
                   forKey:key];
    }

    
    
    key = [self prefixString:[MCMAddressToDictionaryMapper dictionaryKeyForFieldType:Town] WithPrefix:prefix];
    if (address.town.length) {
        [newDict setValue:address.town
                   forKey:key];
    }
    
    //NO PREFIX needed for postal code
    key = [self prefixString:[MCMAddressToDictionaryMapper dictionaryKeyForFieldType:PostalCode] WithPrefix:prefix];
    if (address.postalCode.length) {
        [newDict setValue:address.postalCode
                   forKey:key];
    }
    
    key = [self prefixString:[MCMAddressToDictionaryMapper dictionaryKeyForFieldType:Country] WithPrefix:prefix];
    if (address.country.isocode.length) {
        [newDict setValue:address.country.isocode
                   forKey:key];
    }
    
    key = [self prefixString:@"companyName" WithPrefix:prefix];
    if (address.companyName.length) {
        [newDict setValue:address.companyName
                   forKey:key];
    }
    
    return newDict;
}

+(NSString*) prefixString:(NSString*) string WithPrefix:(NSString*) prefix {
    if(prefix) {
        return [NSString stringWithFormat:@"%@%@", prefix, string];
    } else {
        return string;
    }
}


+(NSMutableDictionary*) mapHYBAddressToDictionaryForHybrisAPI:(HYBAddress*) address
{
    return [self mapHYBAddressToDictionaryForHybrisAPI:address withPrefix:nil];
}

+(void) mapDictionary:(NSDictionary*) dict ToHYBAddress:(HYBAddress*) address
{
    address.formattedAddress = @"";
    
    if([dict valueForKey:[MCMAddressToDictionaryMapper dictionaryKeyForFieldType:Title]]) {
        address.titleCode = [dict valueForKey:[MCMAddressToDictionaryMapper dictionaryKeyForFieldType:Title]];
    }
    
    if([dict valueForKey:[MCMAddressToDictionaryMapper dictionaryKeyForFieldType:Name]]) {
        address.firstName = [dict valueForKey:[MCMAddressToDictionaryMapper dictionaryKeyForFieldType:Name]];
    }
    
    if([dict valueForKey:[MCMAddressToDictionaryMapper dictionaryKeyForFieldType:Lastname]]) {
        address.lastName = [dict valueForKey:[MCMAddressToDictionaryMapper dictionaryKeyForFieldType:Lastname]];
    }
    
   
    
    if([dict valueForKey:[MCMAddressToDictionaryMapper dictionaryKeyForFieldType:Apartment]]) {
        address.apartment = [dict valueForKey:[MCMAddressToDictionaryMapper dictionaryKeyForFieldType:Apartment]];
       
    }
    if (address.apartment) {
        address.formattedAddress = [NSString stringWithFormat:@"%@ ", address.apartment];
    }
    
    if([dict valueForKey:[MCMAddressToDictionaryMapper dictionaryKeyForFieldType:Building]]) {
        address.building = [dict valueForKey:[MCMAddressToDictionaryMapper dictionaryKeyForFieldType:Building]];
    }
    
    if (address.building) {
        address.formattedAddress = [NSString stringWithFormat:@"%@%@\n",address.formattedAddress, address.building];
    }
    
    if([dict valueForKey:[MCMAddressToDictionaryMapper dictionaryKeyForFieldType:Street]]) {
        address.line1 = [dict valueForKey:[MCMAddressToDictionaryMapper dictionaryKeyForFieldType:Street]];
    }
    
    if (address.line1) {
        address.formattedAddress = [NSString stringWithFormat:@"%@%@",address.formattedAddress, address.line1];
    }
    
    if([dict valueForKey:hybris_address_dict_locality_key]) {
        address.line2 = [dict valueForKey:hybris_address_dict_locality_key];
    }
    
//    if (address.line2) {
//        address.formattedAddress = [NSString stringWithFormat:@"%@ %@",address.formattedAddress, address.line2];
//    }
    
    if([dict valueForKey:[MCMAddressToDictionaryMapper dictionaryKeyForFieldType:Town]]) {
        address.town = [dict valueForKey:[MCMAddressToDictionaryMapper dictionaryKeyForFieldType:Town]];
    }
    
    if (address.town) {
        address.formattedAddress = [NSString stringWithFormat:@"%@\n%@",address.formattedAddress, address.town];
    }
    
    if([dict valueForKey:[MCMAddressToDictionaryMapper dictionaryKeyForFieldType:PostalCode]]) {
        address.postalCode = [dict valueForKey:[MCMAddressToDictionaryMapper dictionaryKeyForFieldType:PostalCode]];
    }
    
    if (address.postalCode) {
        address.formattedAddress = [NSString stringWithFormat:@"%@ %@",address.formattedAddress, address.postalCode];
    }
    
    if([dict valueForKey:[MCMAddressToDictionaryMapper dictionaryKeyForFieldType:Country]]) {
        address.country.isocode = [dict valueForKey:[MCMAddressToDictionaryMapper dictionaryKeyForFieldType:Country]];
    }
    
}

+(NSString*) addressStringFromMascadiaDict:(NSDictionary*) data {
    NSMutableString* addressString = [NSMutableString new];
    
    NSString* titleString = [[NSString stringWithFormat:@"%@ %@ %@", data[kJsonValue_Ligne2][kJsonValue_Value], data[kJsonValue_Ligne3][kJsonValue_Value], data[kJsonValue_Ligne4][kJsonValue_Value]] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString* addressSubString = [[NSString stringWithFormat:@"%@ %@", data[kJsonValue_Ligne5][kJsonValue_Value], data[kJsonValue_Ligne6][kJsonValue_Value]] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *postalLocalite = [data[kJsonValue_Ligne7][kJsonValue_Value] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (titleString.hasContent) {
        [addressString appendString:titleString];
        [addressString appendString:@"\n"];
    }
    if (addressSubString.hasContent) {
        [addressString appendString:addressSubString];
        [addressString appendString:@"\n"];
    }
    if (postalLocalite.hasContent) {
        [addressString appendString:postalLocalite];
        [addressString appendString:@"\n"];
    }
    return [NSString stringWithString:addressString];
}

+(HYBAddress*) mapDictionaryToNewAddress:(NSDictionary*) dict {
    HYBAddress* newAddress = [HYBAddress new];
    newAddress.country = [HYBCountry new];
    [self mapDictionary:dict ToHYBAddress:newAddress];
    return newAddress;
}



@end

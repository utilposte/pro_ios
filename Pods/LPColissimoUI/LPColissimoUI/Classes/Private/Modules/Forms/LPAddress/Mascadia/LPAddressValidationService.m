//
//  LPAddressValidationService.m
//  RefonteFormulaire
//
//  Created by Sofien Azzouz on 18/01/2018.
//  Copyright © 2018 Sofien Azzouz. All rights reserved.
//

#import "LPAddressValidationService.h"

static NSInteger mascadiaErrorValue = -1;

@implementation LPAddressValidationService




+ (void)validateAddress:(NSDictionary*) address withCompletion:(void (^)(NSArray *addressesArray, MascadiaValidationResult *validationResult,  NSError* error)) completion{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSDictionary* params = [self paramsDictionaryForValidationRequest:address];
    
    NSMutableURLRequest* request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:[NSString stringWithFormat:@"%@/services/mascadia/controleAdresse", @"https://www.serca.laposte.fr"] parameters:params error:nil];
    [[MCMLoadingManager sharedInstance] showLoading];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        [[MCMLoadingManager sharedInstance] hideLoading];
        MascadiaValidationResult *statusResult;
        NSArray *addressesArray = nil;
        if (!error) {
            addressesArray = [self processMascadiaResponse:responseObject];
            statusResult = [self mascadiaResponseStatusFromDictionary:responseObject];
        }
        if (completion) {
            completion(addressesArray, statusResult, error);
        }
    }];
    [dataTask resume];
}

+ (NSArray *)processMascadiaSearchResults:(NSDictionary *)responseObject {
    NSDictionary *retourDic = responseObject[@"reponse"];
    NSArray *addressArrayResponse = retourDic[kJsonValue_Adresse];
    return addressArrayResponse;
}

+ (NSArray *)processMascadiaResponse:(NSDictionary *)responseObject {
    
    NSMutableArray *addressArray = [self processMascadiaResponseWithParams:responseObject andFiltering:YES];
    
    return addressArray;
}

+(NSDictionary*) paramsDictionaryForSearchRequest:(NSString*) searchText {
    NSMutableDictionary* newDict = [NSMutableDictionary dictionary];
    newDict[@"idClient"] = @"LPFR";
    newDict[@"passwdClient"] = @"4SJDaSQv1n";
    newDict[@"typeResultat"] = @"json";
    newDict[@"nbItems"] = @"15";
    newDict[@"chaineRecherche"] = searchText;
    
    return newDict;
}

+(NSDictionary*) paramsDictionaryForValidationRequest:(NSDictionary*) dict {
    NSMutableDictionary* newDict = [NSMutableDictionary dictionary];
    newDict[@"idClient"] = @"LPFR";
    newDict[@"passwdClient"] = @"4SJDaSQv1n";
    newDict[@"typeResultat"] = @"json";
    
    [newDict addEntriesFromDictionary:[self mapAddressFieldsToParamFields:dict]];
    
    return newDict;
}

+(MascadiaValidationResult *)mascadiaResponseStatusFromDictionary:(NSDictionary *)responseDictionary {
    NSDictionary *retourDic = responseDictionary[kJsonValue_Retour];
    NSDictionary *addressValidationDic = retourDic[kJsonValue_CodesEtMessages];
    
    MascadiaValidationResult *statusResult = [MascadiaValidationResult new];
    
    
    NSInteger generalFeu = [(addressValidationDic[kJsonValue_General])[kJsonValue_Feu] integerValue];
    statusResult.ligne4Feu = [(addressValidationDic[kJsonValue_Ligne4])[kJsonValue_Feu] integerValue];
    statusResult.ligne6Feu = [(addressValidationDic[kJsonValue_Ligne6])[kJsonValue_Feu] integerValue];
    NSInteger lengthArrayAddress = [(NSDictionary *)(retourDic[kJsonValue_BlocAdresse])[kJsonValue_Adresse] count];
    
    if (generalFeu == 0 && statusResult.ligne4Feu != -4 && statusResult.ligne6Feu != -4) {
        // Perfect address. Send data to server
        statusResult.generalStatus = MascadiaResponseStatusCorrectAddress;
    } else if (lengthArrayAddress > 0) {
        // Show List of addresses suggested
        statusResult.generalStatus = MascadiaResponseStatusWrongAddressWithOptions;
    }else {
        // Show screen accept / Modify without options
        statusResult.generalStatus = MascadiaResponseStatusWrongAddressNoOptions;
    }
    
    return statusResult;
}

+(NSArray *)processMascadiaResponseWithParams:(NSDictionary *)responseObject andFiltering:(bool)doFiltering {
    
    NSDictionary *retourDic = responseObject[kJsonValue_Retour];
    NSArray *addressArrayResponse = (retourDic[kJsonValue_BlocAdresse])[kJsonValue_Adresse];
    
    NSMutableArray *addressArray = [NSMutableArray array];
    
    for (NSDictionary *addressDic in addressArrayResponse) {
        if([(addressDic[kJsonValue_Ligne4])[kJsonValue_Verifie] isEqualToString:@"oui"] && [(addressDic[kJsonValue_Ligne6])[kJsonValue_Verifie] isEqualToString:@"oui"])
            [addressArray addObject:addressDic];
    }
    if(doFiltering)
        return addressArray;
    else
        return addressArrayResponse;
}

+(NSDictionary *) mapAddressFieldsToParamFields:(NSDictionary*) paramsDict {
    // HW - NOTE TO Franco - THIS MAPPING IS NOT COMPLETE AS IT'S NOT CLEAR TO ME WHAT IT SHOULD BE. ERNESTO MIGHT KNOW BUT I THINK HE WASN'T SURE EITHER.
    NSMutableDictionary* newDict = [NSMutableDictionary dictionary];
    
    if (paramsDict[hybris_address_dict_apartment_key]) {
        newDict[kCCU_Param_Ligne2] = paramsDict[hybris_address_dict_apartment_key];
    }
    if (paramsDict[hybris_address_dict_building_key]) {
        newDict[kCCU_Param_Ligne3] = paramsDict[hybris_address_dict_building_key];
    }
    if (paramsDict[hybris_address_dict_street_key]) {
        newDict[kCCU_Param_Ligne4] = paramsDict[hybris_address_dict_street_key];
    }
    if (paramsDict[hybris_address_dict_locality_key]) {
        newDict[kCCU_Param_Ligne5] = paramsDict[hybris_address_dict_locality_key];
    }
    if (paramsDict[hybris_address_dict_town_key] && paramsDict[hybris_address_dict_postal_code_key]) {
        newDict[kCCU_Param_Ligne6] =  [NSString stringWithFormat:@"%@ %@", paramsDict[hybris_address_dict_postal_code_key], paramsDict[hybris_address_dict_town_key]];
    }
    //Needs to be the fixed country name as the user shouldn't choose another one.
    newDict[kCCU_Param_Ligne7] = @"France";
    
    return [self removeSpecialCharactersFromAddressComponents:newDict];
}

+ (NSDictionary *)removeSpecialCharactersFromAddressComponents:(NSDictionary *) components {
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:components];
    for (NSString *key in components) {
        NSString *newValue = [components[key] stringByReplacingOccurrencesOfString:@"-" withString:@" "];
        newValue = [newValue stringByReplacingOccurrencesOfString:@"/" withString:@""];
        [result setObject:newValue forKey:key];
    }
    return result;
}

+ (BOOL)mascadiaResultHasError:(MascadiaValidationResult*) result {
    if (result) {
        if (result.generalStatus == MascadiaResponseStatusCorrectAddress) {
            return false;
        } else if (result.ligne4Feu == mascadiaErrorValue || result.ligne6Feu == mascadiaErrorValue) {
            return true;
        } else {
            return true;
        }
    } else {
        return false;
    }
}

+ (MCMUser *)createMCMUserFromMascadiaAddress:(NSDictionary *)mascadiaDictionary lpAddress:(LPAddressEntity *)lpAddress {

    MCMUser *infoUserAccount = [MCMUser new];

    /* handle localite when have space in string*/
    NSString *locality = [mascadiaDictionary[kJsonValue_Ligne6][kJsonValue_Value] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSArray *localityArray = [locality componentsSeparatedByString:@" "];
    if (localityArray.count > 1) {
        locality = localityArray[1];
        for (int i = 0; i < localityArray.count; i++) {
            if (i > 1)
            {
                locality = [NSString stringWithFormat:@"%@ %@",locality ,localityArray[i]];
            }
        }
    }
    /*----------------------------------------*/

    /*add numero and libelleVoie in ligne4*/

    NSString *ligne4Value = [[NSString stringWithFormat:@"%@",mascadiaDictionary[kJsonValue_Ligne4][kJsonValue_Value]] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    /*------------------------------------*/

    NSString *postalCode = mascadiaDictionary[kJsonValue_Ligne6][kJsonValue_Value];
    postalCode = [postalCode stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSArray *postalArray = [postalCode componentsSeparatedByString:@" "];
    if (postalArray.count > 1)
    {
        postalCode = postalArray[0];
    }
    /*---------------End--------------- */
    infoUserAccount.title = lpAddress.civility;
    infoUserAccount.firstName = lpAddress.firstName;
    infoUserAccount.lastName = lpAddress.lastName;
    infoUserAccount.building = mascadiaDictionary[kJsonValue_Ligne2][kJsonValue_Value];
    infoUserAccount.floor = mascadiaDictionary[kJsonValue_Ligne3][kJsonValue_Value];
    infoUserAccount.street = ligne4Value;
    infoUserAccount.town = mascadiaDictionary[kJsonValue_Ligne5][kJsonValue_Value];
    infoUserAccount.postalCode = postalCode;
    infoUserAccount.locality =  locality;
    infoUserAccount.countryName = [MCMLocationService countryNameFromISOCode:(mascadiaDictionary[kJsonValue_Ligne7])[kJsonValue_CodeISO]];
    infoUserAccount.countryIsoCode = (mascadiaDictionary[kJsonValue_Ligne7])[kJsonValue_CodeISO];

    return infoUserAccount;
}

+ (LPAddressEntity *)configureLPAddressFromUserAccount:(MCMUser*) user {
    LPAddressEntity *lpAddress = [[LPAddressEntity alloc] init];
    
    if (user.title) {
        lpAddress.civility = user.title;
    }
    if (user.firstName) {
        lpAddress.firstName = user.firstName;
    }
    if (user.lastName) {
        lpAddress.lastName = user.lastName;
    }
    if (user.floor) {
        lpAddress.complementaryAddress = user.floor;
    }
    if (user.building) {
        lpAddress.complementaryAddress = [NSString stringWithFormat:@"%@ %@", lpAddress.complementaryAddress, user.building];
    }

    if (user.street) {
        lpAddress.street = user.street;

    }
    if (user.town) {
        lpAddress.locality = user.town;
    }
    if (user.locality) {
        lpAddress.locality = user.locality;
    }
    if (user.postalCode) {
        lpAddress.postalCode = user.postalCode;
    }
    if (user.countryName) {
        lpAddress.countryName = user.countryName;
        lpAddress.countryIsoCode = user.countryIsoCode;
    }
    if(user.phoneNumber){
        lpAddress.phone = user.phoneNumber;
    }
    return lpAddress;
}

+(LPAddressEntity *)configureWithHybriss:(HYBAddress *) hybAddress{
   
        LPAddressEntity *lpAddress = [[LPAddressEntity alloc] init];
        lpAddress.civility = hybAddress.titleCode;
        lpAddress.firstName = hybAddress.firstName;
        lpAddress.lastName = hybAddress.lastName;
        lpAddress.street =  hybAddress.line1;
        lpAddress.complementaryAddress = hybAddress.line2;
        lpAddress.locality  = hybAddress.town;
        lpAddress.postalCode = hybAddress.postalCode;
        if ( hybAddress.country) {
           lpAddress.countryName =  hybAddress.country.name;
            lpAddress.countryIsoCode = hybAddress.country.isocode;
        }
    return lpAddress;
}


+ (HYBAddress *)configureHybAddressFromLPAddress:(LPAddressEntity*) lpAddress {
    HYBAddress* hybAddress = [HYBAddress new];
    hybAddress.titleCode = lpAddress.civility;
    hybAddress.firstName = lpAddress.firstName;
    hybAddress.lastName = lpAddress.lastName;
    hybAddress.line1 = lpAddress.street;
    hybAddress.line2 = lpAddress.complementaryAddress;
    hybAddress.town = lpAddress.locality;
    hybAddress.postalCode = lpAddress.postalCode;
    if (lpAddress.countryName) {
        hybAddress.country = [HYBCountry new];
        hybAddress.country.name = lpAddress.countryName;
        hybAddress.country.isocode = lpAddress.countryIsoCode.lowercaseString;
    }
    return hybAddress;
}

+ (LPAddressEntity *)configureLPAddressFromReexAddress:(NSDictionary *)address {
    LPAddressEntity *lpAddress = [[LPAddressEntity alloc] init];
    lpAddress.street = [address objectForKey:REXAddress_Ligne4_Key];
    lpAddress.complementaryAddress = [address objectForKey:REXAddress_Ligne5_Key];
    lpAddress.locality = [address objectForKey:REXAddress_Ligne6_Localite_Key];
    lpAddress.postalCode = [address objectForKey:REXAddress_Ligne6_CP_Key];
    NSMutableDictionary *country = [address objectForKey:REXAddress_Country_Key];
    lpAddress.countryIsoCode = [[country objectForKey:REXAddress_Country_Isocode_Key] lowercaseString];
    lpAddress.countryName = [country objectForKey:REXAddress_Country_Name_Key];
    return lpAddress;
}

//+ (void)autocompleteDidSelectPlace:(GMSPlace *)place {
//    NSMutableAttributedString *text =
//    [[NSMutableAttributedString alloc] initWithString:[place description]];
//    if (place.attributions) {
//        [text appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n\n"]];
//        [text appendAttributedString:place.attributions];
//    }
//    NSAttributedString *string = text;
////    _textView.attributedText = text;
//}


@end

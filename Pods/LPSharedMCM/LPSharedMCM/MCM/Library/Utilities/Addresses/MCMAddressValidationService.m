//
//  MCMAddressValidationService.m
//  laposteCommon
//
//  Created by Hobart Wong on 05/04/2016.
//  Copyright © 2016 DigitasLBi. All rights reserved.
//

#import "MCMAddressValidationService.h"
#import "AFNetworking.h"
#import "MCMAddressToDictionaryMapper.h"
#import "HYBAddress.h"
#import "HYBCountry.h"
#import "MCMLocationService.h"
#import "MCMAddressValidationService+Utils.h"
#import "MCMLoadingManager.h"
#import "MCMManager.h"
#import "MCMDefine.h"

@implementation MCMAddressValidationService

+(void) validateAddress:(NSDictionary*) address withCompletion:(void (^)(NSArray *addressesArray, MascadiaValidationResult *validationResult,  NSError* error)) completion{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSDictionary* params = [self paramsDictionaryForValidationRequest:address];
     NSString *mascadiaServiceHost = [[MCMManager sharedInstance].delegate getSercadiaServiceHost];
    NSMutableURLRequest* request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:[NSString stringWithFormat:@"%@/services/mascadia/controleAdresse", mascadiaServiceHost] parameters:params error:nil];
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

+(NSDictionary*) paramsDictionaryForValidationRequest:(NSDictionary*) dict {
    NSMutableDictionary* newDict = [NSMutableDictionary dictionary];
    newDict[@"idClient"] = @"LPFR";
    newDict[@"passwdClient"] = @"4SJDaSQv1n";
    newDict[@"typeResultat"] = @"json";
    
    [newDict addEntriesFromDictionary:[self mapAddressFieldsToParamFields:dict]];
    
    return newDict;
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
    
    return [MCMAddressValidationService removeSpecialCharactersFromAddressComponents:newDict];
}

+(MascadiaValidationResult *)mascadiaResponseStatusFromDictionary:(NSDictionary *)responseDictionary {
    NSDictionary *retourDic = responseDictionary[kJsonValue_Retour];
    NSDictionary *addressValidationDic = retourDic[kJsonValue_CodesEtMessages];
    
    MascadiaValidationResult *statusResult = [MascadiaValidationResult new];
    
    
    NSInteger generalFeu = [(addressValidationDic[kJsonValue_General])[kJsonValue_Feu] integerValue];
//    statusResult.ligne4Feu = [(addressValidationDic[kJsonValue_Ligne4])[kJsonValue_Feu] integerValue];
    if ([self isAddressContainingCEDEX:retourDic]) {
        statusResult.ligne4Feu = 0;
    } else {
        statusResult.ligne4Feu = [(addressValidationDic[kJsonValue_Ligne4])[kJsonValue_Feu] integerValue];
    }
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

+(NSArray *)processMascadiaResponse:(NSDictionary *)responseObject {
    
    NSMutableArray *addressArray = [self processMascadiaResponseWithParams:responseObject andFiltering:YES];
    
    return addressArray;
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


+ (void)searchZipCode:(NSString*) code withCompletion:(void (^)(NSArray *addressesArray, MascadiaValidationResult *validationResult,  NSError* error)) completion{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    params[@"idClient"] = @"LPFR";
    params[@"passwdClient"] = @"4SJDaSQv1n";
    params[@"typeResultat"] = @"json";
    params[kCCU_Param_Ligne6] = code;
    params[kCCU_Param_Ligne7] = @"France";
    
    NSString *mascadiaServiceHost = [[MCMManager sharedInstance].delegate getSercadiaServiceHost];
    NSMutableURLRequest* request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:[NSString stringWithFormat:@"%@/services/mascadia/controleAdresse", mascadiaServiceHost] parameters:params error:nil];
    [[MCMLoadingManager sharedInstance] showLoading];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        [[MCMLoadingManager sharedInstance] hideLoading];
        MascadiaValidationResult *statusResult;
        NSArray *addressesArray = nil;
        if (!error) {
            addressesArray = [MCMAddressValidationService processMascadiaResponseWithParams:responseObject andFiltering:NO];
            statusResult = [MCMAddressValidationService mascadiaResponseStatusFromDictionary:responseObject];
        }
        if (completion) {
            completion(addressesArray, statusResult, error);
        }
    }];
    [dataTask resume];
}

+ (BOOL)isAddressContainingCEDEX:(NSDictionary *)resultDictionary {
    NSArray *addressArray = resultDictionary[@"blocAdresse"][@"adresse"];
    NSDictionary *addressDictionary = addressArray.firstObject;
    NSString *streetString = addressDictionary[@"ligne6"][@"value"];
    if ([streetString containsString:@"CEDEX"]) {
        return YES;
    }
    return NO;
}


@end

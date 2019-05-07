//
//  REXUtils.m
//  laposte
//
//  Created by Mohamed Helmi Ben Jabeur on 08/09/2017.
//  Copyright © 2017 laposte. All rights reserved.
//

#import "REXUtils.h"
#import "REXConstant.h"
#import "REXInfoToSend.h"
#import "MCMDefine.h"
#import "REXTrackingConstants.h"
#import "MCMManager.h"
#import "MCMUser.h"


@interface REXUtils()

+ (NSDictionary *) removeSpecialCharactersFromAddressComponents:(NSDictionary *) components;

@end

@implementation REXUtils

+ (NSDictionary *) removeSpecialCharactersFromAddressComponents:(NSDictionary *) components {
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:components];
    for (NSString *key in components) {
        if([components[key] isKindOfClass:[NSString class]]) {
            NSString *newValue = [components[key] stringByReplacingOccurrencesOfString:@"-" withString:@" "];
            newValue = [newValue stringByReplacingOccurrencesOfString:@"/" withString:@""];
            [result setObject:newValue forKey:(NSString *)key];
        }else {
            [result setObject:components[key] forKey:key];
        }
    }
    return result;
}


+ (NSString *)createTextFromAddressDictionary :(NSMutableDictionary *)address {
    NSMutableString * textAddress;
    if([address objectForKey:address_dict_street_key]) {
        [textAddress appendString:[NSString stringWithFormat:@"%@ \n",[address objectForKey:address_dict_street_key]]];
    }
    if([address objectForKey:address_dict_postal_code_key] && [address objectForKey:address_dict_town_key]) {
        [textAddress appendString:[NSString stringWithFormat:@"%@ %@",[address objectForKey:address_dict_postal_code_key], [address objectForKey:address_dict_town_key]]];
    }
    return [textAddress uppercaseString];
}

+ (BOOL)isNationalAddress: (NSString *)countryname {
    if([[countryname lowercaseString] isEqualToString:@"saint-barthélemy"] || [[countryname lowercaseString] isEqualToString:@"mayotte"] || [[countryname lowercaseString] isEqualToString:@"nouvelle-calédonie"] || [[countryname lowercaseString] isEqualToString:@"saint-martin"] || [[countryname lowercaseString] isEqualToString:@"polynésie"] || [[countryname lowercaseString] isEqualToString:@"guadeloupe"] || [[countryname lowercaseString] isEqualToString:@"guyane"] || [[countryname lowercaseString] isEqualToString:@"wallis-et-futuna"] || [[countryname lowercaseString] isEqualToString:@"martinique"] || [[countryname lowercaseString] isEqualToString:@"terres australes françaises"] || [[countryname lowercaseString] isEqualToString:@"la réunion"] || [[countryname lowercaseString] isEqualToString:@"france"])
        return YES;
    else
        return NO;
}

+ (NSString *)stringForKey:(NSString *)key {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"REEXLocalizable"
                                                     ofType:@"strings"
                                                inDirectory:nil
                                            forLocalization:@"fr"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    return [dict objectForKey:key];
    
}

+ (void)addBorder : (UIView *)view {
    view.layer.borderWidth = .5;
    view.layer.borderColor = [[UIColor whiteColor] CGColor];
}
    
+(NSMutableDictionary *) mapAddressFieldsToParamFields:(NSMutableDictionary*) paramsDict {
    
        NSMutableDictionary* newDict = [NSMutableDictionary dictionary];
        if (paramsDict[REXAddress_Ligne4_Key]) {
            newDict[kCCU_Param_Ligne4] = paramsDict[REXAddress_Ligne4_Key];
        }
        if (paramsDict[REXAddress_Ligne5_Key]) {
            newDict[kCCU_Param_Ligne5] = paramsDict[REXAddress_Ligne5_Key];
        }
        if (paramsDict[REXAddress_Ligne6_Localite_Key] && paramsDict[REXAddress_Ligne6_CP_Key]) {
            newDict[kCCU_Param_Ligne6] =  [NSString stringWithFormat:@"%@ %@", paramsDict[REXAddress_Ligne6_CP_Key], paramsDict[REXAddress_Ligne6_Localite_Key]];
        }
    if(paramsDict[REXAddress_Country_Key])
        newDict[kCCU_Param_Ligne7] = [NSString stringWithFormat:@"%@", [(NSString *)paramsDict[REXAddress_Country_Key][REXAddress_Country_Name_Key] lowercaseString]];
    else
        newDict[kCCU_Param_Ligne7] = @"France";
    return [REXUtils removeSpecialCharactersFromAddressComponents: newDict];
}


+ (NSMutableDictionary *) mapSarcadiaAddressToReexAddress: (NSMutableDictionary*) address {
    
    NSMutableDictionary* newDict = [NSMutableDictionary dictionary];
    if (address[kJsonValue_Ligne4][kJsonValue_Value]) {
        newDict[REXAddress_Ligne4_Key] = address[kJsonValue_Ligne4][kJsonValue_Value];
    }
    if (address[kJsonValue_Ligne5][kJsonValue_Value]) {
        newDict[REXAddress_Ligne5_Key] = address[kJsonValue_Ligne5][kJsonValue_Value];
    }
    if (address[kJsonValue_Ligne6][kJsonValue_CodePostal]) {
        newDict[REXAddress_Ligne6_CP_Key] =  address[kJsonValue_Ligne6][kJsonValue_CodePostal];
    }
    if (address[kJsonValue_Ligne6][kJsonValue_LibelleAcheminement]) {
        newDict[REXAddress_Ligne6_Localite_Key] =  address[kJsonValue_Ligne6][kJsonValue_LibelleAcheminement];
    }
    
    if (address[kJsonValue_Ligne6][kJsonValue_Code_Insee])
        newDict[REXAddress_Ligne6_Code_Localite_key] = address[kJsonValue_Ligne6][kJsonValue_Code_Insee];
    
    if(address[kJsonValue_Divers][kJsonValue_Quartier_Lettre])
        newDict[REXAddress_Quartier_Lettre_Key] = address[kJsonValue_Divers][kJsonValue_Quartier_Lettre];
    
    NSMutableDictionary *country = [[NSMutableDictionary alloc] init];
    [country setObject:address[kJsonValue_Ligne7][kJsonValue_Value] forKey:REXAddress_Country_Name_Key];
    [country setObject:[(NSString *)address[kJsonValue_Ligne7][kJsonValue_CodeISO] lowercaseString] forKey:REXAddress_Country_Isocode_Key];
    [newDict setObject:country forKey: REXAddress_Country_Key];
    return newDict;
}

+ (NSMutableDictionary *)createParamsForAddtoCartRequest:(Reexpedition *)reexpiditionData {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if(reexpiditionData.activationTime)
        [params setObject:reexpiditionData.activationTime forKey:REXActivation_Time_Key];
    
    if(reexpiditionData.allPersons)
        [params setObject:[NSNumber numberWithBool:YES] forKey:REXAll_Person_Key];
    
    [params setObject:reexpiditionData.beneficiaryArray forKey:REXContacts_Key];
    
    [params setObject:[NSNumber numberWithBool:NO] forKey:REXDead_Person_Key];
    
    if([reexpiditionData.deadPerson boolValue] && reexpiditionData.ayantDroitNom)
        [params setObject:reexpiditionData.ayantDroitNom forKey:REXAyant_Droit_Name_Key];
    
    if([reexpiditionData.deadPerson boolValue] && reexpiditionData.ayantDroitPrenom)
        [params setObject:reexpiditionData.ayantDroitPrenom forKey:REXAyant_Droit_Prenom_Key];
    
    if(reexpiditionData.dhOptins)
        [params setObject:reexpiditionData.dhOptins forKey:REXDh_Optins_Key];
    
    if(reexpiditionData.dhName)
        [params setObject:reexpiditionData.dhName forKey:REXDh_Name_Key];
    
    if(reexpiditionData.duration)
        [params setObject:reexpiditionData.duration forKey:REXDuration_Key];
    
    if(reexpiditionData.destinationAddress)
        [params setObject:reexpiditionData.destinationAddress forKey:REXNew_Address_Key];
    
    if(reexpiditionData.initialAddress)
        [params setObject:reexpiditionData.initialAddress forKey:REXOld_Address_Key];
    
    if(reexpiditionData.contratStartDate)
    [   params setObject:[self changeDateFormatToAcceptedReexDate:reexpiditionData.contratStartDate] forKey:REXStart_Date_Key];
    
    if(reexpiditionData.contratEndDate)
        [params setObject:[self changeDateFormatToAcceptedReexDate:reexpiditionData.contratEndDate] forKey:REXEnd_Date_Key];
    
    if(reexpiditionData.activationType) {
        [params setObject:[NSNumber numberWithBool:reexpiditionData.posteOfficeActivation] forKey:REXPostOffice_Activation_Key];
         [params setObject:[NSNumber numberWithBool:reexpiditionData.onlineActivation] forKey:REXOnline_Activation_Key];
         [params setObject:[NSNumber numberWithBool:reexpiditionData.alreadyLeftOldAddressActivation] forKey:REXAlready_Left_Home_Activation_Key];
        [params setObject:[NSNumber numberWithBool:reexpiditionData.alreadyLeftOldAddressActivation] forKey:REXHas_Already_Left_Activation_Key];
    }
    
    [params setObject:[NSNumber numberWithBool:reexpiditionData.useAddress] forKey:REXUse_Addresses_Key];
    [params setObject:@"" forKey:REXType_Parcours_Key];
    [params setObject:@"contract_123456" forKey:@"id"];
    [params setObject:[NSNumber numberWithBool:false] forKey:REXRenewed_Key];
    
    if(reexpiditionData.allPersons)
        [params setObject:[NSNumber numberWithBool:YES] forKey:REXAll_Person_Key];
    
    if(reexpiditionData.allPersons)
        [params setObject:reexpiditionData.allPersons forKey:REXAll_Person_Key];
    
    return params;
    
}

+ (NSString *)getCountryIsocodeFromName :(NSString *) countryName {
    NSArray *countryCodes = [NSLocale ISOCountryCodes];
    NSMutableArray *countries = [NSMutableArray arrayWithCapacity:[countryCodes count]];
    
    for (NSString *countryCode in countryCodes)
    {
        NSString *identifier = [NSLocale localeIdentifierFromComponents: [NSDictionary dictionaryWithObject: countryCode forKey: NSLocaleCountryCode]];
        NSString *country = [[[NSLocale alloc] initWithLocaleIdentifier:@"fr_FR"] displayNameForKey: NSLocaleIdentifier value: identifier];
        [countries addObject: [country capitalizedString]];
    }
    
    NSDictionary *codeForCountryDictionary = [[NSDictionary alloc] initWithObjects:countryCodes forKeys:countries];
    return [codeForCountryDictionary objectForKey:[countryName capitalizedString]];
}

+ (UIAlertController *)showAlertViewWithActions:(NSArray *)actionsArray withTitle:(NSString *)title withMessage:(NSString *)message {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    NSMutableAttributedString *alertTitle = [[NSMutableAttributedString alloc] initWithString:title];
    [alertTitle addAttribute:NSFontAttributeName
                  value:[UIFont boldSystemFontOfSize:17
                         ]
                  range:NSMakeRange(0, alertTitle.length)];
    [alertController setValue:alertTitle forKey:@"attributedTitle"];

    for (UIAlertAction *action in actionsArray) {
        [alertController addAction:action];
    }
    
    return alertController;
}

+ (NSString *)changeDateFormatToAcceptedReexDate: (NSString *)date {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"dd MMM yyyy"];
    NSDate *dateFromString = [format dateFromString:date];
    [format setDateFormat:@"yyyy-MM-dd"];
    return [format stringFromDate:dateFromString];
}

// Check if a string contains special caracters
+ (BOOL)isWithNoSpecialCaracters:(NSString *)stringToCheck {
    
    NSError *error = NULL;
    NSString *pattern = @"^[\\p{L} 0-9 .'-]+$";
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:stringToCheck
                                                        options:0
                                                          range:NSMakeRange(0, [stringToCheck length])];
    if (numberOfMatches == 0) {
        return NO;
    } else {
        return YES;
    }

}

+ (NSString *)getContractStatus:(NSString *)contractStatusLetter {
    
    if ([contractStatusLetter isEqualToString:@"A"]) {
        return @"Activé";
    } else if ([contractStatusLetter isEqualToString:@"B"]) {
        return @"En attente d'activation";
    } else if ([contractStatusLetter isEqualToString:@"C"]) {
        return @"En attente d'activation";
    } else if ([contractStatusLetter isEqualToString:@"R"]) {
        return @"Résilié";
    }
    
    return @"";
}

+ (BOOL)isEqualAddress:(NSDictionary *)initialAddress destinationAddress:(NSDictionary *)destinationAddress {

    
    if (![initialAddress[@"adresseL4"] isEqualToString:destinationAddress[@"adresseL4"]]) {
        return NO;
    }
    
    if (![initialAddress[@"adresseL5"] isEqualToString:destinationAddress[@"adresseL5"]]) {
        return NO;
    }
    
    if (![initialAddress[@"adresseL6CP"] isEqualToString:destinationAddress[@"adresseL6CP"]]) {
        return NO;
    }
    
    if (![initialAddress[@"adresseL6Localite"] isEqualToString:destinationAddress[@"adresseL6Localite"]]) {
        return NO;
    }
    
    if (![initialAddress[@"country"][@"Name"] isEqualToString:destinationAddress[@"country"][@"Name"]]) {
        return NO;
    }
    
    return YES;
}

+ (BOOL)isValidPeriodeFrom:(NSDate *)beginDate to:(NSDate *)endDate {
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
                                                        fromDate:beginDate
                                                          toDate:endDate
                                                         options:0];
    if (components.day < 14) {
        return NO;
    }
    else return YES;
}

/** Returns a new NSDate object with the time set to the indicated hour,
 * minute, and second.
 * @param hour The hour to use in the new date.
 * @param minute The number of minutes to use in the new date.
 * @param second The number of seconds to use in the new date.
 */
+ (NSDate *)dateWithHour:(NSDate *)date hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components: NSCalendarUnitDay|
                                    NSCalendarUnitMonth|
                                    NSCalendarUnitYear
                                               fromDate:date];
    [components setHour:hour];
    [components setMinute:minute];
    [components setSecond:second];
    
    NSDate *newDate = [calendar dateFromComponents:components];
    return newDate;
}

+ (NSDate *)getNextDay {
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = 1;
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    NSDate *nextDate = [theCalendar dateByAddingComponents:dayComponent toDate:[NSDate date] options:0];
    return nextDate;
}

+ (NSArray *)forbiddenList {
    return @[@"France",
             @"France Métropolitaine",
             @"Saint Barthelemy",
             @"Mayotte",
             @"Nouvelle Calédonie",
             @"Saint Martin Antilles françaises",
             @"Polynésie française",
             @"Guadeloupe",
             @"Guyane",
             @"Wallis-et-Futuna",
             @"Martinique",
             @"Terres australes françaises",
             @"La Réunion"];
}


+ (NSString *)getReexTrackingTagForGenericFormDisplay {
    if ([REXInfoToSend sharedInstance].isDefinitive == YES) {
        if ([REXInfoToSend sharedInstance].definitiveReexpedition.isNationnalReex) {
            if (![REXInfoToSend sharedInstance].definitiveReexpedition.isNewAddress)
                return REXDefTracking_Layout_ID_Nationale_Adresse_Depart_Saisie;
            else
                return REXDefTracking_Layout_ID_Nationale_Adresse_Destination_Saisie;
        }
        else {
            if (![REXInfoToSend sharedInstance].definitiveReexpedition.isNewAddress)
                return REXDefTracking_Layout_ID_Internationale_Adresse_Depart_Saisie;
            else
                return REXDefTracking_Layout_ID_Internationale_Adresse_Destination_Saisie;
        }
    } else {
        if ([REXInfoToSend sharedInstance].temporaryReexpedition.isNationnalReex) {
            if (![REXInfoToSend sharedInstance].temporaryReexpedition.isNewAddress)
                return REXTracking_Layout_ID_Nationale_Adresse_Depart_Saisie;
            else
                return REXTracking_Layout_ID_Nationale_Adresse_Destination_Saisie;
        }
        else {
            if (![REXInfoToSend sharedInstance].temporaryReexpedition.isNewAddress)
                return REXTracking_Layout_ID_Internationale_Adresse_Depart_Saisie;
            else
                return REXTracking_Layout_ID_Internationale_Adresse_Destination_Saisie;
        }
    }
}

+ (NSString *)getReexTrackingTagForGenericSarcadiaDisplay {
    if ([REXInfoToSend sharedInstance].isDefinitive == YES) {
        if ([REXInfoToSend sharedInstance].definitiveReexpedition.isNationnalReex) {
            if (![REXInfoToSend sharedInstance].definitiveReexpedition.isNewAddress)
                return REXDefTracking_Layout_ID_Nationale_Adresse_Depart_Serca;
            else
                return REXDefTracking_Layout_ID_Nationale_Adresse_Destination_Serca;
        }
        else {
            if (![REXInfoToSend sharedInstance].definitiveReexpedition.isNewAddress)
                return REXDefTracking_Layout_ID_Internationale_Adresse_Depart_Serca;
            else
                return REXDefTracking_Layout_ID_Internationale_Adresse_Destination_Serca;
        }
    } else {
        if ([REXInfoToSend sharedInstance].temporaryReexpedition.isNationnalReex) {
            if (![REXInfoToSend sharedInstance].temporaryReexpedition.isNewAddress)
                return REXTracking_Layout_ID_Nationale_Adresse_Depart_Serca;
            else
                return REXTracking_Layout_ID_Nationale_Adresse_Destination_Serca;
        }
        else {
            if (![REXInfoToSend sharedInstance].temporaryReexpedition.isNewAddress)
                return REXTracking_Layout_ID_Internationale_Adresse_Depart_Serca;
            else
                return REXTracking_Layout_ID_Internationale_Adresse_Destination_Serca;
        }
    }
}

+ (NSString *)getReexTrackingTagForGenericSarcadiaModifyAddressAction {
    if ([REXInfoToSend sharedInstance].isDefinitive == YES) {
        if([REXInfoToSend sharedInstance].definitiveReexpedition.isNewAddress) {
            if ([REXInfoToSend sharedInstance].definitiveReexpedition.isNationnalReex)
                return REXDefTracking_Layout_ID_Nationale_Destination_Serca_Modifier;
            else
                return REXDefTracking_Layout_ID_Internationale_Destination_Serca_Modifier;
        }
        else {
            if ([REXInfoToSend sharedInstance].definitiveReexpedition.isNationnalReex)
                return REXDefTracking_Layout_ID_Nationale_Depart_Serca_Modifier;
            else
                return REXDefTracking_Layout_ID_Internationale_Depart_Serca_Modifier;
        }
    } else {
        if([REXInfoToSend sharedInstance].temporaryReexpedition.isNewAddress) {
            if ([REXInfoToSend sharedInstance].temporaryReexpedition.isNationnalReex)
                return REXTracking_Layout_ID_Nationale_Destination_Serca_Modifier;
            else
                return REXTracking_Layout_ID_Internationale_Destination_Serca_Modifier;
        }
        else {
            if ([REXInfoToSend sharedInstance].temporaryReexpedition.isNationnalReex)
                return REXTracking_Layout_ID_Nationale_Depart_Serca_Modifier;
            else
                return REXTracking_Layout_ID_Internationale_Depart_Serca_Modifier;
        }
    }
}

+ (NSString *)getReexTrackingTagForGenericSarcadiaKeepEntryAddressAction {
    if ([REXInfoToSend sharedInstance].isDefinitive == YES) {
        if([REXInfoToSend sharedInstance].definitiveReexpedition.isNewAddress) {
            if ([REXInfoToSend sharedInstance].definitiveReexpedition.isNationnalReex)
                return REXDefTracking_Layout_ID_Nationale_Destination_Serca_Conserver;
            else
                return REXDefTracking_Layout_ID_Internationale_destination_Serca_Conserver;
        }
        else {
            if ([REXInfoToSend sharedInstance].definitiveReexpedition.isNationnalReex)
                return REXDefTracking_Layout_ID_Nationale_Depart_Serca_Conserver;
            else
                return REXDefTracking_Layout_ID_Internationale_Depart_Serca_Conserver;
        }
    } else {
        if([REXInfoToSend sharedInstance].temporaryReexpedition.isNewAddress) {
            if ([REXInfoToSend sharedInstance].temporaryReexpedition.isNationnalReex)
                return REXTracking_Layout_ID_Nationale_Destination_Serca_Conserver;
            else
                return REXTracking_Layout_ID_Internationale_destination_Serca_Conserver;
        }
        else {
            if ([REXInfoToSend sharedInstance].temporaryReexpedition.isNationnalReex)
                return REXTracking_Layout_ID_Nationale_Depart_Serca_Conserver;
            else
                return REXTracking_Layout_ID_Internationale_Depart_Serca_Conserver;
        }
    }
}

+ (NSMutableDictionary *)mapUserAccountAddressToReexDictionaryAddress {
    NSMutableDictionary *aDic = [[NSMutableDictionary alloc] init];

     MCMUser* user = [[MCMManager sharedInstance] user];
      [aDic setObject:user.street forKey:@"adresseL4"];
      [aDic setObject:user.town forKey:@"adresseL5"];
      [aDic setObject:user.locality forKey:@"adresseL6Localite"];
      [aDic setObject:user.postalCode forKey:@"adresseL6CP"];
      NSMutableDictionary *countryDic = [[NSMutableDictionary alloc] init];
      [countryDic setObject:user.countryName forKey:@"Name"];
      [countryDic setObject:[user.countryIsoCode lowercaseString] forKey:@"isocode"];
      [aDic setObject:countryDic forKey:@"country"];
    return aDic;
}


@end

//
//  REXUtils.h
//  laposte
//
//  Created by Mohamed Helmi Ben Jabeur on 08/09/2017.
//  Copyright © 2017 laposte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reexpedition.h"
@class REXInfoToSend;

@interface REXUtils : NSObject

+ (NSString *)stringForKey:(NSString *)key;
+ (void)addBorder : (UIView *)view;
+ (NSMutableDictionary *)mapAddressFieldsToParamFields:(NSDictionary*)paramsDict;
+ (NSMutableDictionary *)mapSarcadiaAddressToReexAddress: (NSMutableDictionary*) address;
+ (NSMutableDictionary *)createParamsForAddtoCartRequest:(Reexpedition *)reexpiditionData;
+ (NSString *)getCountryIsocodeFromName:(NSString *) countryName ;
+ (BOOL)isNationalAddress:(NSString *)countryname;
+ (UIAlertController *)showAlertViewWithActions:(NSArray *)actionsArray withTitle:(NSString *)title withMessage:(NSString *)message;
+ (NSString *)changeDateFormatToAcceptedReexDate: (NSString *)date;
+ (BOOL)isWithNoSpecialCaracters:(NSString *)stringToCheck;

+ (NSString *)getContractStatus:(NSString *)contractStatusLetter;
+ (BOOL)isEqualAddress:(NSDictionary *)initialAddress destinationAddress:(NSDictionary *)destinationAddress;
+ (BOOL)isValidPeriodeFrom:(NSDate *)beginDate to:(NSDate *)endDate;
+ (NSDate *)dateWithHour:(NSDate *)date hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second;
+ (NSDate *)getNextDay;
+ (NSArray *)forbiddenList;

//tracking utils
+ (NSString *)getReexTrackingTagForGenericFormDisplay;
+ (NSString *)getReexTrackingTagForGenericSarcadiaDisplay;
+ (NSString *)getReexTrackingTagForGenericSarcadiaModifyAddressAction;
+ (NSString *)getReexTrackingTagForGenericSarcadiaKeepEntryAddressAction;
+ (NSMutableDictionary *)mapUserAccountAddressToReexDictionaryAddress;


@end

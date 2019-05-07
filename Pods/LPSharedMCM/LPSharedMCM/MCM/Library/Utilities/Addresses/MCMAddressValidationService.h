//
//  MCMAddressValidationService.h
//  laposteCommon
//
//  Created by Hobart Wong on 05/04/2016.
//  Copyright © 2016 DigitasLBi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MascadiaValidationResult.h"

@interface MCMAddressValidationService : NSObject

+(void) validateAddress:(NSDictionary*) address withCompletion:(void (^)(NSArray *addressesArray, MascadiaValidationResult *validationResult,  NSError* error)) completion;
+(NSDictionary *) mapAddressFieldsToParamFields:(NSDictionary*) paramsDict;
+(MascadiaValidationResult *)mascadiaResponseStatusFromDictionary:(NSDictionary *)responseDictionary;
+(NSArray *)processMascadiaResponse:(NSDictionary *)responseObject;
+(NSArray *)processMascadiaResponseWithParams:(NSDictionary *)responseObject andFiltering:(bool)doFiltering;
+(void) searchZipCode:(NSString*) code withCompletion:(void (^)(NSArray *addressesArray, MascadiaValidationResult *validationResult,  NSError* error)) completion;

@end

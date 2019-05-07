//
//  REXServices.h
//  laposte
//
//  Created by Lassad Tiss on 13/09/2017.
//  Copyright © 2017 laposte. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HYBB2CService.h"
#import "REXConstant.h"

typedef void (^SuccessBlock)(BOOL isSuccess, id result);
typedef void (^FailBlock) (AFHTTPRequestOperation *operation, NSError* error);

@interface REXServices : NSObject

+ (void)getPriceForContractFrom:(NSString *)beginDate to:(NSString *)endDate isNational:(BOOL) isNational andSuccessBlock:(SuccessBlock) success andFailBlock:(FailBlock)fail;

+ (void)getInitReexWithType:(NSString *)reexType andSuccessBlock:(SuccessBlock)success andFailBlock:(FailBlock)fail;
//+ (void)sarcadiaVerification:(NSMutableDictionary *)address withCompletion:(void (^)(NSArray *addressesArray, MascadiaValidationResult *validationResult,  NSError* error)) completion;

+ (void)addToCart:(NSMutableDictionary *)params andIsNational:(BOOL) isNational andIsDefinitif:(BOOL)isDefinitif emailUser:(NSString *)emailUser withCompletion:(void (^)(id responseObject,  NSError* error)) completion;

// Get contracts list for connected user
+ (void)getReexContractsForUser:(NSString *)userEmail andExecute:(void (^)(id responseObject,  NSError* error))block;

+ (void)activateReexContract:(NSString *)activationCode withContractNumber:(NSString *)number emailUser:(NSString *)emailUser andSuccessBlock:(SuccessBlock) success andFailBlock:(FailBlock)fail;

// Renew Reex contract activation code
+ (void)renewReexCode:(NSString *)code forUserEmail:(NSString *)userEmail andExecute:(void (^) (NSString* statusCode, NSError* error))block;

+ (HYBB2CService *) backendService;

@end

//
//  HYBB2CService+ReexServices.h
//  laposte
//
//  Created by Issam DAHECH on 23/03/2018.
//  Copyright © 2018 laposte. All rights reserved.
//

#import "HYBB2CService.h"

@interface HYBB2CService (ReexServices)

- (void) renewReexCode:(NSString *)code forUserEmail:(NSString *)userEmail andExecute:(void (^) (NSString * statusCode, NSError* error))block;
- (void) getReexContractsForUser:(NSString *)userEmail andExecute:(void (^)(id responseObject,  NSError* error))block;
- (void)activateReexContract:(NSString *)activationCode forUserEmail:(NSString *) userEmail withContractNumber:(NSString *)number andSuccessBlock:(void (^)(BOOL isSuccess, id result)) success andFailBlock:(void (^)(AFHTTPRequestOperation *operation, NSError* error)) fail;
- (void)getInitReexWithType:(NSString *)reexType andSuccessBlock:(void (^)(BOOL isSuccess, id result)) success andFailBlock:(void (^)(AFHTTPRequestOperation *operation, NSError* error)) fail;
- (void)getPriceForContractFrom:(NSString *)beginDate to:(NSString *)endDate isNational:(BOOL) isNational andSuccessBlock:(void (^)(BOOL isSuccess, id result)) success andFailBlock:(void (^)(AFHTTPRequestOperation *operation, NSError* error)) fail;
- (void)addToCart:(NSMutableDictionary *)params forUser:(NSString *) userMail andIsNational:(BOOL) isNational andIsDefinitif:(BOOL)isDefinitif withCompletion:(void (^)(id responseObject,  NSError* error)) completion;


@end


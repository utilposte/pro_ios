//
//  REXServices.m
//  laposte
//
//  Created by Lassad Tiss on 13/09/2017.
//  Copyright © 2017 laposte. All rights reserved.
//

#import "REXServices.h"
#import "MCMLoadingManager.h"
#import "HYBB2CService+ReexServices.h"
#import "HYBB2CServiceWrapper.h"

#define kBaseURL [NSString stringWithFormat:@"https://%@/eboutiquecommercewebservices/v2/eboutique/", [[MCMManager sharedInstance].delegate getHybrisServiceHost]]

#define kInitREEXHost @"reex/dn/init"

@implementation REXServices

+ (void)getPriceForContractFrom:(NSString *)beginDate to:(NSString *)endDate isNational:(BOOL) isNational andSuccessBlock:(SuccessBlock) success andFailBlock:(FailBlock)fail {
    [[REXServices backendService] getPriceForContractFrom:beginDate to:endDate isNational:isNational andSuccessBlock:success andFailBlock:fail];
}


+ (void)getInitReexWithType:(NSString *)reexType andSuccessBlock:(SuccessBlock)success andFailBlock:(FailBlock)fail {
    [[MCMLoadingManager sharedInstance] showLoading];
    [[REXServices backendService] getInitReexWithType:reexType andSuccessBlock:success andFailBlock:fail];
}

+ (void)addToCart:(NSMutableDictionary *)params andIsNational:(BOOL) isNational andIsDefinitif:(BOOL)isDefinitif emailUser:(NSString *)emailUser withCompletion:(void (^)(id responseObject,  NSError* error)) completion {
    [[MCMLoadingManager sharedInstance] showLoading];
    [[REXServices backendService] addToCart:params forUser:emailUser andIsNational:isNational andIsDefinitif:isDefinitif withCompletion:completion];
}

+ (void)activateReexContract:(NSString *)activationCode withContractNumber:(NSString *)number emailUser:(NSString *)emailUser andSuccessBlock:(SuccessBlock) success andFailBlock:(FailBlock)fail {
    [[MCMLoadingManager sharedInstance] showLoading];
    [[REXServices backendService] activateReexContract:activationCode forUserEmail:emailUser withContractNumber:number andSuccessBlock:success andFailBlock:fail];
}

// Get contracts list for connected user
+ (void) getReexContractsForUser:(NSString *)userEmail andExecute:(void (^)(id responseObject,  NSError* error))block{

    [[REXServices backendService] getReexContractsForUser:userEmail andExecute:block];
}

// Renew Reex contract activation code
+ (void) renewReexCode:(NSString *)code forUserEmail:(NSString *)userEmail andExecute:(void (^) (NSString * statusCode, NSError* error))block {
    [[REXServices backendService] renewReexCode:code forUserEmail:userEmail andExecute:block];
}

+ (HYBB2CService *) backendService {
    return [[HYBB2CServiceWrapper sharedInstance] backEndService];
}

@end

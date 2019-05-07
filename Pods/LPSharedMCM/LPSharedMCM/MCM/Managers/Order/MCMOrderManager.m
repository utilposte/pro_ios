//
//  MCMOrderManager.m
//  laposte
//
//  Created by Matthieu Lemonnier on 28/02/2018.
//  Copyright © 2018 laposte. All rights reserved.
//

#import "MCMOrderManager.h"
#import "MCMLocationService.h"
#import "MCMNetworkManager.h"
#import "MCMLoadingManager.h"


@interface MCMOrderManager ()


-(HYBB2CService *) backendService;

@end

@implementation MCMOrderManager

+ (MCMOrderManager *)sharedManager {
    static MCMOrderManager *sharedMyManager = nil;
    @synchronized(self) {
        if (sharedMyManager == nil)
        {
            sharedMyManager = [[self alloc] init];
        }
    }
    return sharedMyManager;
}

- (HYBB2CService *) backendService {
    return [[HYBB2CServiceWrapper sharedInstance] backEndService];
}

- (void) getUserOrdersPage:(int) page orderStatus:(NSString *) status andExecute:(void (^)(id, LPNetworkError *))block {
    HYBB2CService *backendService = [self backendService];
    [[MCMLoadingManager sharedInstance] showLoading];
    NSDictionary *sortDict = nil;
    if (status) {
        sortDict = @{@"sort":@"byDate",
                     @"currentPage":[NSString stringWithFormat:@"%i", page],
                     @"statuses":status};
    }
    
    LPNetworkError * nError = [[MCMNetworkManager sharedManager] prepareNetworkRequest];
    if (nError == nil) {
        [backendService retrieveOrdersForUser:backendService.userId
                                   withParams:sortDict
                                   andExecute:^(NSArray *orders, NSError *error) {
                                       [[MCMLoadingManager sharedInstance] hideLoading];
                                       
                                       if (!error) {
                                           block(orders, nil);
                                       } else {
                                           LPNetworkError * nError = [[MCMNetworkManager sharedManager] manageNetworkError:error]; // SHOW ERROR YES
                                           block(nil, nError);
                                       }
                                   }];
    }
    else {
        block(nil, nError);
    }
}


- (void) getUserOrderDetailWithCode:(NSString *) code  andExecute:(void (^)(id, LPNetworkError *))block {
    HYBB2CService *backendService = [self backendService];
    [[MCMLoadingManager sharedInstance] showLoading];
    LPNetworkError * nError = [[MCMNetworkManager sharedManager] prepareNetworkRequest];
    if (nError == nil) {
        [backendService findOrderByCode:code andExecute:^(HYBOrder *order, NSError *error) {
            [[MCMLoadingManager sharedInstance] hideLoading];
            if (!error) {
                block(order, nil);
            } else {
                LPNetworkError * nError = [[MCMNetworkManager sharedManager] manageNetworkError:error]; // YES
                block(nil, nError);
            }
        }];
    }
    else {
        block(nil, nError);
    }
}

- (void) getUserOrderWithNoParamsDetailWithCode:(NSString *) code  andExecute:(void (^)(id, LPNetworkError *))block {
    HYBB2CService *backendService = [self backendService];
    [[MCMLoadingManager sharedInstance] showLoading];
    LPNetworkError * nError = [[MCMNetworkManager sharedManager] prepareNetworkRequest];
    if (nError == nil) {
        [backendService findOrderWithNoParamsByCode:code andExecute:^(HYBOrder *order, NSError *error) {
            [[MCMLoadingManager sharedInstance] hideLoading];
            if (!error) {
                block(order, nil);
            } else {
                LPNetworkError * nError = [[MCMNetworkManager sharedManager] manageNetworkError:error]; // YES
                block(nil, nError);
            }
        }];
    }
    else {
        block(nil, nError);
    }
}


- (void) placeOrderWithCart:(HYBCart *)cart andExecute:(void(^)(HYBOrder *order, LPNetworkError *error))block {
    HYBB2CService *backendService = [self backendService];
    [[MCMLoadingManager sharedInstance] showLoading];
    LPNetworkError * nError = [[MCMNetworkManager sharedManager] prepareNetworkRequest];
    if (nError == nil) {
        [backendService placeOrderWithCart:cart andExecute:^(HYBOrder *order, NSError *error) {
            [[MCMLoadingManager sharedInstance] hideLoading];
            if (error) {
                LPNetworkError * nError = [[MCMNetworkManager sharedManager] manageNetworkError:error]; // YES
                block(nil, nError);
            }
            block(order, nil);
        }];
    }
    else {
        block(nil, nError);
    }
}

- (void) getInvoiceForOrderId:(NSString*)orderCode andExecute:(void (^)(NSString*, LPNetworkError *))block {
    HYBB2CService *backendService = [self backendService];
    [[MCMLoadingManager sharedInstance] showLoading];
    LPNetworkError * nError = [[MCMNetworkManager sharedManager] prepareNetworkRequest];
    if (nError == nil) {
        [backendService getOrderInvoiceForUserId:orderCode andExecute:^(NSString *url, NSError *error) {
            [[MCMLoadingManager sharedInstance] hideLoading];
            if (error == nil) {
                block(url, nil);
            }
            else {
                LPNetworkError * lpError = [[MCMNetworkManager sharedManager] manageNetworkError:error];
                block(nil, lpError);
            }
        }];
    }
    else {
        block(nil, nError);
    }
}


- (void)renewOrderWithCode:(NSString *)code andExecute:(void (^)(id, LPNetworkError *))block {
    HYBB2CService *backendService = [self backendService];
    [[MCMLoadingManager sharedInstance] showLoading];
    LPNetworkError * nError = [[MCMNetworkManager sharedManager] prepareNetworkRequest];
    if (nError == nil) {
        [backendService renewOrder:code andExecute:^(NSString *statusCode, NSError *error) {
            [[MCMLoadingManager sharedInstance] hideLoading];
            if (error) {
                LPNetworkError * nError = [[MCMNetworkManager sharedManager] manageNetworkError:error]; // YES
                block(nil, nError);
            }
            block(statusCode, nil);
        }];
    }
    else {
        block(nil, nError);
    }
}

@end

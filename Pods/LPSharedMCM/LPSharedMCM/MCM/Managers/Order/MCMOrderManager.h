//
//  MCMOrderManager.h
//  laposte
//
//  Created by Matthieu Lemonnier on 28/02/2018.
//  Copyright © 2018 laposte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCMLocationService.h"
#import "MCMNetworkManager.h"
#import "MCMLoadingManager.h"
#import "LPNetworkError.h"


@interface MCMOrderManager : NSObject

+ (MCMOrderManager *)sharedManager;
- (void) getUserOrdersPage:(int) page orderStatus:(NSString *) status andExecute:(void (^)(id, LPNetworkError *))block;
- (void) getUserOrderDetailWithCode:(NSString *) code  andExecute:(void (^)(id, LPNetworkError *))block;
- (void) getUserOrderWithNoParamsDetailWithCode:(NSString *) code  andExecute:(void (^)(id, LPNetworkError *))block;
- (void) placeOrderWithCart:(HYBCart *)cart andExecute:(void(^)(HYBOrder *order, LPNetworkError *error))block;
- (void)renewOrderWithCode:(NSString *)code andExecute:(void (^)(id, LPNetworkError *))block;

- (void) getInvoiceForOrderId:(NSString*)orderCode andExecute:(void (^)(NSString*, LPNetworkError *))block;

@end

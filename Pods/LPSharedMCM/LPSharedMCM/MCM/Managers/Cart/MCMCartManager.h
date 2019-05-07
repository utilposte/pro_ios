//
//  MCMCartManger.h
//  laposte
//
//  Created by Issam DAHECH on 16/02/2018.
//  Copyright © 2018 laposte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCMNetworkManager.h"
#import "MCMLoadingManager.h"

@class HYBProduct, HYBOrderEntry, HYBB2CService;
@interface MCMCartManager : NSObject

+ (MCMCartManager *)sharedManager;

@property HYBB2CService *backendService;

// start Framework

- (void)deleteEntryForCartWitId:(NSString *)cartId entryNumber:(NSNumber *)entry withCallback:(void (^)(id success, LPNetworkError *))block;
- (void)retrieveCartSignUpWithCallback:(void (^)(HYBCart *cart, LPNetworkError *error)) block;
- (void)retrieveCartWithCallback:(void (^)(HYBCart *cart, LPNetworkError *error)) block;
- (void)updateCartEntryWithId:(NSString *)entryId withAmount:(NSNumber *)amount withCallback:(void (^)(id success, NSString *, LPNetworkError *))block;

- (void)addProductToCart:(NSString *)productCode amount:(NSNumber *)amount andExecute:(void (^)(HYBCart *, NSString*, LPNetworkError*))block;

- (void)createAddress:(NSDictionary*) addressParams forCart:(NSString *)cartId withCallback:(void (^) (id result, LPNetworkError *error))block;
- (void)setBillingAddressWithParams:(NSDictionary *)params forCart:(NSString *)cartId withCallback:(void (^) (id result, LPNetworkError *error))block;


- (void) setVoucherWithId:(NSString *) voucherId toCart:(HYBCart *) cart  andExecute:(void (^) (bool, LPNetworkError *))block;
- (void) removeVoucherWithId:(NSString *) voucherId fromCart:(HYBCart *) cart andExecute:(void (^) (bool, LPNetworkError *))block;

- (void)loadCartDeliveryModesWithUserId:(NSString *)userId cartId:(NSString *)cartId withCallback:(void (^) (NSArray *deliveries, LPNetworkError *error)) block;
- (void)setCartDeliveryModeWithDeliveryId:(NSString *)deliveryId cartId:(NSString *)cartId withCallback:(void (^) (HYBCart *currentCart, LPNetworkError *error)) block;

// end Framework

+ (NSDictionary *) resultRegroup:(NSArray *) entries pack:(HYBProduct *) pack unit:(HYBProduct *) unit;
+ (HYBOrderEntry *) orderEntryInEntries:(NSArray *) entries ForProductCode:(NSString *) code;
- (CGFloat) sizeRegroup:(NSArray *) entries  unit:(HYBProduct *) unit;
- (BOOL) needRegroup:(NSArray *) entries unit:(HYBProduct *) unit;
- (void) cancelRegroup:(NSNumber*) unitQty;
- (void) refreshCheckQty:(NSArray *) entries;

- (BOOL)haveGoalProduct:(NSArray *)entries;
- (void)deleteCartWithUserId:(NSString *)code andExecute:(void (^)())block;
- (void)getProductDetail:(NSString *)code andExecute:(void (^)(HYBProduct *))block;
- (BOOL)isReexProduct:(HYBOrderEntry *)orderEntry;
- (void)getPaymentMode:(NSString *)code andExecute:(void (^)(BOOL))block;
- (void) setPaymentMode:(NSString *)code withParams:(NSDictionary *)params andExecute:(void (^)(id))block;
- (void) executePayPalPayment:(NSString *)code withParams:(NSDictionary *)params andExecute:(void (^)(id))block;
@end

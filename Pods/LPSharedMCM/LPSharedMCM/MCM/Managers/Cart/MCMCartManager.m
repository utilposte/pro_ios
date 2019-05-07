//
//  CartManger.m
//  laposte
//
//  Created by Issam DAHECH on 16/02/2018.
//  Copyright © 2018 laposte. All rights reserved.
//

#import "MCMCartManager.h"
#import "MCMLocationService.h"
#import "MCMNetworkManager.h"
#import "MCMLoadingManager.h"

@interface MCMCartManager ()
@property int showRegroup;
-(HYBB2CService *) backendService;

@end

NSString *const Hybris_Voucher_Id_Param_Key = @"voucherId";


@implementation MCMCartManager
@synthesize backendService;
//+ (id)sharedManager {
//    static MCMCartManager *sharedMyManager = nil;
//    if (sharedMyManager)
//    {
//        sharedMyManager = [[self alloc] init];
//        sharedMyManager.showRegroup = 0;
//    }
//    return sharedMyManager;
//}

+ (MCMCartManager *)sharedManager {
    static MCMCartManager *sharedManager = nil;
    static dispatch_once_t onceToken; // onceToken = 0
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] initPrivate];
        sharedManager.showRegroup = 0;
    });
    
    return sharedManager;
}

- (instancetype)initPrivate {
    if (self = [super init]) {
        backendService = [[HYBB2CServiceWrapper sharedInstance] backEndService];
    }
    return self;
}

//- (id) init {
//    self = [[MCMCartManager alloc] init];
//    if (self) {
//        backendService = [[HYBB2CServiceWrapper sharedInstance] backEndService];
//    }
//    return self;
//}
- (HYBB2CService *) backendService {
    return [[HYBB2CServiceWrapper sharedInstance] backEndService];
}


+ (HYBOrderEntry *) orderEntryInEntries:(NSArray *) entries ForProductCode:(NSString *) code {
    for (HYBOrderEntry * entry in entries) {
        if([entry.product.code isEqual:code]) {
            return entry;
        }
    }
    return nil;
}

+ (NSDictionary *) resultRegroup:(NSArray *) entries pack:(HYBProduct *) pack unit:(HYBProduct *) unit {
    NSMutableDictionary * detail = nil;
    for (HYBOrderEntry * entry in entries) {
        if([entry.product.code isEqual:unit.code] && [entry.quantity intValue] >= 12)
        {
            int numberPack = [entry.quantity intValue] / 12;
            int numberUnit = [entry.quantity intValue] % 12;
            detail = [[NSMutableDictionary alloc] init];
            detail[@"packQty"] = [[NSNumber alloc] initWithInt:numberPack];
            detail[@"packProduct"] = pack;
            if (numberUnit > 0) {
                detail[@"unitQty"] = [[NSNumber alloc] initWithInt:numberUnit];
                detail[@"unitProduct"] = unit;
            }
        }
    }
    return detail;
}

- (CGFloat) sizeRegroup:(NSArray *) entries  unit:(HYBProduct *) unit {
    if (_showRegroup != 0) {
        return  0;
    }
    for (HYBOrderEntry * entry in entries) {
        if([entry.product.code isEqual:unit.code] && [entry.quantity intValue] >= 12)
        {
            int numberUnit = [entry.quantity intValue] % 12;
            if (numberUnit > 0) {
                return 280;
            }
        }
    }
    return 190;
}

- (BOOL) needRegroup:(NSArray *) entries unit:(HYBProduct *) unit {
    for (HYBOrderEntry * entry in entries) {
        if([entry.product.code isEqual:unit.code] && [entry.quantity intValue] >= 12 && _showRegroup == 0)
        {
            return YES;
        }
    }
    return NO;
}

- (void) refreshCheckQty:(NSArray *) entries {
    for (HYBOrderEntry * entry in entries) {
        if([entry.product.code isEqual:@"018202"] && [entry.quantity intValue] != _showRegroup)
        {
            _showRegroup = 0;
            return;
        }
    }
}

- (void) cancelRegroup:(NSNumber*) unitQty {
    _showRegroup = [unitQty intValue];
}

- (BOOL)haveGoalProduct:(NSArray *)entries {
    for (HYBOrderEntry *entry in entries) {
        if ([entry.product.code isEqualToString:@"goalProduct"]) {
            return YES;
        }
    }
    return NO;
}

- (void)deleteCartWithUserId:(NSString *)code andExecute:(void (^)())block {
//    HYBB2CService *backendService = [self backendService];
    [[MCMLoadingManager sharedInstance] showLoading];
    [backendService deleteCartForUserId:backendService.userId andCartId:code andExecute:^(id response, NSError *error) {
        if (!error) {
            [HYBCache uncacheObjectForKey:CURRENT_CART_KEY];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CART_UPDATED object:nil];
        }
        
        [[MCMLoadingManager sharedInstance] hideLoading];
        block();
        // TODO ISO
        // [UIAppDelegate navigationControllerPopToRoot];
    }];
}


- (void)getProductDetail:(NSString *)code andExecute:(void (^)(HYBProduct *))block  {
//    HYBB2CService *backendService = [self backendService];
    [[MCMLoadingManager sharedInstance] showLoading];
    [backendService getProductForCode:code
                           andExecute:^(HYBProduct *fullProduct, NSError *error) {
                               [[MCMLoadingManager sharedInstance] hideLoading];
                               block(fullProduct);
                           }];
}

- (BOOL)isReexProduct:(HYBOrderEntry *)orderEntry {
    if ([orderEntry.product.code hasPrefix:@"TN"] || [orderEntry.product.code hasPrefix:@"DN"] || [orderEntry.product.code hasPrefix:@"TI"] || [orderEntry.product.code hasPrefix:@"DI"]) {
        return YES;
    }
    else {
        return NO;
    }
}

- (void)getPaymentMode:(NSString *)code andExecute:(void (^)(BOOL))block {
    HYBB2CService *backendService = [self backendService];    
    [[MCMLoadingManager sharedInstance] showLoading];
    [backendService getPaymentModes:code andExecute:^(BOOL payPalAvailable, NSError *error) {
        [[MCMLoadingManager sharedInstance] hideLoading];
        block(payPalAvailable);
    }];
}

- (void) setPaymentMode:(NSString *)code withParams:(NSDictionary *)params andExecute:(void (^)(id))block {
    HYBB2CService *backendService = [self backendService];
    [backendService setPaymentMode:code withParams:params andExecute:^(id response, NSError *error) {
        block(response);
    }];
}

- (void) executePayPalPayment:(NSString *)code withParams:(NSDictionary *)params andExecute:(void (^)(id))block {
    HYBB2CService *backendService = [self backendService];
    [backendService executePayPalPayment:code withParams:params andExecute:^(id response, NSError *error) {
        block(response);
    }];
}

// Start Framework

- (void)deleteEntryForCartWitId:(NSString *)cartId entryNumber:(NSNumber *)entry withCallback:(void (^)(id success, LPNetworkError *))block {
//    HYBB2CService *backendService = [self backendService];
    [[MCMLoadingManager sharedInstance] showLoading];
    LPNetworkError * nError = [[MCMNetworkManager sharedManager] prepareNetworkRequest];
    if (nError == nil) {
        [backendService deleteCartEntryForUserId:backendService.userId
                                            andCartId:cartId
                                       andEntryNumber:[NSString stringWithFormat:@"%@", entry]
                                           andExecute:^(id successTag, NSError *error) {
                                               [[MCMLoadingManager sharedInstance] hideLoading];
                                               if (error) {
                                                   LPNetworkError * nError = [[MCMNetworkManager sharedManager] manageNetworkError:error]; // YES showError
                                                   block(nil, nError);
                                               } else  {
                                                   block(successTag, nil);
                                               }
                                           }];
    }
    else {
        block(nil, nError);
    }
}

//retrieveCartSignUpWithCallback

- (void)retrieveCartSignUpWithCallback:(void (^)(HYBCart *cart, LPNetworkError *error)) block {
    //    HYBB2CService *backendService = [self backendService];
    [[MCMLoadingManager sharedInstance] showLoading];
    LPNetworkError * nError = [[MCMNetworkManager sharedManager] prepareNetworkRequest];
    if (nError == nil) {
        [backendService retrieveCurrentCartSignupAndExecute:^(HYBCart *cart, NSError *error) {
            [[MCMLoadingManager sharedInstance] hideLoading];
            if (error) {
                LPNetworkError * nError = [[MCMNetworkManager sharedManager] manageNetworkError:error]; // YES showError
                block(nil, nError);
            }
            else {
                block(cart, nil);
            }
        }];
    }
}


- (void)retrieveCartWithCallback:(void (^)(HYBCart *cart, LPNetworkError *error)) block {
//    HYBB2CService *backendService = [self backendService];
    [[MCMLoadingManager sharedInstance] showLoading];
    LPNetworkError * nError = [[MCMNetworkManager sharedManager] prepareNetworkRequest];
    if (nError == nil) {
        [backendService retrieveCurrentCartAndExecute:^(HYBCart *cart, NSError *error) {
            [[MCMLoadingManager sharedInstance] hideLoading];
            if (error) {
                LPNetworkError * nError = [[MCMNetworkManager sharedManager] manageNetworkError:error]; // YES showError
                block(nil, nError);
            }
            else {
                block(cart, nil);
            }
        }];
    }
}

- (void)updateCartEntryWithId:(NSString *)entryId withAmount:(NSNumber *)amount withCallback:(void (^)(id success, NSString *, LPNetworkError *))block {
//    HYBB2CService *backendService = [self backendService];
    [[MCMLoadingManager sharedInstance] showLoading];
    LPNetworkError * nError = [[MCMNetworkManager sharedManager] prepareNetworkRequest];
    if (nError == nil) {
        [backendService updateProductOnCurrentCartAmount:entryId mount:amount
                                                   andExecute:^(HYBCart *cart, NSError *error) {
                                                       [[MCMLoadingManager sharedInstance] hideLoading];
                                                       if(error && [error code] != 999 && [error code] != 996) {
                                                           LPNetworkError * nError = [[MCMNetworkManager sharedManager] manageNetworkError:error]; // NO showError
                                                           block(nil, nil,nError);
                                                       }
                                                       else {
                                                           block(cart, error.localizedDescription,nil);
                                                       }
                                                   }];
    }
    else {
        block(nil, nil, nError);
    }
}

- (void)addProductToCart:(NSString *)productCode
                  amount:(NSNumber *)amount
              andExecute:(void (^)(HYBCart *, NSString *,  LPNetworkError*))block {
//    HYBB2CService *backendService = [self backendService];
    [[MCMLoadingManager sharedInstance] showLoading];
    LPNetworkError * nError = [[MCMNetworkManager sharedManager] prepareNetworkRequest];
    if (nError == nil) {
        [backendService addProductToCurrentCart:productCode amount:amount andExecute:^(HYBCart *cart, NSError* msg) {
            [[MCMLoadingManager sharedInstance] hideLoading];
            if (msg && [msg isKindOfClass:[NSError class]] && [MCMNetworkManager checkIsNoConnectionError:(NSError *)msg] && ((NSError *)msg).code != 999 && ((NSError *)msg).code != 996) {
                LPNetworkError * nError = [[MCMNetworkManager sharedManager] manageNetworkError:msg]; // NO showError
                block(nil, nil,nError);
            } else {
                block(cart, msg.localizedDescription, nil);
            }
        }];
    }
    else {
        block(nil, nil, nError);
    }
}

-(void) createAddress:(NSDictionary*) addressParams forCart:(NSString *)cartId withCallback:(void (^) (id result, LPNetworkError *error))block {
//    HYBB2CService *backendService = [self backendService];
    [[MCMLoadingManager sharedInstance] showLoading];
    LPNetworkError * nError = [[MCMNetworkManager sharedManager] prepareNetworkRequest];
    if (nError == nil) {
        [backendService createCartDeliveryAddressForUserId:backendService.userId
                                                      andCartId:cartId
                                                     withParams:addressParams
                                                     andExecute:^(id response, NSError *error) {
                                                         [[MCMLoadingManager sharedInstance] hideLoading];
                                                         if (error) {
                                                             LPNetworkError * nError = [[MCMNetworkManager sharedManager] manageNetworkError:error]; // NO showError
                                                             block(response, nError);
                                                         }
                                                         else {
                                                             block(response, nil);
                                                         }
                                                     }];
    }
    else {
        block(nil, nError);
    }
}

- (void)setBillingAddressWithParams:(NSDictionary *)params forCart:(NSString *)cartId withCallback:(void (^) (id result, LPNetworkError *error))block
{
//    HYBB2CService *backendService = [self backendService];
    LPNetworkError * nError = [[MCMNetworkManager sharedManager] prepareNetworkRequest];
    if (nError == nil) {
        [backendService createCartPaymentdetailsForUserId:backendService.userId
                                                     andCartId:cartId withParams:params
                                                    andExecute:^(id response, NSError *error) {
                                                        if (error) {
                                                            LPNetworkError * nError = [[MCMNetworkManager sharedManager] manageNetworkError:error]; // NO showError
                                                            block(response, nError);
                                                        }
                                                        else {
                                                            block(response, nil);
                                                        }
                                                    }];
    }
    else {
        block(nil, nError);
    }
}

- (void) setVoucherWithId:(NSString *) voucherId toCart:(HYBCart *) cart andExecute:(void (^) (bool, LPNetworkError *))block {
//    HYBB2CService *backendService = [self backendService];
    [[MCMLoadingManager sharedInstance] showLoading];
    LPNetworkError * nError = [[MCMNetworkManager sharedManager] prepareNetworkRequest];
    if (nError == nil) {
        NSString *cartId = cart.code;
        if ([backendService.userId isEqualToString:GUEST_USER]) {
            cartId = cart.guid;
        }
        [backendService setCartVoucherForUserId:backendService.userId
                                           andCartId:cartId
                                          withParams:@{Hybris_Voucher_Id_Param_Key:voucherId}
                                          andExecute:^(id success, NSError *error) {
                                              [[MCMLoadingManager sharedInstance] hideLoading];
                                              if (error) {
                                                  LPNetworkError * nError = [[MCMNetworkManager sharedManager] manageNetworkError:error]; // NO showError
                                                  block(nil, nError);
                                              }
                                              else {
                                                  block(success, nil);
                                              }
                                          }];
    }
    else {
        block(nil, nError);
    }
}

- (void) removeVoucherWithId:(NSString *) voucherId fromCart:(HYBCart *) cart andExecute:(void (^) (bool, LPNetworkError *))block{
//    HYBB2CService *backendService = [self backendService];
    [[MCMLoadingManager sharedInstance] showLoading];
    LPNetworkError * nError = [[MCMNetworkManager sharedManager] prepareNetworkRequest];
    if (nError == nil) {
        NSString *cartId = cart.code;
        if ([backendService.userId isEqualToString:GUEST_USER]) {
            cartId = cart.guid;
        }
        [backendService deleteCartVoucherForUserId:backendService.userId
                                              andCartId:cartId andVoucherId:voucherId
                                             andExecute:^(id success, NSError *error) {
                                                 [[MCMLoadingManager sharedInstance] hideLoading];
                                                 if (error) {
                                                     LPNetworkError * nError = [[MCMNetworkManager sharedManager] manageNetworkError:error]; // NO showError
                                                     block(nil, nError);
                                                 }
                                                 else {
                                                     block(success, nil);
                                                 }
                                             }];
    }
    else {
        block(nil, nError);
    }
}

- (void)loadCartDeliveryModesWithUserId:(NSString *)userId
                                 cartId:(NSString *)cartId
                           withCallback:(void (^) (NSArray *deliveries, LPNetworkError *error)) block
{
//    HYBB2CService *backendService = [self backendService];
    [[MCMLoadingManager sharedInstance] showLoading];
    LPNetworkError * nError = [[MCMNetworkManager sharedManager] prepareNetworkRequest];
    if (nError == nil) {
        [backendService getCartDeliverymodesForUserId:userId andCartId:cartId andExecute:^(id responseObject, NSError *error) {
            [[MCMLoadingManager sharedInstance] hideLoading];
            if (error) {
                LPNetworkError * nError = [[MCMNetworkManager sharedManager] manageNetworkError:error]; // YES showError
                block(nil, nError);
            } else {
                block([[NSArray alloc] initWithArray:responseObject], nil);
            }
        }];
    }
    else {
        block(nil, nError);
    }
}

- (void)setCartDeliveryModeWithDeliveryId:(NSString *)deliveryId
                                   cartId:(NSString *)cartId
                             withCallback:(void (^) (HYBCart *currentCart, LPNetworkError *error)) block
{
//    HYBB2CService *backendService = [self backendService];
    [[MCMLoadingManager sharedInstance] showLoading];
    LPNetworkError * nError = [[MCMNetworkManager sharedManager] prepareNetworkRequest];
    if (nError == nil) {
        [backendService setDeliveryModeWithCode:deliveryId
                                      onCartWithCode:cartId
                                          andExecute:^(HYBCart *cart, NSError *error) {
                                              [[MCMLoadingManager sharedInstance] hideLoading];
                                              if (error) {
                                                  LPNetworkError * nError = [[MCMNetworkManager sharedManager] manageNetworkError:error]; // YES showError
                                                  block(nil, nError);
                                              }
                                              else {
                                                 block(cart, nil);
                                              }
                                          }];
    }
    else {
        block(nil, nError);
    }
}



// End Framework

@end

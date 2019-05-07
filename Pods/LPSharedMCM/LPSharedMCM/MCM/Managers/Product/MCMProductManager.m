//
//  MCMProductManager.m
//  laposte
//
//  Created by Matthieu Lemonnier on 20/02/2018.
//  Copyright © 2018 laposte. All rights reserved.
//

#import "MCMProductManager.h"
#import "MCMLoadingManager.h"
#import "HYBParametrageData.h"
#import "HYBB2CService.h"
#import "HYBB2CServiceWrapper.h"
#import "MCMStockPickerValueCreator.h"
#import "MCMNetworkManager.h"
#import "MCMTrackingNetworkProtocol.h"


@interface MCMProductManager ()

@property NSMutableArray* crossSellingProducts; //[{@"products" : HYBProduct, @"quantity" : @1, @"indexQuantity":@0 }]

-(void) loadStickers:(NSArray*) codes pos:(NSUInteger) pos completion:(void (^)(NSArray *))block;
-(NSNumber *) quantityForProductLine:(NSDictionary *) productLine;
-(HYBB2CService *) backendService;
@end

@implementation MCMProductManager

+ (id)sharedManager {
    static MCMProductManager *sharedMyManager = nil;
    @synchronized(self) {
        if (sharedMyManager == nil){
            sharedMyManager = [[self alloc] init];
        }
    }
    return sharedMyManager;
}

- (HYBB2CService *) backendService {
    return [[HYBB2CServiceWrapper sharedInstance] backEndService];
}

// Framework

//- (void) getProductsByQuery:(NSString *) query andExecute:(void (^)(NSArray *, NSString *, LPNetworkError *))block {
//    HYBB2CService * backendService = [self backendService];
//    [[MCMLoadingManager sharedInstance] showLoading];
//
//    LPNetworkError * nError = [[MCMNetworkManager sharedManager] prepareNetworkRequest];
//    if (nError == nil) {
//        [backendService getProductsByQuery:query andExecute:^(NSArray *foundProducts, NSString *spellingSuggestion, NSError *error) {
//            [[MCMLoadingManager sharedInstance] hideLoading];
//            if (error) {
//                LPNetworkError * nError = [[MCMNetworkManager sharedManager] manageNetworkError:error]; // YES
//                block(nil, nil, nError);
//            } else {
//                block(foundProducts, spellingSuggestion, nil);
//            }
//        }];
//    };
//}

- (void) getProductsByQuery:(NSString *) query
                   fromPage:(NSNumber *) page
                       size:(NSNumber *) size
                 andExecute:(void (^)(NSArray *, NSString *, LPNetworkError *))block {
    HYBB2CService * backendService = [self backendService];
    LPNetworkError * nError = [[MCMNetworkManager sharedManager] prepareNetworkRequest];
    if (nError == nil) {
        [backendService getProductsByQuery:query
                                  fromPage:page
                                      size:size
                                andExecute:^(NSArray *foundProducts, NSString *spellingSuggestion, NSError *error) {
            if (error) {
                LPNetworkError * nError = [[MCMNetworkManager sharedManager] manageNetworkError:error]; // YES
                block(nil, nil, nError);
            } else {
                block(foundProducts, spellingSuggestion, nil);
            }
        }];
    }
}


- (void) getProductsAndDetailsByQuery:(NSString *) query andExecute:(void (^)(NSArray *, NSString *, LPNetworkError *, NSNumber *,NSArray *, NSArray *))block {
    HYBB2CService * backendService = [self backendService];
    [[MCMLoadingManager sharedInstance] showLoading];
    LPNetworkError * nError = [[MCMNetworkManager sharedManager] prepareNetworkRequest];
    if (nError == nil) {
        [backendService getProductsAndDetailsByQuery:query andExecute:^(NSArray *foundProducts, NSString *spellingSuggestion, NSError *error, NSNumber *totalResults, NSArray *facets, NSArray *sorts) {
            [[MCMLoadingManager sharedInstance] hideLoading];
            if (error) {
                LPNetworkError * nError = [[MCMNetworkManager sharedManager] manageNetworkError:error]; // YES
                block(nil, nil, nError, nil,nil,nil);

            } else {
                block(foundProducts, spellingSuggestion, nil,totalResults,facets,sorts);
            }
        }];
    }
}

- (void) getProductForCode:(NSString *) code andExecute:(void (^)(HYBProduct *, LPNetworkError *))block {
    HYBB2CService * backendService = [self backendService];
    [[MCMLoadingManager sharedInstance] showLoading];
    LPNetworkError * nError = [[MCMNetworkManager sharedManager] prepareNetworkRequest];
    if (nError == nil) {
        [backendService getProductForCode:code
                                    andExecute:^(HYBProduct *fullProduct, NSError *error) {
                                        [[MCMLoadingManager sharedInstance] hideLoading];
                                        if (error) {
                                            LPNetworkError * nError = [[MCMNetworkManager sharedManager] manageNetworkError:error]; // YES
                                            block(nil, nError);
                                        } else {
                                            block(fullProduct, nil);
                                        }
                                    }];
    }
}

// EndFramework

// Return False if no quantity.
- (BOOL) crossSellingQtySuperiorToZero:(NSArray *) bestCrossSellingsProducts {
    NSMutableArray * crossSellingTmp = [[NSMutableArray alloc] init];
    if (bestCrossSellingsProducts != nil) {
        [crossSellingTmp addObjectsFromArray:bestCrossSellingsProducts];
    }
    [crossSellingTmp addObjectsFromArray:_crossSellingProducts];
    for (NSDictionary * line in crossSellingTmp) {
        if(((HYBProduct *)line[@"product"]).isInStock) {
            return YES;
        }
    }
    return FALSE;
}


- (BOOL) needShowCrossSelling {
    NSString* natureSend = self.product.delaiEnvoi.code;
    NSString* destination = self.product.destinationEnvoi.code;
    
    // TODO product ID in dynamic
    // Si c'est une enveloppe REEX
    if ([@[@"17267", @"17268"] containsObject:self.product.code]) {
        return NO;
    }
        
    // Si c'est le bon type et une destination pour la France.
    if ([@[@"030", @"040", @"050"] containsObject: natureSend] && [destination isEqual:@"010"]){
        return YES;
    }
    return NO;
}

- (NSArray *) getDirectCrossSellingProducts {
    if(_crossSellingProducts.count > 0) {
        return  _crossSellingProducts;
    }
    return nil;
}

- (void) getCrossSellingProducts:(void (^)(NSArray *))block {
    if(_crossSellingProducts != nil && _crossSellingProducts.count == 2) {
        block(_crossSellingProducts);
    }
    else {
        _crossSellingProducts = [[NSMutableArray alloc] init];
        //[[MCMLoadingManager sharedInstance] showLoading];
        // TODO product ID in dynamic
        [self loadStickers:@[@"018202", @"018203"]
                       pos:0
                completion:block];
    }
}

-(NSDictionary*) productLineForCode:(NSString *)code {
    for(NSDictionary * productLine in _crossSellingProducts) {
        HYBProduct * product = productLine[@"product"];
        if([product.code isEqual:code]) {
            return productLine;
        }
    }
    return nil;
}

-(void) changeQuantityIndex:(NSNumber*) index forProduct:(HYBProduct *) product completion:(void (^)(NSArray *))block {
    int pos = 0;
    for(int i = 0; i < _crossSellingProducts.count; i++) {
        if([product.code isEqual: ((HYBProduct *)_crossSellingProducts[i][@"product"]).code]) {
            pos = i;
        }
    }
    _crossSellingProducts[pos][@"indexQuantity"] = index;
    _crossSellingProducts[pos][@"quantity"] = [self quantityForProductLine:_crossSellingProducts[pos]];
    block(_crossSellingProducts);
}

-(void) cleanCatalogDetail
{
    if (_crossSellingProducts.count > 0) {
        for (NSMutableDictionary * productLine in _crossSellingProducts) {
            productLine[@"indexQuantity"] = @0;
            productLine[@"quantity"] = [self quantityForProductLine:productLine];
        }
    }
}

// private method

-(NSNumber *) quantityForProductLine:(NSDictionary *) productLine {
    NSInteger index = [((NSNumber *)productLine[@"indexQuantity"]) integerValue];
    HYBProduct* product = productLine[@"product"];
    NSArray * listQuantity = [MCMStockPickerValueCreator valuesForStockLevel:product.stock];
    if( index < [listQuantity count]) {
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterNoStyle;
        NSNumber *number = [f numberFromString:listQuantity[index]];
        return number;
    }
    return nil;
}

-(void) loadStickers:(NSArray*) codes pos:(NSUInteger) pos completion:(void (^)(NSArray *))block {
    
    [[self backendService] getProductForCode:codes[pos] andExecute:^(HYBProduct* product, NSError * error) {
        if(error != NULL) {
//            [[MCMLoadingManager sharedInstance] hideLoading];
            block(nil);
            return;
        }
        
        if(product.isInStock) {
            NSMutableDictionary* productLine = [[NSMutableDictionary alloc] init];
            [productLine setValue:product forKey:@"product"];
            [productLine setValue:@0 forKey:@"indexQuantity"];
            NSNumber * quantity = [self quantityForProductLine:productLine];
            [productLine setValue:quantity forKey:@"quantity"];
            [_crossSellingProducts addObject:productLine];
        }
        if(_crossSellingProducts.count == codes.count) {
//            [[MCMLoadingManager sharedInstance] hideLoading];
            block(_crossSellingProducts);
        }
        else {
            NSUInteger nextPos = pos + 1;
            [self loadStickers:codes pos:nextPos completion:block];
        }
    }];
    
}

- (void)loadImagesForProduct:(HYBProduct*)product andExecute:(void (^)(NSArray *))block {
    [self.backendService loadImagesForProduct:product
                                   andExecute:^(NSArray *fetchedImages, NSError *error) {
                                       [[MCMLoadingManager sharedInstance] hideLoading];
                                       if (!error) {
                                           block(fetchedImages);
                                       }
                                   }];
}

@end

//
//  MCMProductManager.h
//  laposte
//
//  Created by Matthieu Lemonnier on 20/02/2018.
//  Copyright © 2018 laposte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYBProduct.h"
#import "MCMNetworkManager.h"

@interface MCMProductManager : NSObject

@property(nonatomic, assign) HYBProduct * product;

+ (id)sharedManager;

//Framework

//- (void) getProductsByQuery:(NSString *) query andExecute:(void (^)(NSArray *, NSString *, LPNetworkError *))block;
- (void) getProductsByQuery:(NSString *) query fromPage:(NSNumber *) page size:(NSNumber *) size andExecute:(void (^)(NSArray *, NSString *, LPNetworkError *))block;
- (void) getProductsAndDetailsByQuery:(NSString *) query andExecute:(void (^)(NSArray *, NSString *, LPNetworkError *, NSNumber *,NSArray *, NSArray *))block;
- (void) getProductForCode:(NSString *) code andExecute:(void (^)(HYBProduct *, LPNetworkError *))block;


//End Framework

- (BOOL) needShowCrossSelling;
- (BOOL) crossSellingQtySuperiorToZero:(NSArray *) bestCrossSellingsProducts;
- (void) getCrossSellingProducts:(void (^)(NSArray *))block;
- (void) changeQuantityIndex:(NSNumber*) index forProduct:(HYBProduct *) product completion:(void (^)(NSArray *))block;
- (NSDictionary*) productLineForCode:(NSString *)code;
- (void) cleanCatalogDetail;
- (NSArray *) getDirectCrossSellingProducts;
- (void)loadImagesForProduct:(HYBProduct*)product andExecute:(void (^)(NSArray *))block;
@end

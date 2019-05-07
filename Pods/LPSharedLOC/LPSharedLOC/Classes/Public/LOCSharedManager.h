//
//  LOCWebServiceManager.h
//  laposte
//
//  Created by Issam DAHECH on 21/07/2017.
//  Copyright © 2017 laposte. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LOCPostalOffice;
@interface LOCSharedManager : NSObject

+ (id)sharedManager;
- (void)getPostOfficeListNearby:(double)latitude longitude:(double)longitude withBlock:(void (^)(NSArray *list))completionBlock;
- (void)getPostOfficeListByText:(NSString *)searchText withBlock:(void (^)(NSArray *list))completionBlock;

- (void)getPostOfficeDetailByKey:(NSString *)codeSite withBlock:(void (^)(LOCPostalOffice *detailPostOffice))completionBlock;

- (void)getRetraitDepotList:(BOOL)isDepot nearbyList:(double)latitude longitude:(double)longitude withBlock:(void (^)(NSArray *list))completionBlock;
- (void)getRetraitDepotList:(BOOL)isDepot byText:(NSString *)searchText withBlock:(void (^)(NSArray *list))completionBlock;

- (void)getRetraitDepotList:(BOOL)isDepot nearbyList:(double)latitude longitude:(double)longitude byDay:(NSString*)day byHour:(NSString*)hour byType:(NSString*)type withBlock:(void (^)(NSArray *list))completionBlock;

- (void)getRetraitDepotList:(BOOL)isDepot byText:(NSString *)searchText byDay:(NSString*)day byHour:(NSString*)hour byType:(NSString*)type withBlock:(void (^)(NSArray *list))completionBlock;

- (void)getPostBoxListNearby:(double)latitude longitude:(double)longitude withBlock:(void (^)(NSArray *list))completionBlock;
- (void)getPostBoxList:(NSString *)searchText withBlock:(void (^)(NSArray *list))completionBlock;

- (NSDictionary *)retrievePostalCodeIfExist:(NSString *)string;

@end

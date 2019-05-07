//
//  MCMTrackingProtocol.h
//  MCommerce
//
//  Created by Ricardo Suarez on 05/09/16.
//  Copyright © 2016 laposte. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MCMTrackingProtocol <NSObject>

- (void)trackLayout:(NSString *)layout;
- (void)trackSuccessPayment:(NSDictionary *)data;
- (void)trackCancelOrder;
- (void)trackDownloadBill;
- (void)trackCart:(NSDictionary *)data;
- (void)trackProduct:(NSString *)productName;
- (void)trackProduct:(NSString *)productName forCategory:(NSString*)categoryName;
- (void)trackProductsList:(NSString *)elementName;
- (void)trackFilter:(NSString *)filterName :(NSString *)filterValue;
- (void)trackTri:(NSString *) label;
- (void)trackProductsListAction:(NSString *)actionName;
- (void)trackProductAction:(NSString *)actionName;
- (void)trackCartAction:(NSString *)actionName;
- (void)trackHeaderAction:(NSString *)actionName;
- (void)trackAction:(NSString *)actionName;
// A4Push Tracking
-(void)A4PushTracking: (NSDictionary *) params;
@end

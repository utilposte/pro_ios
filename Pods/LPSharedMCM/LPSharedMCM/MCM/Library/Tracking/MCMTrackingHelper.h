//
//  MCMTrackingHelper.h
//  Pods
//
//  Created by Ricardo Suarez on 05/09/16.
//
//

#import <Foundation/Foundation.h>

@class MCMPaymentSummaryData, HYBCart;

@interface MCMTrackingHelper : NSObject

+ (NSDictionary *)composeTrackingInfoWithOrder:(MCMPaymentSummaryData *) summary cart:(HYBCart *) cart;

@end

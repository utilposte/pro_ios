//
//  MCMPaymentSummaryData.h
//  laposte
//
//  Created by Ricardo Suarez on 20/01/16.
//  Copyright © 2016 laposte. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HYBCart;

typedef NS_ENUM(NSInteger, HybrisPaymentFinishStatus) {
    noStatus,
    Canceled,
    Accepted,
    Error,
    Rejected,
    Review
};

@interface MCMPaymentSummaryData : NSObject

@property (nonatomic, assign, readonly) HybrisPaymentFinishStatus transactionStatus;
@property (nonatomic, strong, readonly) NSString *transactionStatusText;

@property (nonatomic, strong, readonly) NSString *date;
@property (nonatomic, strong, readonly) NSString *commerceId;
@property (nonatomic, strong, readonly) NSString *transactionId;
@property (nonatomic, strong, readonly) NSString *totalAmount;
@property (nonatomic, strong, readonly) NSString *cardNumberText;
@property (nonatomic, strong, readonly) NSString *authorizationId;
@property (nonatomic, strong, readonly) NSString *certificateId;
@property (nonatomic, strong, readonly) NSString *orderId;

@property (nonatomic, strong, readonly) NSString *orderDate;
@property (nonatomic, strong, readonly) NSString *orderProductsId;
@property (nonatomic, strong, readonly) NSString *orderProductsName;
@property (nonatomic, strong, readonly) NSString *orderProductsGenre;
@property (nonatomic, strong, readonly) NSString *orderProductsPrice;
@property (nonatomic, strong, readonly) NSString *orderProductsNumber;
@property (nonatomic, strong, readonly) NSString *orderNumber;
@property (nonatomic, strong, readonly) NSString *orderPromotionCode;
@property (nonatomic, strong, readonly) NSString *orderReturnsHT;
@property (nonatomic, strong, readonly) NSString *orderReturnsTTC;
@property (nonatomic, strong, readonly) NSString *orderPaymentType;
@property (nonatomic, strong, readonly) NSString *orderCardType;
@property (nonatomic, strong, readonly) NSString *orderClientId;
@property (nonatomic, strong, readonly) NSString *orderIsNewCient;
@property (nonatomic, strong, readonly) NSString *orderCRMId;
@property (nonatomic, strong, readonly) NSString *lastProductCategory;

+ (instancetype)paymentSummaryWithParams:(NSDictionary*)params cart:(HYBCart *) cart;

@end

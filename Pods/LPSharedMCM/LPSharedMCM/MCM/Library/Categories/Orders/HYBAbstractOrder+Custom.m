//
//  HYBAbstractOrder+Custom.m
//  laposteCommon
//
//  Created by Ricardo Suarez on 13/05/16.
//  Copyright © 2016 DigitasLBi. All rights reserved.
//

#import "HYBAbstractOrder+Custom.h"

#import "HYBPrice.h"

static const CGFloat kFreeDeliveryDefaultPrice = 0.0f;
static NSString *const kDeliveryAmountDefault = @"0.00 €";

@implementation HYBAbstractOrder (Custom)

#pragma mark - ---- LIFE CICLE

#pragma mark - ---- INTERNAL

#pragma mark - ---- PUBLIC

- (NSString *) getDeliveryAmountFormatted {
    NSString *deliveryAmount = kDeliveryAmountDefault;
    CGFloat deliveryAmountValue = kFreeDeliveryDefaultPrice;
    
    if (self.deliveryCost.value) {
        deliveryAmountValue = [self.deliveryCost.value floatValue];
        deliveryAmount = [NSString stringWithFormat:@"%.02f €", self.deliveryCost.value.floatValue];
    }
    return deliveryAmount;
}

- (CGFloat) getDeliveryAmount {
    CGFloat deliveryAmountValue = kFreeDeliveryDefaultPrice;
    
    if (self.deliveryCost.value) {
        deliveryAmountValue = [self.deliveryCost.value floatValue];
    }
    
    return deliveryAmountValue;
}

@end

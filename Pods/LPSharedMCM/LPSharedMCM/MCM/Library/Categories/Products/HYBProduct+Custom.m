//
//  HYBProduct+Custom.m
//  laposteCommon
//
//  Created by Ricardo Suarez on 05/04/16.
//  Copyright © 2016 DigitasLBi. All rights reserved.
//

#import "HYBProduct+Custom.h"

#import "HYBStock.h"
#import "MCMStyles.h"
#import "MCMLocalizedStringHelper.h"

static NSString *const kInStockKey = @"inStock";
static NSString *const kLowStockKey = @"lowStock";
static NSString *const kOutOfStockKey = @"outOfStock";

static NSString *const kInStockLocalizedKey = @"product_list_in_stock";
static NSString *const kLowStockLocalizedKey = @"product_list_low_stock_number";
static NSString *const kOutOfStockLocalizedKey = @"product_list_out_of_stock";

@implementation HYBProduct (Custom)

#pragma mark - ---- LIFE CICLE

#pragma mark - ---- INTERNAL

#pragma mark - ---- PUBLIC

- (NSString *) getStockLevelFormattedText {
    NSString *result = nil;
    if ([self.stock.stockLevelStatus isEqualToString:kInStockKey]) {
        result = [MCMLocalizedStringHelper stringForKey:kInStockLocalizedKey];
    } else if ([self.stock.stockLevelStatus isEqualToString:kLowStockKey]) {
        result = [NSString stringWithFormat:[MCMLocalizedStringHelper stringForKey:kLowStockLocalizedKey], [self.stock.stockLevel intValue]];
    } else if ([self.stock.stockLevelStatus isEqualToString:kOutOfStockKey]) {
        result = [MCMLocalizedStringHelper stringForKey:kOutOfStockLocalizedKey];
    }
    return result;
}

- (UIColor *) getStockLevelFormattedTextColor {
    UIColor *result = nil;
    if ([self.stock.stockLevelStatus isEqualToString:kInStockKey]) {
        result = [[MCMStyles sharedInstance] textColorForStockAvailability:MCMStockAvailabityInStock];
    } else if ([self.stock.stockLevelStatus isEqualToString:kLowStockKey]) {
        result = [[MCMStyles sharedInstance] textColorForStockAvailability:MCMStockAvailabityLowStock];
    } else if ([self.stock.stockLevelStatus isEqualToString:kOutOfStockKey]) {
        result = [[MCMStyles sharedInstance] textColorForStockAvailability:MCMStockAvailabityOutOfStock];
    }
     
    return  result;
}

@end

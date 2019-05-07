//
//  MCMStockPickerValueCreator.m
//  laposteCommon
//
//  Created by Hobart Wong on 08/03/2016.
//  Copyright © 2016 DigitasLBi. All rights reserved.
//

#import "MCMStockPickerValueCreator.h"
#import "HYBStock.h"

static NSInteger const maxNumberStock    = 999;

@implementation MCMStockPickerValueCreator

+ (NSArray*) valuesForStockLevel:(HYBStock*) stock
{
    NSMutableArray* array = [NSMutableArray array];
    NSInteger maxNumber = maxNumberStock;
    
    if(stock.stockLevel.integerValue < maxNumberStock && stock.stockLevel != nil) {
        maxNumber = stock.stockLevel.integerValue;
    }
    
    for (int i = 1; i <= maxNumber; i++) {
        [array addObject:[NSString stringWithFormat:@"%i", i]];
    }
    
    return array;
}

+ (NSUInteger) indexForString:(NSString*) string inStringArray:(NSArray*) array {
    for (int i = 0; i < array.count; i++) {
        if([[array objectAtIndex:i] isEqualToString:string]) {
            return i;
        }
    }
    return 0;
}

@end

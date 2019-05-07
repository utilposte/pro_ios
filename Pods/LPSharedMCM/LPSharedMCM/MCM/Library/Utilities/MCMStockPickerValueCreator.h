//
//  MCMStockPickerValueCreator.h
//  laposteCommon
//
//  Created by Hobart Wong on 08/03/2016.
//  Copyright © 2016 DigitasLBi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HYBStock;

@interface MCMStockPickerValueCreator : NSObject
+ (NSArray*) valuesForStockLevel:(HYBStock*) stock;
+ (NSUInteger) indexForString:(NSString*) string inStringArray:(NSArray*) array;
@end

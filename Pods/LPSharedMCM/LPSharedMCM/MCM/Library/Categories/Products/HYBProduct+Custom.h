//
//  HYBProduct+Custom.h
//  laposteCommon
//
//  Created by Ricardo Suarez on 05/04/16.
//  Copyright © 2016 DigitasLBi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYBProduct.h"

@interface HYBProduct (Custom)

- (NSString *) getStockLevelFormattedText;
- (UIColor *) getStockLevelFormattedTextColor;

@end

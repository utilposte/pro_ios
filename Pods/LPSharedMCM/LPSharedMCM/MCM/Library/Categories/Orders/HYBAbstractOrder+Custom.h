//
//  HYBAbstractOrder+Custom.h
//  laposteCommon
//
//  Created by Ricardo Suarez on 13/05/16.
//  Copyright © 2016 DigitasLBi. All rights reserved.
//

#import "HYBAbstractOrder.h"

#import <CoreGraphics/CoreGraphics.h>

@interface HYBAbstractOrder (Custom)

- (NSString *) getDeliveryAmountFormatted;
- (CGFloat) getDeliveryAmount;

@end

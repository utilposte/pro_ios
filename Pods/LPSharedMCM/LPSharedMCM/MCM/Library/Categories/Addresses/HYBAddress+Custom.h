//
//  HYBAddress+Custom.h
//  laposte
//
//  Created by Ricardo Suarez on 04/02/16.
//  Copyright © 2016 laposte. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "HYBAddress.h"

@interface HYBAddress (Custom)

@property (nonatomic, strong) NSString *apartment;
@property (nonatomic, strong) NSString *building;

- (BOOL) isInFrance;
- (NSString *) getFormattedAddressString;
- (BOOL)isEqual:(id)object;

@end

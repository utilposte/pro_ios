//
//  UILabel+MCMStyles.m
//  laposte
//
//  Created by Jerilyn Goncalves Figueira on 01/08/16.
//  Copyright © 2016 laposte. All rights reserved.
//

#import "UILabel+MCMStyles.h"

@implementation UILabel (MCMStyles)

- (void)customiseLabelWithSize:(MCMTextSize)textSize color:(MCMStyleOption)colorOption {
    
    [self setFont:[[MCMStyles sharedInstance] fontOfSize:textSize]];
    [self setTextColor:[[MCMStyles sharedInstance] textColor:colorOption]];
    
}

- (void)customiseLabelWithSize:(MCMTextSize)textSize stockColor:(MCMStockAvailabity)colorOption {
    
    [self setFont:[[MCMStyles sharedInstance] fontOfSize:textSize]];
    [self setTextColor:[[MCMStyles sharedInstance] textColorForStockAvailability:colorOption]];
    
}

- (void)customiseBoldLabelWithSize:(MCMTextSize)textSize stockColor:(MCMStockAvailabity)colorOption {
    
    [self setFont:[[MCMStyles sharedInstance] boldFontOfSize:textSize]];
    [self setTextColor:[[MCMStyles sharedInstance] textColorForStockAvailability:colorOption]];
    
}


- (void)customiseBoldLabelWithSize:(MCMTextSize)textSize color:(MCMStyleOption)colorOption {
    
    [self setFont:[[MCMStyles sharedInstance] boldFontOfSize:textSize]];
    [self setTextColor:[[MCMStyles sharedInstance] textColor:colorOption]];
    
}


- (void)customiseMediumLabelWithSize:(MCMTextSize)textSize color:(MCMStyleOption)colorOption {
    
    [self setFont:[[MCMStyles sharedInstance] mediumFontOfSize:textSize]];
    [self setTextColor:[[MCMStyles sharedInstance] textColor:colorOption]];
    
}


@end

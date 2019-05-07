//
//  UIButton+MCMStyles.m
//  laposte
//
//  Created by Jerilyn Goncalves Figueira on 29/07/16.
//  Copyright © 2016 laposte. All rights reserved.
//

#import "UIButton+MCMStyles.h"

@implementation UIButton (MCMStyles)

- (void)customiseButtonWithTitle:(NSString *)title option:(MCMStyleOption)styleOption {

    switch (styleOption) {
            
        case MCMStyleOptionPrimary:
            [self customisePrimaryButtonWithTitle:title];
            break;
            
        case MCMStyleOptionSecondary:
            [self customiseSecondaryButtonWithTitle:title];
            break;
            
        case MCMStyleOptionDefault:
            [self customiseDefaultButtonWithTitle:title];
            break;
        case MCMStyleOptionLink:
            [self customiseLinkButtonWithTitle:title];
            break;
        default:
            [self customiseDefaultButtonWithTitle:title];
            break;
    }
}


#pragma mark - Custom buttons/views setups

- (void)customisePrimaryButtonWithTitle:(NSString *)title {
    
    [self setBackgroundColor:[[MCMStyles sharedInstance] buttonColor:MCMStyleOptionPrimary]];
    [self setTitle:title forState:UIControlStateNormal];
    [self.titleLabel setFont:[[MCMStyles sharedInstance] fontOfSize:MCMTextSize2XL]];
    [self setTitleColor:[[MCMStyles sharedInstance] textColor:MCMStyleOptionSecondary]forState:UIControlStateNormal];
    
}

- (void)customiseSecondaryButtonWithTitle:(NSString *)title {
    
    [self setBackgroundColor:[[MCMStyles sharedInstance] buttonColor:MCMStyleOptionSecondary]];
    [self setTitle:title forState:UIControlStateNormal];
    [self.titleLabel setFont:[[MCMStyles sharedInstance] fontOfSize:MCMTextSize2XL]];
    [self setTitleColor:[[MCMStyles sharedInstance] textColor:MCMStyleOptionSecondary] forState:UIControlStateNormal];
}

- (void)customiseDefaultButtonWithTitle:(NSString *)title {
    
    [self setBackgroundColor:[[MCMStyles sharedInstance] buttonColor:MCMStyleOptionDefault]];
    [self setTitle:title forState:UIControlStateNormal];
    [self.titleLabel setFont:[[MCMStyles sharedInstance] fontOfSize:MCMTextSize2XL]];
    [self setTitleColor:[[MCMStyles sharedInstance] textColor:MCMStyleOptionDefault] forState:UIControlStateNormal];
}

- (void)customiseLinkButtonWithTitle:(NSString *)title {
    
    [self setBackgroundColor:[UIColor whiteColor]];
    [self setTitle:title forState:UIControlStateNormal];
    [self.titleLabel setFont:[[MCMStyles sharedInstance] fontOfSize:MCMTextSizeM]];
    [self setTitleColor:[UIColor colorWithRed:0.0f/255.0f green:114.0f/255.0f blue:181.0f/255.0f alpha:1] forState:UIControlStateNormal];
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;

}

@end

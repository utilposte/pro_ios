//
//  NSString+MCMCustom.m
//  laposte
//
//  Created by Ricardo Suarez on 04/08/16.
//  Copyright © 2016 laposte. All rights reserved.
//

#import "UIColor+HEXValue.h"

@implementation UIColor (HEXValue)


- (NSString *)hexStringValue {
    
    CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha = 0.0;
    const CGFloat *components = CGColorGetComponents( [self CGColor] );
    red = components[0];
    green = components[1];
    blue = components[2];
    alpha = components[3];
    
    return [NSString stringWithFormat: @"%02X%02X%02X", (int) roundf(red * 255.0), (int) roundf(green * 255.0), (int) roundf(blue * 255.0)];

}


+ (UIColor *)colorWithHexString:(NSString *)hexString {
    
    if (hexString.length > 0) {
        
        unsigned rgbValue = 0;
        NSScanner *scanner = [NSScanner scannerWithString:hexString];
        [scanner scanHexInt:&rgbValue];
        
        UIColor *color = [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
        return color;

    }
    
    return nil;
    
}
@end

//
//  UIFont+MCMCustom.h
//  MCommerce
//
//  Created by Jerilyn Gonçalves on 30/08/2016.
//  Copyright © 2016 DigitasLBi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (MCMCustom)

+ (UIFont *)customFontOfSize:(NSString *)fontName size:(CGFloat)fontSize;
+ (void)dynamicallyLoadFontNamed:(NSString *)name;

@end

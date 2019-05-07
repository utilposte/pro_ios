//
//  UIFont+MCMCustom.m
//  MCommerce
//
//  Created by Jerilyn Gonçalves on 30/08/2016.
//  Copyright © 2016 DigitasLBi. All rights reserved.
//

#import "UIFont+MCMCustom.h"

#import "MCMBundleHelper.h"
#import <CoreText/CTFontManager.h>

@implementation UIFont (MCMCustom)

+ (UIFont *)customFontOfSize:(NSString *)fontName size:(CGFloat)fontSize {
    
    UIFont *font = [UIFont fontWithName:fontName size:fontSize];
    if (!font) {
        [[self class] dynamicallyLoadFontNamed:fontName];
        font = [UIFont fontWithName:fontName size:fontSize];

        // Fallback
        if (!font) font = [UIFont systemFontOfSize:fontSize];
    }
    
    return font;
}

+ (void)dynamicallyLoadFontNamed:(NSString *)name {

    NSBundle *bundle = [MCMBundleHelper moduleBundle];
    NSURL *urlForTTF = [bundle URLForResource:name withExtension:@"ttf"];
    
    NSData *fontData = [NSData dataWithContentsOfURL:urlForTTF];
    
    if (!fontData) {
        NSURL *urlForOTF = [bundle URLForResource:name withExtension:@"otf"];
        fontData = [NSData dataWithContentsOfURL:urlForOTF];
    }
    
    if (fontData) {
        
        CGDataProviderRef provider = CGDataProviderCreateWithCFData((CFDataRef)fontData);
        CGFontRef font = CGFontCreateWithDataProvider(provider);
        CFErrorRef error;

        if (! CTFontManagerRegisterGraphicsFont(font, &error)) {
            CFStringRef errorDescription = CFErrorCopyDescription(error);
            NSLog(@"Failed to load font: %@", errorDescription);
            CFRelease(errorDescription);
        }
        CFRelease(font);
        CFRelease(provider);
    }
}

@end

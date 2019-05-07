//
//  MCMStyles.m
//  laposteCommon
//
//  Created by Alberto Delgado on 09/02/16.
//  Copyright © 2016 DigitasLBi. All rights reserved.
//

#import "MCMStyles.h"
#import "MCMStyles+Helper.h"
#import "MCMPlistUtils.h"
#import "UIColor+HEXValue.h"
#import "UIFont+MCMCustom.h"

#pragma mark - Constants definitions

#pragma mark Spacing

/// Spacing dictionary name
NSString *const kSpacing_Dictionary = @"Spacing";

/// Horizontal spacing key name
NSString *const kSpacing_horizontalPadding = @"horizontalPadding";
/// Vertical spacing key name
NSString *const kSpacing_verticalPadding = @"verticalPadding";

#pragma mark Font sizes

/// Font sizes dictionary name
NSString *const kFontSize_Dictionary = @"Sizes";

/// Font 2XS key name
NSString *const kFontSize_2XS = @"2XS";
/// Font XS key name
NSString *const kFontSize_XS = @"XS";
/// Font S key name
NSString *const kFontSize_S = @"S";
/// Font M key name
NSString *const kFontSize_M = @"M";
/// Font L key name
NSString *const kFontSize_L = @"L";
/// Font XL key name
NSString *const kFontSize_XL = @"XL";
/// Font 2XL key name
NSString *const kFontSize_2XL = @"2XL";
/// Font 3XL key name
NSString *const kFontSize_3XL = @"3XL";

#pragma mark Fonts

/// Fonts dictionary name
NSString *const kFont_Dictionary = @"Fonts";

/// Default font key name
NSString *const kFont_Regular = @"fontName";
/// Bold font key name
NSString *const kFont_Bold = @"boldFontName";
/// Medium font key name
NSString *const kFont_Medium = @"mediumFontName";

#pragma mark Colors

/// Colors dictionary name
NSString *const MCM_Color_Dictionary_Key = @"Colors";

/// Primary color key name
NSString *const MCM_Color_Primary_Key = @"primary";
/// Secondary color key name
NSString *const MCM_Color_Secondary_Key = @"secondary";
/// Alternative/default color key name
NSString *const MCM_Color_Alternative_Key = @"alternative";
/// Error color key name
NSString *const kColor_Error = @"errorColor";
/// Border color key name
NSString *const kColor_Border = @"borderColor";
///Product price color
NSString *const KColor_Price = @"productPrice";


#pragma mark UIButton colors

/// Buttons colors dictionary name
NSString *const kColor_Button_Dictionary = @"Button";

/// Disabled button color key name
NSString *const kColor_Button_Disabled = @"disabled";

#pragma mark Text colors

/// Text colors dictionary name
NSString *const kColor_Text_Dictionary = @"Text";

#pragma mark UINavigationBar colors

/// Navigation bar colors dictionary name
NSString *const kColor_NavigationBar_Dictionary = @"NavigationBar";

/// Navigation bar color for "My Orders" sub-module key name
NSString *const kColor_NavigationBar_MyOrders = @"myOrders";

#pragma mark Background colors

/// Background colors dictionary name
NSString *const kColor_Background_Dictionary = @"Background";

/// Footer background
NSString *const KColor_Footer_Background = @"footer";

#pragma mark Cart colors

/// Cart colors dictionary name
NSString *const kColor_Cart_Dictionary = @"Cart";

/// Cart bottom bar background color key name
NSString *const kColor_Cart_BottomBackground = @"bottomBarBackground";
/// Cart bottom bar title color key name
NSString *const kColor_Cart_BottomTitle = @"bottomBarTitle";

#pragma mark Product stock colors

/// Product stock colors dictionary name
NSString *const kColor_Stock_Dictionary = @"Stock";

/// In stock/available color key name
NSString *const kColor_Stock_InStock = @"available";
/// Low stock color key name
NSString *const kColor_Stock_LowStock = @"lowStock";
/// Out of stock/unavailable color key name
NSString *const kColor_Stock_OutOfStock = @"outOfStock";

#pragma mark Scan pay colors

/// CardIo feature colors dictionary name
NSString *const kColor_CardIo_Dictionary = @"CardIo";

/// CardIo sight color key name
NSString *const kColor_CardIo_Sight = @"sight";
/// CardIo title color key name
NSString *const kColor_CardIo_Title = @"title";

@interface MCMStyles()

@property (nonatomic, strong) NSDictionary *stylesDictionary;
@property (nonatomic, strong) NSString *defaultStylesPlistName;
@property (nonatomic, strong) NSString *customStylesPlistName;

@end

@implementation MCMStyles

+ (MCMStyles *)sharedInstance {
    
    static dispatch_once_t once;
    static MCMStyles *_sharedInstance;
    dispatch_once(&once, ^ {
        _sharedInstance = [[MCMStyles alloc] init];
    });
    return _sharedInstance;

}

#pragma mark - Initializer

- (void)initWithPropertyList:(NSString *)propertyListName {
    
    self.defaultStylesPlistName = @"MCMStyles";

    if (propertyListName != nil) {
        self.customStylesPlistName = propertyListName;
    }
    
    self.stylesDictionary = [self loadStyles];
    
}

#pragma mark - Spacing

- (CGFloat)preferredSizeForHorizontalSpacing {

    NSNumber *styleValue = [self valueForKeys:@[kSpacing_Dictionary, kSpacing_horizontalPadding]];
    return styleValue.floatValue;

}

- (CGFloat)preferredSizeForVerticalSpacing {
    
    NSNumber *styleValue = [self valueForKeys:@[kSpacing_Dictionary, kSpacing_verticalPadding]];
    return styleValue.floatValue;

}

#pragma mark - Fonts

- (UIFont *)fontOfFloatSize:(CGFloat)size {
    
    NSString *styleValue = [self valueForKeys:@[kFont_Dictionary, kFont_Regular]];
    return [UIFont customFontOfSize:styleValue size:size];
    
}

- (UIFont *)boldFontOfFloatSize:(CGFloat)size {
    
    NSString *styleValue = [self valueForKeys:@[kFont_Dictionary, kFont_Bold]];
    return [UIFont customFontOfSize:styleValue size:size];

}

- (UIFont *)mediumFontOfFloatSize:(CGFloat)size {
    
    NSString *styleValue = [self valueForKeys:@[kFont_Dictionary, kFont_Medium]];
    return [UIFont customFontOfSize:styleValue size:size];

}

#pragma mark - Public Fonts

- (UIFont *)fontOfSize:(MCMTextSize)size {
    
    return [self fontOfFloatSize:[self textFontSize:size]];
    
}

- (UIFont *)boldFontOfSize:(MCMTextSize)size {
    
    return [self boldFontOfFloatSize:[self textFontSize:size]];
    
}

- (UIFont *)mediumFontOfSize:(MCMTextSize)size {
    
    return [self mediumFontOfFloatSize:[self textFontSize:size]];
    
}

#pragma mark - Controls colors

#pragma mark - UINavigationBar

- (UIColor *)moduleNavigationBarTintColor {
    
    return [self valueForKeys:@[MCM_Color_Dictionary_Key, kColor_NavigationBar_Dictionary, MCM_Color_Primary_Key]];

}

- (UIColor *)moduleNavigationBarTitleTextColor {

    return [self valueForKeys:@[MCM_Color_Dictionary_Key, MCM_Color_Secondary_Key]];

}

- (UIColor *)ordersModuleNavigationBarTintColor {

    return [self valueForKeys:@[MCM_Color_Dictionary_Key, kColor_NavigationBar_Dictionary, kColor_NavigationBar_MyOrders]];

}

#pragma mark - UIButton

- (UIColor *)buttonColor:(MCMStyleOption)styleOption {

    switch (styleOption) {
            
        case MCMStyleOptionPrimary:
            return [self valueForKeys:@[MCM_Color_Dictionary_Key, kColor_Button_Dictionary, MCM_Color_Primary_Key]];
            
        case MCMStyleOptionSecondary:
            return [self valueForKeys:@[MCM_Color_Dictionary_Key, kColor_Button_Dictionary, MCM_Color_Secondary_Key]];
            
        case MCMStyleOptionDefault:
        default:
            return [self valueForKeys:@[MCM_Color_Dictionary_Key, kColor_Button_Dictionary, MCM_Color_Alternative_Key]];
            
    }
}

- (UIColor *)disabledButtonColor {

    return [self valueForKeys:@[MCM_Color_Dictionary_Key, kColor_Button_Dictionary, kColor_Button_Disabled]];
   
}

#pragma mark - UIPageControl

+ (UIColor *)imageIndicatorColor {
    
    return [UIColor colorWithHexString:@"FECE13"];
    
}

#pragma mark - Background colors

- (UIColor *)backgroundColor:(MCMStyleOption)styleOption {
    
    switch (styleOption) {
            
        case MCMStyleOptionPrimary:
            return [self valueForKeys:@[MCM_Color_Dictionary_Key, kColor_Background_Dictionary, MCM_Color_Primary_Key]];
            
        case MCMStyleOptionSecondary:
            return [self valueForKeys:@[MCM_Color_Dictionary_Key, kColor_Background_Dictionary, MCM_Color_Secondary_Key]];
        
        case MCMStyleOptionDefault:
        default:
            return [self valueForKeys:@[MCM_Color_Dictionary_Key, kColor_Background_Dictionary, MCM_Color_Alternative_Key]];
    }

}

#pragma mark - Text colors

- (UIColor *)textColor:(MCMStyleOption)styleOption {
    
    switch (styleOption) {
            
        case MCMStyleOptionPrimary:
            return [self valueForKeys:@[MCM_Color_Dictionary_Key, kColor_Text_Dictionary, MCM_Color_Primary_Key]];
            
        case MCMStyleOptionSecondary:
            return [self valueForKeys:@[MCM_Color_Dictionary_Key, kColor_Text_Dictionary, MCM_Color_Secondary_Key]];
            
        case MCMStyleOptionDefault:
        default:
            return [self valueForKeys:@[MCM_Color_Dictionary_Key, kColor_Text_Dictionary, MCM_Color_Alternative_Key]];
    }
    
}

#pragma mark - Features colors

#pragma mark Product stock availability

- (UIColor *)textColorForStockAvailability:(MCMStockAvailabity)stockAvailabilty {

    switch (stockAvailabilty) {
            
        case MCMStockAvailabityInStock:
            return [self valueForKeys:@[MCM_Color_Dictionary_Key, kColor_Stock_Dictionary, kColor_Stock_InStock]];
            
        case MCMStockAvailabityLowStock:
            return [self valueForKeys:@[MCM_Color_Dictionary_Key, kColor_Stock_Dictionary, kColor_Stock_LowStock]];
            
        case MCMStockAvailabityOutOfStock:
        default:
            return [self valueForKeys:@[MCM_Color_Dictionary_Key, kColor_Stock_Dictionary, kColor_Stock_OutOfStock]];

    }
}

#pragma mark - Generic colors

-(UIColor *)priceRedColor {
    return [self valueForKeys:@[MCM_Color_Dictionary_Key, KColor_Price]];
}

+ (UIColor *)clearColor {
    
    return [UIColor clearColor];
    
}

- (UIColor *)errorColor {
    
    return [self valueForKeys:@[MCM_Color_Dictionary_Key, kColor_Error]];

}

- (UIColor *)borderColor {
    
    return [self valueForKeys:@[MCM_Color_Dictionary_Key, kColor_Border]];    
}

- (UIColor *)footerBackgroundColor {
    
    return [self valueForKeys:@[MCM_Color_Dictionary_Key, KColor_Footer_Background]];
}

- (UIColor *)primaryColor {
    return [self valueForKeys:@[MCM_Color_Dictionary_Key, MCM_Color_Primary_Key]];
}

#pragma mark - Scan pay

- (UIColor *)cardIoSightColor {
    
    return [self valueForKeys:@[MCM_Color_Dictionary_Key, kColor_CardIo_Dictionary, kColor_CardIo_Sight]];
    
}

- (UIColor *)cardIoButtonTitleColor {
    
    return [self valueForKeys:@[MCM_Color_Dictionary_Key, kColor_CardIo_Dictionary, kColor_CardIo_Title]];

}

#pragma mark - Cart

- (UIColor *)cartBriefFooterBackgroundColor {
    
    return [self valueForKeys:@[MCM_Color_Dictionary_Key, kColor_Cart_Dictionary, kColor_Cart_BottomBackground]];
    
}

- (UIColor *)cartBriefFooterTitleTextColor {

    return [self valueForKeys:@[MCM_Color_Dictionary_Key, kColor_Cart_Dictionary, kColor_Cart_BottomTitle]];
    
}

#pragma mark - Font sizes

- (CGFloat)textFontSize:(MCMTextSize)textSize {

    switch (textSize) {
            
        case MCMTextSize2XS: {
            NSNumber *styleValue = [self valueForKeys:@[kFontSize_Dictionary, kFontSize_2XS]];
            return styleValue.floatValue;
        }
        case MCMTextSizeXS: {
            NSNumber *styleValue = [self valueForKeys:@[kFontSize_Dictionary, kFontSize_XS]];
            return styleValue.floatValue;
        }
        case MCMTextSizeS: {
            NSNumber *styleValue = [self valueForKeys:@[kFontSize_Dictionary, kFontSize_S]];
            return styleValue.floatValue;
        }
        case MCMTextSizeM: {
            NSNumber *styleValue = [self valueForKeys:@[kFontSize_Dictionary, kFontSize_M]];
            return styleValue.floatValue;
        }
        case MCMTextSizeL: {
            NSNumber *styleValue = [self valueForKeys:@[kFontSize_Dictionary, kFontSize_L]];
            return styleValue.floatValue;
        }
        case MCMTextSizeXL: {
            NSNumber *styleValue = [self valueForKeys:@[kFontSize_Dictionary, kFontSize_XL]];
            return styleValue.floatValue;
        }
        case MCMTextSize2XL: {
            NSNumber *styleValue = [self valueForKeys:@[kFontSize_Dictionary, kFontSize_2XL]];
            return styleValue.floatValue;
        }
        case MCMTextSize3XL: {
            NSNumber *styleValue = [self valueForKeys:@[kFontSize_Dictionary, kFontSize_3XL]];
            return styleValue.floatValue;
        }
        default:
            return 14.f;

    }
    
}

@end

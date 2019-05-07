//
//  MCMStyles.h
//  laposteCommon
//
//  Created by Alberto Delgado on 09/02/16.
//  Copyright © 2016 DigitasLBi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#pragma mark - Enum definitions

/// Style Options
typedef enum : NSUInteger {
    MCMStyleOptionPrimary = 0, /// Primary style, i.e.: widely used throughout MCM UI setup // grey
    MCMStyleOptionSecondary, /// Secondary style // white
    MCMStyleOptionDefault, /// Ternary or alternative style. // black or yellow
    MCMStyleOptionLink // link Button
} MCMStyleOption;

/// Text sizes
typedef enum : NSUInteger {
    MCMTextSize2XS = 0,
    MCMTextSizeXS,
    MCMTextSizeS,
    MCMTextSizeM,
    MCMTextSizeL,
    MCMTextSizeXL,
    MCMTextSize2XL,
    MCMTextSize3XL
} MCMTextSize;

/// Product stock availabity
typedef enum : NSUInteger {
    MCMStockAvailabityInStock = 0, /// The product is available on stock
    MCMStockAvailabityLowStock, /// The product is available on stock but there are few items left
    MCMStockAvailabityOutOfStock /// The product is unavailable or out of stock
} MCMStockAvailabity;

#pragma mark - Constants definitions

extern NSString *const MCM_Color_Dictionary_Key;
extern NSString *const MCM_Color_Primary_Key;
extern NSString *const MCM_Color_Secondary_Key;
extern NSString *const MCM_Color_Alternative_Key;

@interface MCMStyles : NSObject

@property (readonly, nonatomic, strong) NSDictionary *stylesDictionary;
@property (readonly, nonatomic, strong) NSString *defaultStylesPlistName;
@property (readonly, nonatomic, strong) NSString *customStylesPlistName;

#pragma mark - Shared Instance

+ (MCMStyles *)sharedInstance;

#pragma mark - Initializer

- (void)initWithPropertyList:(NSString *)propertyListName;
    
#pragma mark - Spacing

/**
 Returns the default size for horizontal spacings, i.e.: <b>trailing</b> and <b>leading</b> margins.
 
 @return The standard size for vertical spacing.
 */
- (CGFloat)preferredSizeForHorizontalSpacing;

/**
 Returns the default size for vertical spacings, i.e.: <b>top</b> and <b>bottom</b> margins.
 
 @return The standard size for vertical spacing.
 */
- (CGFloat)preferredSizeForVerticalSpacing;

#pragma mark - Fonts

/**
 *  Returns the default @c UIFont with the provided size
 *
 *  @param size a MCMTextSize size
 *
 *  @return The sized default font
 */
- (UIFont *)fontOfSize:(MCMTextSize)size;

/**
 *  Returns the default bold weight @c UIFont with the provided size.
 *
 *  @param size  @c CGFloat value for the font's size.
 *
 *  @return The sized bold font.
 */
- (UIFont *)boldFontOfSize:(MCMTextSize)size;

/**
 *  Returns the default medium weigth @c UIFont with the provided size.
 *
 *  @param size @c CGFloat value for the font's size.
 *
 *  @return The sized medium font.
 */
- (UIFont *)mediumFontOfSize:(MCMTextSize)size;

#pragma mark - Controls colors

#pragma mark - UINavigationBar

/**
 Returns the app's navigation bar color for MCM.
 
 @return The navigation bar @c tintColor.
 */
- (UIColor *)moduleNavigationBarTintColor;

/**
 Returns the app's navigation bar title color for MCM.
 
 @return The color for the navigation bar's title.
 */
- (UIColor *)moduleNavigationBarTitleTextColor;

/**
 Returns the app's navigation bar color for the orders module.
 
 @return The navigation bar @c tintColor.
 */
- (UIColor *)ordersModuleNavigationBarTintColor;

#pragma mark - UIButton

- (UIColor *)buttonColor:(MCMStyleOption)styleOption;

- (UIColor *)disabledButtonColor;

#pragma mark - UIPageControl

+ (UIColor *)imageIndicatorColor;

#pragma mark - Background colors

- (UIColor *)backgroundColor:(MCMStyleOption)styleOption;

#pragma mark - Text colors

- (UIColor *)textColor:(MCMStyleOption)styleOption;

#pragma mark - Features colors

#pragma mark Product stock availability

- (UIColor *)textColorForStockAvailability:(MCMStockAvailabity)stockAvailabilty;

#pragma mark - Generic colors

-(UIColor *)priceRedColor;

+ (UIColor *)clearColor;

- (UIColor *)errorColor;

- (UIColor *)borderColor;

- (UIColor *)footerBackgroundColor;

- (UIColor *)primaryColor;


#pragma mark Scan pay

- (UIColor *)cardIoSightColor;

- (UIColor *)cardIoButtonTitleColor;

#pragma mark - Cart

- (UIColor *)cartBriefFooterBackgroundColor;

- (UIColor *)cartBriefFooterTitleTextColor;

- (CGFloat)textFontSize:(MCMTextSize)textSize;


@end

//
//  UIViewController+Hybris.h
//  laposteCommon
//
//  Created by Ricardo Suarez on 29/02/16.
//  Copyright © 2016 DigitasLBi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCMConstants.h"
#import "MCMManager.h"
#import "HYBCart.h"
#import "UIViewController+Navigation.h"
#import "UINavigationController+Laposte.h"


#import "MCMStyles.h"
#import "UIButton+MCMStyles.h"
#import "UILabel+MCMStyles.h"
#import "MCMImageHelper.h"
#import "MCMLocalizedStringHelper.h"

#import "HYBCache.h"
#import "HYBB2BService.h"
#import "HYBB2CService.h"

typedef NS_ENUM(NSInteger, HybrisNavigationBarStyle) {
    Yellow,
    DarkGrey
};

@interface UIViewController (Hybris)

@property __strong HYBCart* cart;

- (void)setupNavigationBar;
- (void) addBackButton;
- (void) addBlackBackButton;
- (void)addCloseButton;
- (void) showNoImplementedAlert;
- (UIView *)createViewWithTitle:(NSString *)title detail:(NSString *)detail isBold:(BOOL)isBold;
- (void)attachView:(UIView *)subView asSubviewOf:(UIView *)view belowView:(UIView *)topView withHeight:(CGFloat) height;
- (void)closeButtonClicked;
-(void) addLeftNavigationItems;
- (BOOL)isModal;
@end

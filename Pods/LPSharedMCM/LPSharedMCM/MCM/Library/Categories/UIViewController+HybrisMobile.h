//
//  UIViewController+HybrisMobile.h
//  laposte
//
//  Created by Ricardo Suarez on 16/12/15.
//  Copyright © 2015 laposte. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIViewController+Hybris.h"
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

@interface UIViewController (HybrisMobile)




- (void) addHomeButton;
- (void) homeButtonClick:(id) sender;
- (void) stablishNavigationHeaderWithStyle:(HybrisNavigationBarStyle) style;
- (void) closeButtonClicked;

- (void)transitionToCartViewFromCatalog:(id)sender;

@end

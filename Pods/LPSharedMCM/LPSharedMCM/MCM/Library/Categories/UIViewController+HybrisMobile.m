//
//  UIViewController+Hybris.m
//  laposte
//
//  Created by Ricardo Suarez on 16/12/15.
//  Copyright © 2015 laposte. All rights reserved.
//

#import "UIViewController+HybrisMobile.h"
#import "UINavigationController+Laposte.h"

#import "MCMManager.h"
#import "UIColor+HEXValue.h"
#import "MCMImageHelper.h"
#import "MCMConstants.h"
#import "MCMStyles.h"
#import "MCMDefine.h"


static NSString *const kCatalogScreenClassName          = @"MCMCatalogViewController";
static NSString *const kItemDetailScreenClassName       = @"MCMCatalogItemDetailViewController";
static NSString *const kCategoriesScreenClassName       = @"MCMCategoriesViewController";
static NSString *const kMyOrdersViewControllerClassName         = @"MCMMyOrdersViewController";
static NSString *const kMyOrderDetailViewControllerClassName    = @"MCMMyOrderDetailViewController";
@implementation UIViewController (HybrisMobile)

#pragma mark - Internal methods

- (UIColor *)getNavigationBarColorForStyle:(HybrisNavigationBarStyle) style {
    
    UIColor *result = [UIColor clearColor];
    switch (style) {
        case Yellow:
            result = [UIColor colorWithHexString:@"FECE13"];
            break;
        case DarkGrey:
            result = [UIColor colorWithHexString:@"73808B"];
            break;
        default:
            break;
    }
    
    return result;
}

- (UIColor *) getNavigationBarTextColorForStyle:(HybrisNavigationBarStyle) style {
    UIColor *result = [UIColor clearColor];
    switch (style) {
        case Yellow:
            result = [UIColor blackColor];
            break;
        case DarkGrey:
            result = [UIColor whiteColor];
            break;
        default:
            break;
    }
    
    return result;
}

#pragma mark - ---- PUBLIC

- (void) addHomeButton {
    UIButton *accountButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [accountButton setImage:[MCMImageHelper loadImageNamed:MCMHomeIcon] forState:UIControlStateNormal];
    [accountButton setFrame:CGRectMake(0, 0, 30, 30)];
    accountButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [accountButton addTarget:self action:@selector(homeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* accountItem = [[UIBarButtonItem alloc] initWithCustomView:accountButton];
    self.navigationItem.rightBarButtonItem = accountItem;
}

- (void)homeButtonClick:(id)sender {
    id<MCMTrackingProtocol> trackingDelegate = [[MCMManager sharedInstance] trackingDelegate];
    if([trackingDelegate respondsToSelector:@selector(trackHeaderAction:)]) {
        [trackingDelegate trackHeaderAction:@"home"];
    }
    [[[MCMManager sharedInstance] behaviourDelegate] navigateToRootViewController];
}


- (void)closeButtonClicked {
    
    id<MCMTrackingProtocol> trackingDelegate = [[MCMManager sharedInstance] trackingDelegate];
    if([trackingDelegate respondsToSelector:@selector(trackHeaderAction:)]) {
        [trackingDelegate trackHeaderAction:@"derniere_page"];
    }
    UIViewController *controller = nil;
    for (UIViewController *viewController in self.parentViewController.childViewControllers) {
        if (([viewController class] == NSClassFromString(kCatalogScreenClassName)) ||
            ([viewController class] == NSClassFromString(kItemDetailScreenClassName)) ||
            ([viewController class] == NSClassFromString(kCategoriesScreenClassName)) ) {
            if (!controller ||  (controller && [controller class] != NSClassFromString(kItemDetailScreenClassName))) {
                controller = viewController;
            }
        }
    }

    if (controller) {
        [self.navigationController popToViewControllerRetro:controller ];
    }
    else {
        if (([self class] == NSClassFromString(kMyOrdersViewControllerClassName) || [self class] == NSClassFromString(kMyOrderDetailViewControllerClassName))) {
            if ([self isModal]) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            else {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        else {
            for (UIViewController *viewController in [self.navigationController viewControllers]) {
                [viewController dismissViewControllerAnimated:YES completion:nil];
            }
        }
    }
}



- (void)stablishNavigationHeaderWithStyle:(HybrisNavigationBarStyle)style {
}

#pragma mark - UIViewController


@end

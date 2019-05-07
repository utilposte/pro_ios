//
//  UINavigationController+Laposte.h
//  laposte
//
//  Created by IOS Developer on 3/4/14.
//  Copyright (c) 2014 laposte. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController(Laposte)

/**
 *  Push view with animate from bottom
 *
 *  @param viewController
 */
- (void)pushViewControllerRetro:(UIViewController *)viewController;

/**
 *  Pop view with animate from top
 */
- (void)popViewControllerRetro;

/**
 *  Pop to view with animate from top
 */
- (void)popToViewControllerRetro:(UIViewController *) viewController;
@end

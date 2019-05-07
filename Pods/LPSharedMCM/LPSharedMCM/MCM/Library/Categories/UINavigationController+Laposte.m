//
//  UINavigationController+Laposte.m
//  laposte
//
//  Created by IOS Developer on 3/4/14.
//  Copyright (c) 2014 laposte. All rights reserved.
//

#import "UINavigationController+Laposte.h"

@implementation UINavigationController(Laposte)


- (void)pushViewControllerRetro:(UIViewController *)viewController {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromTop;
    [self.view.layer addAnimation:transition forKey:nil];
    
    [self pushViewController:viewController animated:YES];
}

- (void)popViewControllerRetro {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromBottom;
    [self.view.layer addAnimation:transition forKey:nil];
    
    [self popViewControllerAnimated:YES];
}

- (void)popToViewControllerRetro:(UIViewController *) viewController
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.view.layer addAnimation:transition forKey:nil];
    
    [self popToViewController:viewController animated:YES];
}
@end

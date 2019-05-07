//
//  UINavigationController+popToClass.m
//  laposteCommon
//
//  Created by Hobart Wong on 26/02/2016.
//  Copyright © 2016 DigitasLBi. All rights reserved.
//

#import "UINavigationController+popToClass.h"

@implementation UINavigationController (popToClass)

- (void)popToClass:(Class)class animated:(BOOL)animated {
    
    NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[self viewControllers]];
    for (UIViewController *aViewController in allViewControllers) {
        if ([aViewController isKindOfClass:class]) {
            [self popToViewController:aViewController animated:animated];
            return;
        }
    }
}

@end

//
//  UIViewController+Navigation.m
// [y] hybris Platform
//
// Copyright (c) 2000-2015 hybris AG
// All rights reserved.
//
// This software is the confidential and proprietary information of hybris
// ("Confidential Information"). You shall not disclose such Confidential
// Information and shall use it only in accordance with the terms of the
// license agreement you entered into with hybris.

#import "UIViewController+Navigation.h"

@implementation UIViewController (Navigation)


//toast message
#pragma mark User Notifications and Alerts

- (OLGhostAlertView *)createUserNotifier {
    OLGhostAlertView *notifier = [[OLGhostAlertView alloc] init];
    notifier.timeout = 1.5;
    notifier.style = OLGhostAlertViewStyleDark;
    notifier.position = OLGhostAlertViewPositionCenter;
    notifier.dismissible = YES;
    
    int count = 0;
    
    for (UIView *view in [notifier subviews]) {
        view.accessibilityIdentifier = [NSString stringWithFormat:@"ACCESS_NOTIFIER_%d", count++];
    }
    
    return notifier;
}

- (void)showAlertMessage:(NSString *)message withTitle:(NSString *)title cancelButtonText:(NSString *)cancelButtonText {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:cancelButtonText
                                          otherButtonTitles:nil];
    
    alert.accessibilityIdentifier = @"MESSAGE_POPUP_WINDOW";
    
    [alert show];
}

- (void)showNotifyMessage:(NSString *)msg {
    OLGhostAlertView *notifier = [self createUserNotifier];
    notifier.title = msg;
    [notifier show];
}

@end

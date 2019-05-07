//
//  UIViewController+Navigation.h
// [y] hybris Platform
//
// Copyright (c) 2000-2015 hybris AG
// All rights reserved.
//
// This software is the confidential and proprietary information of hybris
// ("Confidential Information"). You shall not disclose such Confidential
// Information and shall use it only in accordance with the terms of the
// license agreement you entered into with hybris.

#import <UIKit/UIKit.h>
#import <OLGhostAlertView/OLGhostAlertView.h>

#define  TAG_MASK_VIEW             9999999
#define  TAG_LOCATION_ALERT        9911199


@interface UIViewController (Navigation) <UIAlertViewDelegate>


//toast message
- (void)showAlertMessage:(NSString *)message withTitle:(NSString *)title cancelButtonText:(NSString *)cancelButtonText;
- (void)showNotifyMessage:(NSString *)msg;

@end

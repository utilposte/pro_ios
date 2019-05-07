//
//  UIAlertController+Helper.m
//  MCommerce
//
//  Created by Jerilyn Goncalves Figueira on 05/09/16.
//  Copyright © 2016 DigitasLBi. All rights reserved.
//

#import "UIAlertController+Helper.h"

@implementation UIAlertController (Helper)

+ (UIAlertController *)alertControllerWithTitle:(NSString *)alertTitle message:(NSString *)alertMessage dismissActionTitle:(NSString *)dismissActionTitle dismissActionBlock:(void (^)(void))dismissActionBlock {

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertTitle
                                                                             message:alertMessage
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *dismissAlertAction = [UIAlertAction actionWithTitle:dismissActionTitle
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction *action){
                                                                   dismissActionBlock();
                                                               }];
    [alertController addAction:dismissAlertAction];
    return alertController;
    
}

@end
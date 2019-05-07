//
//  UIAlertController+Helper.h
//  MCommerce
//
//  Created by Jerilyn Goncalves Figueira on 05/09/16.
//  Copyright © 2016 DigitasLBi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (Helper)

+ (UIAlertController *)alertControllerWithTitle:(NSString *)alertTitle
                                        message:(NSString *)alertMessage
                             dismissActionTitle:(NSString *)dismissActionTitle
                             dismissActionBlock:(void (^)(void))dismissActionBlock;

@end

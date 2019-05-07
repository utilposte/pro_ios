//
//  UIButton+MCMStyles.h
//  laposte
//
//  Created by Jerilyn Goncalves Figueira on 29/07/16.
//  Copyright © 2016 laposte. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCMStyles.h"

@interface UIButton (MCMStyles)

/**
 *  Customises a UIButton following styles in the MCMStyles class
 *
 *  @param title       the title the button will show
 *  @param styleOption A style option to choose: Primary, Secondary or Default
 */
- (void)customiseButtonWithTitle:(NSString *)title option:(MCMStyleOption)styleOption;
- (void)customiseLinkButtonWithTitle:(NSString *)title;

@end

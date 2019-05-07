//
//  UILabel+layout.m
//  laposte
//
//  Created by Hobart Wong on 29/02/2016.
//  Copyright © 2016 laposte. All rights reserved.
//

#import "UILabel+Layout.h"

@implementation UILabel (Layout)

- (void)layoutSubviews {
    [super layoutSubviews];
    self.preferredMaxLayoutWidth = self.frame.size.width;
}

@end

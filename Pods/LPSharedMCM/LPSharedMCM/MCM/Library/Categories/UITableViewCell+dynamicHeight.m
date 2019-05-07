//
//  UITableViewCell+dynamicHeight.m
//  laposte
//
//  Created by Hobart Wong on 01/03/2016.
//  Copyright © 2016 laposte. All rights reserved.
//

#import "UITableViewCell+dynamicHeight.h"
#import "MCMDefine.h"

@implementation UITableViewCell (dynamicHeight)

- (CGFloat)heightForCell {
    
    return [self.contentView systemLayoutSizeFittingSize:UILayoutFittingExpandedSize].height;

}

@end

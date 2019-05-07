//
//  UITableViewCell+Identifier.m
//  laposte
//
//  Created by Hobart Wong on 23/06/2016.
//  Copyright © 2016 laposte. All rights reserved.
//

#import "UITableViewCell+ReuseIdentifier.h"
#import "MCMBundleHelper.h"

@implementation UITableViewCell (ReuseIdentifier)

+ (NSString *)reuseIdentifier {
    
    return NSStringFromClass([self class]);
}

+ (UINib *)nib {
    
    return [UINib nibWithNibName:NSStringFromClass([self class]) bundle:[MCMBundleHelper moduleBundle]];
}

@end

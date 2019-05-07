//
//  UITableViewCell+Identifier.h
//  laposte
//
//  Created by Hobart Wong on 23/06/2016.
//  Copyright © 2016 laposte. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (Identifier)

+ (NSString *)reuseIdentifier;
+ (UINib *)nib;

@end

//
//  MCMImageHelper.h
//  laposte
//
//  Created by Jerilyn Goncalves Figueira on 12/08/16.
//  Copyright © 2016 laposte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MCMImageNames.h"

@interface MCMImageHelper : NSObject

+ (UIImage *)loadImageNamed:(NSString *)imageName;

@end

//
//  MCMImageHelper.m
//  laposte
//
//  Created by Jerilyn Goncalves Figueira on 12/08/16.
//  Copyright © 2016 laposte. All rights reserved.
//

#import "MCMImageHelper.h"
#import "MCMBundleHelper.h"

@implementation MCMImageHelper

+ (UIImage *)loadImageNamed:(NSString *)imageName {

    if (imageName) {
           
        UIImage *image = [UIImage imageNamed:imageName inBundle:[MCMBundleHelper moduleBundle] compatibleWithTraitCollection:nil];
        return image;
    }
    
    return nil;

}

@end

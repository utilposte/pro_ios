//
//  UIViewController+HybrisImageService.m
//  laposteCommon
//
//  Created by Ricardo Suarez on 05/05/16.
//  Copyright © 2016 DigitasLBi. All rights reserved.
//

#import "UIViewController+HybrisImageService.h"

#import "HYBB2CServiceWrapper.h"
#import "HYBB2CService.h"

@implementation UIViewController (HybrisImageService)

- (void) loadImageByUrl:(NSString *)url andExecute:(void(^)(UIImage *fetchedImage, NSError *error))block {
    [[[HYBB2CServiceWrapper sharedInstance] backEndService] loadImageByUrl:url andExecute:^(UIImage *image, NSError *error) {
        block(image, error);
    }];
}

@end

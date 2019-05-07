//
//  UIViewController+HybrisImageService.h
//  laposteCommon
//
//  Created by Ricardo Suarez on 05/05/16.
//  Copyright © 2016 DigitasLBi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (HybrisImageService)

- (void) loadImageByUrl:(NSString *)url andExecute:(void(^)(UIImage *fetchedImage, NSError *error))block;

@end

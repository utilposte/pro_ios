//
//  MCMLoadingManager.m
//  laposte
//
//  Created by Ricardo Suarez on 27/07/16.
//  Copyright © 2016 laposte. All rights reserved.
//

#import "MCMLoadingManager.h"
#import "MCMManager.h"

@implementation MCMLoadingManager

#pragma mark - ---- LIFE CICLE

+ (id) sharedInstance {
    static MCMLoadingManager *sharedWrapper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedWrapper = [[self alloc] init];
    });
    return  sharedWrapper;
}


#pragma mark - ---- PUBLIC

- (void)showLoading {
    [_delegate show];
    [[MCMManager sharedInstance].delegate showHideLoader:YES];
}

- (void) hideLoading {
    [[MCMManager sharedInstance].delegate showHideLoader:NO];
    [_delegate hide];
}

@end

//
//  MCMLoadingManager.h
//  laposte
//
//  Created by Ricardo Suarez on 27/07/16.
//  Copyright © 2016 laposte. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCMLoaderProtocol.h"

@interface MCMLoadingManager : NSObject

@property(assign, nonatomic) id<MCMLoaderProtocol> delegate;

+ (id) sharedInstance;

- (instancetype) init __attribute__((unavailable("init not available")));

/*
 *  Show the loading view matching device screen size
 */
- (void) showLoading;

/*
 *  Hide the loading view
 */
- (void) hideLoading;

@end

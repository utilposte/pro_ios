//
//  MCMViewControllerProtocol.h
//  laposte
//
//  Created by Hobart Wong on 15/06/2016.
//  Copyright © 2016 laposte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCMActionProtocol.h"

@protocol MCMViewControllerProtocol <NSObject>

@property (nonatomic, strong) id data;
@property (nonatomic, weak) id<MCMActionProtocol> actionDelegate;
- (void)showError:(NSError *)error;
- (void)initializeInterface;
- (void)trackPageID:(NSString *)pageID withLevel:(NSString *)level;

@end

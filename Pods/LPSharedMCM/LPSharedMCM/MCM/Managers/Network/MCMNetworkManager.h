//
//  MCMNetworkManager.h
//  laposte
//
//  Created by Matthieu Lemonnier on 27/02/2018.
//  Copyright © 2018 laposte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYBB2CService.h"
#import "HYBB2CServiceWrapper.h"
#import "LPNetworkError.h"

@interface MCMNetworkManager : NSObject


+ (id)sharedManager;

+ (BOOL) checkIsNoConnectionError:(NSError *) error;
- (LPNetworkError *)prepareNetworkRequest;
- (LPNetworkError *) manageNetworkError:(NSError *)error;

@end

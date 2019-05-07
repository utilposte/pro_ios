//
//  MCMNetworkManager.m
//  laposte
//
//  Created by Matthieu Lemonnier on 27/02/2018.
//  Copyright © 2018 laposte. All rights reserved.
//

#import "MCMNetworkManager.h"
#import "MCMLoadingManager.h"
#import "MCMManager.h"
#import "MCMLocalizedStringHelper.h"
#import "MCMTrackingNetworkProtocol.h"
#import "UIAlertController+Helper.h"

@interface MCMNetworkManager()


@end


@implementation MCMNetworkManager

+ (id)sharedManager {
    static MCMNetworkManager *sharedMyManager = nil;
    @synchronized(self) {
        if (sharedMyManager == nil){
            sharedMyManager = [[self alloc] init];
        }
    }
    return sharedMyManager;
}

- (LPNetworkError *) manageNetworkError:(NSError *)error {
    LPNetworkError* nError = [[LPNetworkError alloc] initWithError:error];
    if ([[error localizedDescription] rangeOfString:@"401"].location != NSNotFound) {
        [[MCMManager sharedInstance] eraseUserCredentials];
        nError.type = authorization;
        return nError;
    }
    nError.type = unknown;
    return nError;
}

- (LPNetworkError *)prepareNetworkRequest;
{
    LPNetworkError * error = [[LPNetworkError alloc] init];
    error.type = noConnection;
    error.error = [[NSError alloc] init];
    
    if ([self isNetworkAvailable]) {
        return nil;
    } else {
        [[MCMLoadingManager sharedInstance] hideLoading];
        return error;
    }
    return nil;
}

- (BOOL)isNetworkAvailable {
    return [[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus]
    != AFNetworkReachabilityStatusNotReachable;
}

+ (BOOL) checkIsNoConnectionError:(NSError *) error {
    return error.code == -1011;
}

@end

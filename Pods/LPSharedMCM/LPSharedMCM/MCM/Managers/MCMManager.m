
//  MCMManager.m
//  laposte
//
//  Created by Ricardo Suarez on 05/08/16.
//  Copyright © 2016 laposte. All rights reserved.
//

#import "MCMManager.h"

#import "MCMUser.h"
#import "HYBB2CService.h"
#import "HYBB2CServiceWrapper.h"
#import "MCMStoryboardHelper.h"
#import "MCMStyles.h"
// TODO ISO
#import "REXInfoToSend.h"

@interface MCMManager ()

@property (nonatomic, strong) MCMUser *sharedUserAccount;
@property (nonatomic, weak) id<MCMBehaviourDelegate> behaviourDelegate;
@property (nonatomic, weak) id<MCMTrackingProtocol> trackingDelegate;
@property (nonatomic, strong) NSString *stylesPropertyListName;
@property (nonatomic, strong) NSString *environmentPropertyListName;

@end

@implementation MCMManager

#pragma mark - Singleton

+ (MCMManager *)sharedInstance {
    static MCMManager *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return  shared;
}

#pragma mark - Private methods

- (void)setAccessTokenToHybris:(NSDictionary *) values {
    HYBB2CService *backEndService = [[HYBB2CServiceWrapper sharedInstance] backEndService];
    if (values) {
        [backEndService setUserInfoWithCCUToken:self.sharedUserAccount.completeAccessToken username:self.sharedUserAccount.email];
    } else {
        [backEndService logoutCurrentUser];
    }
}

#pragma mark - Initialization

- (void)initWithEnvironmentPlist:(NSString * _Nullable)environmentPlistName
                     stylesPlist:(NSString * _Nullable)stylesPlistName
               behaviourDelegate:(id<MCMBehaviourDelegate> _Nonnull)behaviourDelegate
                trackingDelegate:(id<MCMTrackingProtocol> _Nullable)trackingDelegate {
    
    self.behaviourDelegate = behaviourDelegate;
    self.trackingDelegate = trackingDelegate;
    self.environmentPropertyListName = environmentPlistName;
    self.stylesPropertyListName = stylesPlistName;
    
    // Init styles
    [[MCMStyles sharedInstance] initWithPropertyList:self.stylesPropertyListName];
    
    // Init Hybris
    /*if (self.environmentPropertyListName) {
        NSString *configuration = [NSString stringWithFormat:@"%@.plist", self.environmentPropertyListName];
        [HYBB2CServiceWrapper sharedInstanceWithConfiguration:configuration];
    } else {
        [HYBB2CServiceWrapper sharedInstanceWithConfiguration:nil];
    }*/
    
    
    // Init Hybris
    NSString *hybrisServiceHost = [[MCMManager sharedInstance].delegate getHybrisServiceHost];
    if (self.environmentPropertyListName) {
        NSString *configuration = [NSString stringWithFormat:@"%@.plist", self.environmentPropertyListName];
        [HYBB2CServiceWrapper sharedInstanceWithConfiguration:configuration andHost:hybrisServiceHost];
    } else {
        [HYBB2CServiceWrapper sharedInstanceWithConfiguration:nil andHost:hybrisServiceHost];
    }

}

#pragma mark - Public methods

- (void)setUserCredentials:(NSDictionary *)values {
    
    self.sharedUserAccount = [[MCMUser alloc] initWithValues:values];
    [self setAccessTokenToHybris:values];
}

- (void)eraseUserCredentials {
    
    self.sharedUserAccount = nil;
    [self setAccessTokenToHybris:nil];
    
    // TODO ISO    
    [REXInfoToSend resetSharedInstance];
}

- (MCMUser *)user {
    
    return self.sharedUserAccount;
}

- (UIViewController *)getCatalogFlowController {
    
    return [[MCMStoryboardHelper storyboard] instantiateInitialViewController];
}



- (UIViewController *)getMyOrdersFlowController {
    
    return [[MCMStoryboardHelper storyboard] instantiateViewControllerWithIdentifier:@"MCMMyOrdersViewController"];
    
}

- (UIViewController *)getHistoryOrdersFlowController {
    
    return [[MCMStoryboardHelper storyboard] instantiateViewControllerWithIdentifier:@"MCMCommandViewController"];
}

- (BOOL)haveGoalProduct:(NSArray *)entries {
    for (HYBOrderEntry *entry in entries) {
        if ([entry.product.code isEqualToString:@"goalProduct"]) {
            return YES;
        }
    }
    return NO;
}

@end

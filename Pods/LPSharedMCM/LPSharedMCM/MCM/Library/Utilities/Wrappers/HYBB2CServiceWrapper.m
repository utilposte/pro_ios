//
//  HYBB2CServiceWrapper.m
//  laposteCommon
//
//  Created by Ricardo Suarez on 15/12/15.
//  Copyright © 2015 DigitasLBi. All rights reserved.
//

#import "HYBB2CServiceWrapper.h"

#import "HYBB2CService.h"
#import "MYEnvironmentConfig.h"
#import "MCMBundleHelper.h"

#import "MCMManager.h"

/// Produ environment.
NSString *const kHYBB2CServiceWrapper_Default_Configuration = @"Environments_Hybris.plist";
/// Pre-prod environment.
//NSString *const kHYBB2CServiceWrapper_Default_Configuration = @"Environments_Hybris_PreProd.plist";

@interface HYBB2CServiceWrapper ()

//@property (nonatomic, strong) HYBB2CService *backEndService;

@end

@implementation HYBB2CServiceWrapper

#pragma mark - ---- LIFE CICLE

+ (id)sharedInstance {
    NSString *hybrisServiceHost = [[MCMManager sharedInstance].delegate getHybrisServiceHost];
    return [HYBB2CServiceWrapper sharedInstanceWithConfiguration:kHYBB2CServiceWrapper_Default_Configuration andHost:hybrisServiceHost];
}

+ (id)sharedInstanceWithConfiguration:(NSString *)configuration {
    
    static HYBB2CServiceWrapper *sharedWrapper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedWrapper = [[self alloc] init];
        
        // Set B2C Backend
        // Config Environment
        if (configuration) {
            [MYEnvironmentConfig initSharedConfigWithPList:configuration];
        } else {
            MYEnvironmentConfig *config = [[MYEnvironmentConfig alloc] initWithPList:kHYBB2CServiceWrapper_Default_Configuration environmentKey:nil defaultConfigKey:nil resourceBundle:[MCMBundleHelper moduleBundle]];
            [MYEnvironmentConfig setSharedConfig:config];
        }
        
        sharedWrapper.backEndService = [[HYBB2CService alloc] initWithDefaults];
        [sharedWrapper.backEndService loadSettings];
            NSString *hybrisServiceHost = [[MCMManager sharedInstance].delegate getHybrisServiceHost];
        sharedWrapper.backEndService.backEndHost = hybrisServiceHost;
    });
    return  sharedWrapper;
}


+ (id)sharedInstanceWithConfiguration:(NSString *)configuration andHost:(NSString *)hostUrl {
    
    static HYBB2CServiceWrapper *sharedWrapper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedWrapper = [[self alloc] init];
        
        // Set B2C Backend
        // Config Environment
        if (configuration) {
            [MYEnvironmentConfig initSharedConfigWithPList:configuration];
        } else {
            MYEnvironmentConfig *config = [[MYEnvironmentConfig alloc] initWithPList:kHYBB2CServiceWrapper_Default_Configuration environmentKey:nil defaultConfigKey:nil resourceBundle:[MCMBundleHelper moduleBundle]];
            [MYEnvironmentConfig setSharedConfig:config];
        }
        
        sharedWrapper.backEndService = [[HYBB2CService alloc] initWithDefaults];
        [sharedWrapper.backEndService loadSettings];
        sharedWrapper.backEndService.backEndHost = hostUrl;
    });
    return  sharedWrapper;
}


#pragma mark - ---- INTERNAL

#pragma mark - ---- PUBLIC



@end

//
//  HYBB2CServiceWrapper.h
//  laposteCommon
//
//  Created by Ricardo Suarez on 15/12/15.
//  Copyright © 2015 DigitasLBi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HYBB2CService.h"

@interface HYBB2CServiceWrapper : NSObject

+ (id) sharedInstance;
+ (id) sharedInstanceWithConfiguration:(NSString *) configuration;
+ (id) sharedInstanceWithConfiguration:(NSString *)configuration andHost:(NSString *)hostUrl;

- (instancetype) init __attribute__((unavailable("init not available")));

@property (nonatomic, strong) HYBB2CService *backEndService;

@end

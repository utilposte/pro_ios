//
//  HYBRestManager.m
// [y] hybris Platform
//
// Copyright (c) 2000-2015 hybris AG
// All rights reserved.
//
// This software is the confidential and proprietary information of hybris
// ("Confidential Information"). You shall not disclose such Confidential
// Information and shall use it only in accordance with the terms of the
// license agreement you entered into with hybris.
//

#import "HYBRestManager.h"
#import "HYBConstants.h"
#import "DDLog.h"
#import "MCMManager.h"


@interface HYBRestManager ()

@property(nonatomic) AFHTTPRequestOperationManager *restManager;

@end

@implementation HYBRestManager

#pragma mark --

- (instancetype)init  {
    
    if(self = [super init]) {
        _restManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:nil];
        [self setUpDefaultAppHeader];
    }
    
    return self;
}

- (void)injectAuthorizationHeader:(NSString*)authorizationHeader {
    
    if(_restManager) {
        DDLogDebug(@"injectAuthorizationHeader %@",authorizationHeader);
        [_restManager.requestSerializer setValue:authorizationHeader forHTTPHeaderField:@"Authorization"];
        
        AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
#ifdef DEBUG
        policy.allowInvalidCertificates = YES;
#endif
        _restManager.securityPolicy = policy;
    } else {
        DDLogDebug(@"!!! RestEngine not set !!!");
    }
}


- (void)injectHeaderValue:(NSString *)value forKey:(NSString *)key {
    if(_restManager) {
        DDLogDebug(@"injectKeyHeader %@",value);
//        if ([_restManager.requestSerializer valueForKey:key] == nil) return;
        [_restManager.requestSerializer setValue:value forHTTPHeaderField:key];
        
        AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
#ifdef DEBUG
        policy.allowInvalidCertificates = YES;
#endif
        _restManager.securityPolicy = policy;
    } else {
        DDLogDebug(@"!!! RestEngine not set !!!");
    }
}
- (void)discardAuthorizationHeader {
    
    if(_restManager) {
        DDLogDebug(@"discardAuthorizationHeader");
        [_restManager.requestSerializer clearAuthorizationHeader];
        [self setUpDefaultAppHeader];
    } else {
        DDLogDebug(@"!!! RestEngine not set !!!");
    }
}

- (void)setUpDefaultAppHeader {
    MCMManager *manager = [MCMManager sharedInstance];
    if (manager.delegate && [manager.delegate respondsToSelector:@selector(getAppHeaderName)]) {
        NSString *appName = [manager.delegate getAppHeaderName];
        if (appName == nil) return;
        [_restManager.requestSerializer setValue:appName forHTTPHeaderField:@"App_NAME"];
    }
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    [_restManager.requestSerializer setValue:systemVersion forHTTPHeaderField:@"App_OS"];
    
    NSString *model = [[UIDevice currentDevice] model];
    [_restManager.requestSerializer setValue:model forHTTPHeaderField:@"App_PHONE"];
    
    NSString *appVersion = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
    if (appVersion) [_restManager.requestSerializer setValue:appVersion forHTTPHeaderField:@"App_VERSION"];
}

#pragma mark REST shortcuts

- (void)GET:(NSString*)url
    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    [self GET:url withParams:nil success:success failure:failure];
}

- (void)GET:(NSString*)url withParams:(NSDictionary*)params
    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    DDLogDebug(@"url %@",url);
    if(params) DDLogDebug(@"params %@",[params description]);
    
    //set expected response to JSON
    [_restManager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    
    [_restManager GET:url
           parameters:params
              success:success
              failure:failure];
}

- (void)GETIMAGE:(NSString*)url
    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    [self GETIMAGE:url withParams:nil success:success failure:failure];
}

- (void)GETIMAGE:(NSString*)url withParams:(NSDictionary*)params
    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    DDLogDebug(@"url %@",url);
    if(params) DDLogDebug(@"params %@",[params description]);
    
    [_restManager setResponseSerializer:[AFImageResponseSerializer serializer]];

    [_restManager GET:url
           parameters:params
              success:success
              failure:failure];
}

- (void)GETPDF:(NSString*)url
       success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    //set expected response to JSON
    [_restManager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableSet *acceptableContentTypes = [NSMutableSet setWithSet:responseSerializer.acceptableContentTypes];
    [acceptableContentTypes addObject:@"application/pdf"];
    [acceptableContentTypes addObject:@"text/html"];
    responseSerializer.acceptableContentTypes = acceptableContentTypes;
    [_restManager setResponseSerializer:responseSerializer];
    
    [_restManager GET:url
           parameters:nil
              success:success
              failure:failure];
}

- (void)POST:(NSString*)url
     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    [self POST:url withParams:nil success:success failure:failure];

}

- (void)POST:(NSString*)url withParams:(NSDictionary*)params
     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    DDLogDebug(@"url %@",url);
    if(params) DDLogDebug(@"params %@",[params description]);
    
    //set expected response to JSON
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
    NSMutableSet *acceptableContentTypes = [NSMutableSet setWithSet:responseSerializer.acceptableContentTypes];
    [acceptableContentTypes addObject:@"text/plain"];
    responseSerializer.acceptableContentTypes = acceptableContentTypes;
    [_restManager setResponseSerializer:responseSerializer];
    
    [_restManager POST:url
           parameters:params
              success:success
              failure:failure];
}

- (void)DELETE:(NSString*)url
       success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    [self DELETE:url withParams:nil success:success failure:failure];
}

- (void)DELETE:(NSString*)url withParams:(NSDictionary*)params
       success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    DDLogDebug(@"url %@",url);
    if(params) DDLogDebug(@"params %@",[params description]);
    
    //set expected response to JSON
    [_restManager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    
    [_restManager DELETE:url
            parameters:params
               success:success
               failure:failure];
}

- (void)PATCH:(NSString*)url
      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    [self PATCH:url withParams:nil success:success failure:failure];
}

- (void)PATCH:(NSString*)url withParams:(NSDictionary*)params
      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    DDLogDebug(@"url %@",url);
    if(params) DDLogDebug(@"params %@",[params description]);
    
    //set expected response to JSON
    [_restManager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    
    [_restManager PATCH:url
              parameters:params
                 success:success
                 failure:failure];
}

- (void)PUT:(NSString*)url
    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    [self PUT:url withParams:nil success:success failure:failure];
}

- (void)PUT:(NSString*)url withParams:(NSDictionary*)params
    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    DDLogDebug(@"url %@",url);    
    if(params) DDLogDebug(@"params %@",[params description]);
    
    //set expected response to JSON
    [_restManager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    
    [_restManager PUT:url
             parameters:params
                success:success
                failure:failure];
}

- (void)HEAD:(NSString*)url
    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    [self HEAD:url withParams:nil success:success failure:failure];
}

- (void)HEAD:(NSString*)url withParams:(NSDictionary*)params
    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    DDLogDebug(@"url %@",url);
    if(params) DDLogDebug(@"params %@",[params description]);
    
    //set expected response to JSON
    [_restManager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    
    [_restManager HEAD:url
           parameters:params
               success:^(AFHTTPRequestOperation *operation) {
                   success(operation, operation.responseObject);
               }
              failure:failure];
}

/// Refactoring

- (void)url:(NSString*)url
    request:(NSMutableURLRequest *) request
    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSString *token = _restManager.requestSerializer.HTTPRequestHeaders[@"Authorization"];
    [request addValue:token forHTTPHeaderField:@"Authorization"];
    
    //set expected response to JSON
    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableSet *acceptableContentTypes = [NSMutableSet setWithSet:responseSerializer.acceptableContentTypes];
    [acceptableContentTypes addObject:@"application/json"];
//    [acceptableContentTypes addObject:@"text/html"];
    responseSerializer.acceptableContentTypes = acceptableContentTypes;
    [_restManager setResponseSerializer:responseSerializer];
    
    AFHTTPRequestOperation *operation = [_restManager HTTPRequestOperationWithRequest:request
                                                                              success: success
                                                                              failure:failure];
    
    [_restManager.operationQueue addOperation:operation];
}

/// End Refactoring



@end

//
//  HYBRestManager.h
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

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@interface HYBRestManager : NSObject

- (void)injectAuthorizationHeader:(NSString*)authorizationHeader;
- (void)injectHeaderValue:(NSString *)value forKey:(NSString *)key;

- (void)discardAuthorizationHeader;

- (void)GET:(NSString*)url
    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)GET:(NSString*)url
 withParams:(NSDictionary*)params
    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)GETIMAGE:(NSString*)url
         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)GETIMAGE:(NSString*)url
      withParams:(NSDictionary*)params
         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)GETPDF:(NSString*)url
       success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)POST:(NSString*)url
     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)POST:(NSString*)url
  withParams:(NSDictionary*)params
     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)DELETE:(NSString*)url
       success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)DELETE:(NSString*)url
    withParams:(NSDictionary*)params
       success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)PATCH:(NSString*)url
      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)PATCH:(NSString*)url
   withParams:(NSDictionary*)params
      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)PUT:(NSString*)url
    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)PUT:(NSString*)url
 withParams:(NSDictionary*)params
    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)HEAD:(NSString*)url
     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)HEAD:(NSString*)url
  withParams:(NSDictionary*)params
     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)url:(NSString*)url
    request:(NSMutableURLRequest *) request
    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


@end

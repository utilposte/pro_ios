//
//  HYBB2CService+ReexServices.m
//  laposte
//
//  Created by Issam DAHECH on 23/03/2018.
//  Copyright © 2018 laposte. All rights reserved.
//

#import "HYBB2CService+ReexServices.h"
#import "MCMLoadingManager.h"

@implementation HYBB2CService (ReexServices)

- (void)addToCart:(NSMutableDictionary *)params forUser:(NSString *) userMail andIsNational:(BOOL) isNational andIsDefinitif:(BOOL)isDefinitif withCompletion:(void (^)(id responseObject,  NSError* error)) completion {
    NSString *url = [self urlAddToCartNational:isNational Definitif:isDefinitif forUser:userMail];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest* request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:nil error:NULL];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self.restEngine url:url request:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(operation ,error);
    }];
}



- (void)getPriceForContractFrom:(NSString *)beginDate to:(NSString *)endDate isNational:(BOOL) isNational
                andSuccessBlock:(void (^)(BOOL isSuccess, id result)) success
                   andFailBlock:(void (^)(AFHTTPRequestOperation *operation, NSError* error)) fail {
    NSString * url = [self getPriceForContractNational:isNational];
    NSDictionary* URLParameters = @{@"dateDebut":beginDate,
                                    @"dateFin": endDate};
    
    [self.restEngine GET:url withParams:URLParameters
                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                     NSError *error;
                     NSDictionary *JSONDictionary = (NSDictionary *)responseObject;
                     if (!error && JSONDictionary) {
                         success(YES, JSONDictionary);
                     } else {
                         success(NO, JSONDictionary);
                     }
                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     NSLog(@"HTTP Request failed: %@", error);
                     fail(operation ,error);
                 }];
}

- (void)getInitReexWithType:(NSString *)reexType
            andSuccessBlock:(void (^)(BOOL isSuccess, id result)) success
               andFailBlock:(void (^)(AFHTTPRequestOperation *operation, NSError* error)) fail {
    
    NSString * url = [self urlInitReexWithType:reexType];
    
    
    
    [self.restEngine GET:url success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error;
        NSDictionary *data = (NSDictionary *)responseObject;
        if (!error && data) {
            success(YES, data);
        } else {
            success(NO, data);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {        
        [[MCMLoadingManager sharedInstance] hideLoading];
        fail(operation, error);
    }];
}

- (void)activateReexContract:(NSString *)activationCode
                forUserEmail:(NSString *) userEmail
          withContractNumber:(NSString *)number
             andSuccessBlock:(void (^)(BOOL isSuccess, id result)) success
                andFailBlock:(void (^)(AFHTTPRequestOperation *operation, NSError* error)) fail {
    
    NSString * url = [self userActivateReexContractUrlForUserId:userEmail andContractId: number andCode:activationCode];
    NSDictionary* parameters = @{@"abcd":activationCode};
    
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
     NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
     NSMutableURLRequest* request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"PUT" URLString:url parameters:jsonString error:NULL];
     [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    [self.restEngine url:url request:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(YES, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        fail(operation ,error);
    }];
}

- (void) getReexContractsForUser:(NSString *)userEmail andExecute:(void (^)(id responseObject,  NSError* error))block {
    
    NSString * url = [self userCurrentReexContractsForUser: userEmail];
    
    [self.restEngine GET:url success:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil, error);
    }];
}

- (void) renewReexCode:(NSString *)code forUserEmail:(NSString *)userEmail andExecute:(void (^) (NSString * statusCode, NSError* error))block {
    NSString * url = [self userResendActivationReexCodeForUserEmail:userEmail andContractId:code];

    [self.restEngine GET:url success:^(AFHTTPRequestOperation *operation, id responseObject) {
        block([NSString stringWithFormat:@"%ld", (long)operation.response.statusCode], nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block([NSString stringWithFormat:@"%ld", (long)operation.response.statusCode], error);
    }];
}

//REEX URLs


- (NSString *)getPriceForContractNational:(BOOL) isNational {
    if(isNational) {
        return [self.restPrefix stringByAppendingString:FORMAT(@"/reex/TN/price")];
    }
    else {
        return [self.restPrefix stringByAppendingString:FORMAT(@"/reex/TI/price")];
    }
}

- (NSString *)urlAddToCartNational:(BOOL) isNational Definitif:(BOOL) isDefinitif forUser: (NSString *) userEmail {
    NSString *complement;
    if (isDefinitif) {
        if(isNational)
            complement = @"DN";
        else
            complement = @"DI";
    } else {
        if(isNational)
            complement = @"TN";
        else
            complement = @"TI";
    }
    return [self.restPrefix stringByAppendingString:FORMAT(@"/users/%@/carts/current/reex/%@/entries", userEmail, complement)];
}


- (NSString *)urlInitReexWithType:(NSString*)reexType {
    return [self.restPrefix stringByAppendingString:FORMAT(@"/reex/%@/init", reexType)];
}


- (NSString *)userCurrentReexContractsForUser:(NSString*)userEmail {
    return [self.restPrefix stringByAppendingString:FORMAT(@"/users/%@/reex", userEmail)];
}

- (NSString *)userResendActivationReexCodeForUserEmail:(NSString*)userEmail andContractId:(NSString*) contractId {
    return [self.restPrefix stringByAppendingString:FORMAT(@"/users/%@/reex/%@/resendActivationCode", userEmail, contractId)];
}

- (NSString *)userActivateReexContractUrlForUserId:(NSString*)userId andContractId: (NSString*)contractId andCode:(NSString*) code {
    return [self.restPrefix stringByAppendingString:FORMAT(@"/users/%@/reex/%@/activate?activationCode=%@", userId, contractId, code)];
}

@end


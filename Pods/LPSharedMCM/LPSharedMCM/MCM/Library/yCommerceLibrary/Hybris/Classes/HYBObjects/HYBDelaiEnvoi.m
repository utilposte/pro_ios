//
//  HYBDelaiEnvoi.m
//  Pods
//
//  Created by Rafik ISSOLAH - Direction du numérique on 07/03/2016.
//
//

#import "HYBDelaiEnvoi.h"
#import "NSValueTransformer+MTLPredefinedTransformerAdditions.h"



@implementation HYBDelaiEnvoi

+ (instancetype)delaiEnvoiWithParams:(NSDictionary*)params {
    
    NSError *error = nil;
    HYBDelaiEnvoi *object = [MTLJSONAdapter modelOfClass:[HYBDelaiEnvoi class] fromJSONDictionary:params error:&error];
    
    if (error) {
        NSLog(@"Couldn't convert JSON to model HYBDelaiEnvoi");
        return nil;
    }
    
    return object;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"code" : @"code",
             @"label" : @"label"
             };
}

@end

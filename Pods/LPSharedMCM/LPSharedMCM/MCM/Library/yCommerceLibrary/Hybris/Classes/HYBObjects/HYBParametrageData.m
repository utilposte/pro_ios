//
//  HYBParametrageData.m
//  Pods
//
//  Created by Nabil KAABI on 31/03/16.
//
//

#import <Foundation/Foundation.h>
#import "HYBParametrageData.h"
#import "NSValueTransformer+MTLPredefinedTransformerAdditions.h"

@implementation HYBParametrageData


+ (instancetype)parametrageDataWithParams:(NSDictionary*)params {
    
    NSError *error = nil;
    HYBParametrageData *object = [MTLJSONAdapter modelOfClass:[HYBParametrageData class] fromJSONDictionary:params error:&error];
    
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
//
//  HYBDestinationEnvoi.m
//  Pods
//
//  Created by Rafik ISSOLAH - Direction du numérique on 07/03/2016.
//
//

#import "HYBDestinationEnvoi.h"
#import "NSValueTransformer+MTLPredefinedTransformerAdditions.h"



@implementation HYBDestinationEnvoi

+ (instancetype)destinationEnvoiWithParams:(NSDictionary*)params {
    
    NSError *error = nil;
    HYBDestinationEnvoi *object = [MTLJSONAdapter modelOfClass:[HYBDestinationEnvoi class] fromJSONDictionary:params error:&error];
    
    if (error) {
        NSLog(@"Couldn't convert JSON to model HYBDestinationEnvoi");
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

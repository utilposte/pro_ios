//
//  HYBDestinationEnvoi2.m
//  Pods
//
//  Created by Rafik ISSOLAH - Direction du numérique on 07/03/2016.
//
//

#import "HYBDestinationEnvoi2.h"
#import "NSValueTransformer+MTLPredefinedTransformerAdditions.h"



@implementation HYBDestinationEnvoi2

+ (instancetype)destinationEnvoi2WithParams:(NSDictionary*)params {
    
    NSError *error = nil;
    HYBDestinationEnvoi2 *object = [MTLJSONAdapter modelOfClass:[HYBDestinationEnvoi2 class] fromJSONDictionary:params error:&error];
    
    if (error) {
        NSLog(@"Couldn't convert JSON to model HYBDestinationEnvoi2");
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
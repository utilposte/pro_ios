//
//  HYBPackaging.m
//  Pods
//
//  Created by Rafik ISSOLAH - Direction du numérique on 07/03/2016.
//
//

#import "HYBPackaging.h"
#import "NSValueTransformer+MTLPredefinedTransformerAdditions.h"



@implementation HYBPackaging

+ (instancetype)packagingWithParams:(NSDictionary*)params {
    
    NSError *error = nil;
    HYBPackaging *object = [MTLJSONAdapter modelOfClass:[HYBPackaging class] fromJSONDictionary:params error:&error];
    
    if (error) {
        NSLog(@"Couldn't convert JSON to model HYBPackaging");
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

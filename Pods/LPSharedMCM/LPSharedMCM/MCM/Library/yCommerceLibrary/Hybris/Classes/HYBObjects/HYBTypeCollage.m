//
//  HYBTypeCollage.m
//  Pods
//
//  Created by Rafik ISSOLAH - Direction du numérique on 07/03/2016.
//
//

#import "HYBTypeCollage.h"
#import "NSValueTransformer+MTLPredefinedTransformerAdditions.h"



@implementation HYBTypeCollage

+ (instancetype)typeCollageWithParams:(NSDictionary*)params {
    
    NSError *error = nil;
    HYBTypeCollage *object = [MTLJSONAdapter modelOfClass:[HYBTypeCollage class] fromJSONDictionary:params error:&error];
    
    if (error) {
        NSLog(@"Couldn't convert JSON to model HYBTypeCollage");
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
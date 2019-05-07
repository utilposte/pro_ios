//
//  HYBThematiques.m
//  LPSharedMCM
//
//  Created by Yonael Tordjman on 20/02/2019.
//

#import "HYBThematiques.h"

@implementation HYBThematiques

+ (instancetype)thematiquesWithParams:(NSDictionary*)params {
    
    NSError *error = nil;
    HYBThematiques *object = [MTLJSONAdapter modelOfClass:[HYBThematiques class] fromJSONDictionary:params error:&error];
    
    if (error) {
        NSLog(@"1 Couldn't convert JSON to model HYBThematiques");
        return nil;
    }
    
    return object;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"code": @"code",
             @"label": @"label",
             };
}


@end

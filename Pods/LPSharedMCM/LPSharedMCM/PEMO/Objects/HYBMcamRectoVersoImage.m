//
//  HYBMcamRectoImage.m
//  LPSharedMCM
//
//  Created by Issam DAHECH on 04/05/2018.
//

#import "HYBMcamRectoVersoImage.h"

@implementation HYBMcamRectoVersoImage

+ (instancetype)mcamRectoVersoWithParams:(NSDictionary*)params {
    
    NSError *error = nil;
    HYBMcamRectoVersoImage *object = [MTLJSONAdapter modelOfClass:[HYBMcamRectoVersoImage class] fromJSONDictionary:params error:&error];
    
    if (error) {
        NSLog(@"1 Couldn't convert JSON to model HYBMcamRectoVersoImage");
        return nil;
    }
    
    return object;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"format" : @"format",
             @"url"    : @"url"
             };
}

@end

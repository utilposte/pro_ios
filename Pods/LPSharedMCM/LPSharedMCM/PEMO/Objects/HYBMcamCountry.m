//
//  HYBMcamCountry.m
//  LPSharedMCM
//
//  Created by Issam DAHECH on 04/05/2018.
//

#import "HYBMcamCountry.h"

@implementation HYBMcamCountry

+ (instancetype)mcamCountryWithParams:(NSDictionary*)params {
    
    NSError *error = nil;
    HYBMcamCountry *object = [MTLJSONAdapter modelOfClass:[HYBMcamCountry class] fromJSONDictionary:params error:&error];
    
    if (error) {
        NSLog(@"1 Couldn't convert JSON to model HYBMcamCountry");
        return nil;
    }
    
    return object;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"isocode" : @"isocode",
             @"name"    : @"name"
             };
}

@end

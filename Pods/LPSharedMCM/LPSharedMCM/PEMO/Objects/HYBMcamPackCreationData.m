//
//  HYBMcamPackCreationData.m
//  LPSharedMCM
//
//  Created by Issam DAHECH on 04/06/2018.
//

#import "HYBMcamPackCreationData.h"

@implementation HYBMcamPackCreationData


+ (instancetype)mcamPackCreationDataWithParams:(NSDictionary*)params {
    
    NSError *error = nil;
    HYBMcamPackCreationData *object = [MTLJSONAdapter modelOfClass:[HYBMcamPackCreationData class] fromJSONDictionary:params error:&error];
    
    if (error) {
        NSLog(@"1 Couldn't convert JSON to model HYBMcamPackCreationData");
        return nil;
    }
    
    return object;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"codeCreation"        : @"codeCreation",
             @"codeOffreCredit"     : @"codeOffreCredit",
             @"codePack"            : @"codePack",
             @"isForGift"           : @"isForGift"
             };
}

@end

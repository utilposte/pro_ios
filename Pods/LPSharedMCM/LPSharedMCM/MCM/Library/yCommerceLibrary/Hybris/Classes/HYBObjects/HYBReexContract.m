//
//  HYBReexContract.m
// [y] hybris Platform
//
//  Created by Sofien Azzouz on 26/09/2017.
//

#import "HYBReexContract.h"
#import "NSValueTransformer+MTLPredefinedTransformerAdditions.h"
#import "HYBBaseOption.h"

@implementation HYBReexContract
+ (instancetype)reexContractWithParams:(NSDictionary*)params {
    
    NSError *error = nil;
    HYBReexContract *object = [MTLJSONAdapter modelOfClass:[HYBReexContract class] fromJSONDictionary:params error:&error];
    
    if (error) {
        NSLog(@"1 Couldn't convert JSON to model HYBReexContract");
        return nil;
    }
    
    return object;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"allPersons" : @"allPersons",
             @"bdpActivation" : @"bdpActivation",
             @"contacts" : @"contacts",
             @"dhName" : @"dhName",
             @"idContract" : @"idContract",
             @"endDate" : @"endDate",
             @"theNewAddress" : @"newAddress",
             @"number" : @"number",
             @"oldAddress" : @"oldAddress",
             @"onlineActivation" : @"onlineActivation",
             @"startDate" : @"startDate",
             @"status" : @"status",
             @"contractType" : @"contractType",
             @"duration" : @"duration"
             };
}


@end

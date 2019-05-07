//
// HYBCartModification.m
// [y] hybris Platform
//
// Copyright (c) 2000-2015 hybris AG
// All rights reserved.
//
// This software is the confidential and proprietary information of hybris
// ("Confidential Information"). You shall not disclose such Confidential
// Information and shall use it only in accordance with the terms of the
// license agreement you entered into with hybris.
//
// Warning:This file was auto-generated by OCC2Ojbc.
//

#import "HYBCartModification.h"
#import "NSValueTransformer+MTLPredefinedTransformerAdditions.h"

#import "HYBOrderEntry.h"


@implementation HYBCartModification

+ (instancetype)cartModificationWithParams:(NSDictionary*)params {
    
    NSError *error = nil;
    HYBCartModification *object = [MTLJSONAdapter modelOfClass:[HYBCartModification class] fromJSONDictionary:params error:&error];
    
    if (error) {
        NSLog(@"Couldn't convert JSON to model HYBCartModification");
        return nil;
    }
    
    return object;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"entry" : @"entry",
             @"quantity" : @"quantity",
             @"deliveryModeChanged" : @"deliveryModeChanged",
             @"statusMessage" : @"statusMessage",
             @"statusCode" : @"statusCode",
             @"quantityAdded" : @"quantityAdded"
             };
}




+ (NSValueTransformer *)entryJSONTransformer {
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[HYBOrderEntry class]];
}



@end
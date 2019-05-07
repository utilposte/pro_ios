//
// HYBOrderStatusUpdateElement.m
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

#import "HYBOrderStatusUpdateElement.h"
#import "NSValueTransformer+MTLPredefinedTransformerAdditions.h"



@implementation HYBOrderStatusUpdateElement

+ (instancetype)orderStatusUpdateElementWithParams:(NSDictionary*)params {
    
    NSError *error = nil;
    HYBOrderStatusUpdateElement *object = [MTLJSONAdapter modelOfClass:[HYBOrderStatusUpdateElement class] fromJSONDictionary:params error:&error];
    
    if (error) {
        NSLog(@"Couldn't convert JSON to model HYBOrderStatusUpdateElement");
        return nil;
    }
    
    return object;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"code" : @"code",
             @"baseSiteId" : @"baseSiteId",
             @"status" : @"status"
             };
}






@end
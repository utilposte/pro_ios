//
// HYBOrderHistory.m
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

#import "HYBOrderHistory.h"
#import "NSValueTransformer+MTLPredefinedTransformerAdditions.h"

#import "HYBPrice.h"
#import "HYBOrderEntry.h"
#import "HYBStatusPhila.h"

@implementation HYBOrderHistory
    
+ (instancetype)orderHistoryWithParams:(NSDictionary*)params {
    
    NSError *error = nil;
    HYBOrderHistory *object = [MTLJSONAdapter modelOfClass:[HYBOrderHistory class] fromJSONDictionary:params error:&error];
    
    if (error) {
        NSLog(@"Couldn't convert JSON to model HYBOrderHistory");
        return nil;
    }
    
    return object;
}
    
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"total" : @"total",
             @"code" : @"code",
             @"placed" : @"placed",
             @"statusDisplay" : @"statusDisplay",
             @"guid" : @"guid",
             @"status" : @"status",
             @"statusPhila" : @"statusPhila",
             @"entries" : @"entries"
             };
}
    
    
    
    
+ (NSValueTransformer *)totalJSONTransformer {
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[HYBPrice class]];
}
    
+ (NSValueTransformer *)entriesJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[HYBOrderEntry class]];
}
    
+ (NSValueTransformer *)statusPhilaJSONTransformer {
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[HYBStatusPhila class]];
}
    
@end
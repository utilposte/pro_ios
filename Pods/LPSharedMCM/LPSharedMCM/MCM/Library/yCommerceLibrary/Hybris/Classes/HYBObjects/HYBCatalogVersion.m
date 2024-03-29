//
// HYBCatalogVersion.m
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

#import "HYBCatalogVersion.h"
#import "NSValueTransformer+MTLPredefinedTransformerAdditions.h"

#import "HYBCategoryHierarchy.h"


@implementation HYBCatalogVersion

+ (instancetype)catalogVersionWithParams:(NSDictionary*)params {
    
    NSError *error = nil;
    HYBCatalogVersion *object = [MTLJSONAdapter modelOfClass:[HYBCatalogVersion class] fromJSONDictionary:params error:&error];
    
    if (error) {
        NSLog(@"Couldn't convert JSON to model HYBCatalogVersion");
        return nil;
    }
    
    return object;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"categories" : @"categories"
             };
}

+ (NSValueTransformer *)categoriesJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[HYBCategoryHierarchy class]];
}






@end
//
// HYBCatalogList.m
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

#import "HYBCatalogList.h"
#import "NSValueTransformer+MTLPredefinedTransformerAdditions.h"

#import "HYBCatalog.h"


@implementation HYBCatalogList

+ (instancetype)catalogListWithParams:(NSDictionary*)params {

NSError *error = nil;
HYBCatalogList *object = [MTLJSONAdapter modelOfClass:[HYBCatalogList class] fromJSONDictionary:params error:&error];

if (error) {
    NSLog(@"Couldn't convert JSON to model HYBCatalogList");
    return nil;
}

return object;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
   return @{
@"catalogs" : @"catalogs"
};
}

+ (NSValueTransformer *)catalogsJSONTransformer {
return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[HYBCatalog class]];
}






@end
//
// HYBProductList.h
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

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>




@interface HYBProductList : MTLModel <MTLJSONSerializing>

@property (nonatomic) NSString *catalog;
@property (nonatomic) NSNumber *totalPageCount;
@property (nonatomic) NSNumber *currentPage;
@property (nonatomic) NSString *version;
@property (nonatomic) NSArray *products;
@property (nonatomic) NSNumber *totalProductCount;


+ (instancetype)productListWithParams:(NSDictionary*)params;

@end

//
// HYBStoreFinderSearchPage.h
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


@class HYBPagination;


@interface HYBStoreFinderSearchPage : MTLModel <MTLJSONSerializing>

@property (nonatomic) NSNumber *sourceLatitude;
@property (nonatomic) NSNumber *sourceLongitude;
@property (nonatomic) HYBPagination *pagination;
@property (nonatomic) NSString *locationText;
@property (nonatomic) NSNumber *boundWestLongitude;
@property (nonatomic) NSArray *stores;
@property (nonatomic) NSNumber *boundNorthLatitude;
@property (nonatomic) NSArray *sorts;
@property (nonatomic) NSNumber *boundSouthLatitude;
@property (nonatomic) NSNumber *boundEastLongitude;


+ (instancetype)storeFinderSearchPageWithParams:(NSDictionary*)params;

@end

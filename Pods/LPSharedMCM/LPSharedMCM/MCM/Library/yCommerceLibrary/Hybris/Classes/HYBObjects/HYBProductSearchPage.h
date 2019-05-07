//
// HYBProductSearchPage.h
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
@class HYBSearchState;
@class HYBSpellingSuggestion;


@interface HYBProductSearchPage : MTLModel <MTLJSONSerializing>

@property (nonatomic) NSString *freeTextSearch;
@property (nonatomic) HYBPagination *pagination;
@property (nonatomic) HYBSearchState *currentQuery;
@property (nonatomic) NSString *keywordRedirectUrl;
@property (nonatomic) HYBSpellingSuggestion *spellingSuggestion;
@property (nonatomic) NSString *categoryCode;
@property (nonatomic) NSArray *sorts;
@property (nonatomic) NSArray *breadcrumbs;
@property (nonatomic) NSArray *products;
@property (nonatomic) NSArray *facets;


+ (instancetype)productSearchPageWithParams:(NSDictionary*)params;

@end

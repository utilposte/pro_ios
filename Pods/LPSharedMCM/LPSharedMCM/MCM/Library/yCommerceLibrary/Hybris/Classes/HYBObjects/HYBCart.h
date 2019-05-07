//
// HYBCart.h
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


#import "HYBAbstractOrder.h"
#import "HYBCostCenter.h"

@class HYBPrincipal;


@interface HYBCart : HYBAbstractOrder

@property (nonatomic) NSArray *potentialOrderPromotions;
@property (nonatomic) NSArray *potentialProductPromotions;
@property (nonatomic) NSString *expirationTime;
@property (nonatomic) HYBCostCenter *costCenter;
@property (nonatomic) NSNumber *totalUnitCount;
@property (nonatomic) NSString *purchaseOrderNumber;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *descriptor;
@property (nonatomic) NSString *saveTime;
@property (nonatomic) HYBPrincipal *savedBy;


+ (instancetype)cartWithParams:(NSDictionary*)params;

@end
//
//  HYBReexContract.h
// [y] hybris Platform
//
//  Created by Sofien Azzouz on 26/09/2017.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>


@interface HYBReexContract : MTLModel <MTLJSONSerializing>

@property (nonatomic) BOOL allPersons;
@property (nonatomic) BOOL bdpActivation;
@property (nonatomic) NSArray *contacts;
@property (nonatomic) NSString *dhName;
@property (nonatomic) NSString *idContract;
@property (nonatomic) NSString *endDate;
@property (nonatomic) NSDictionary *theNewAddress;
@property (nonatomic) NSNumber *number;
@property (nonatomic) NSDictionary *oldAddress;
@property (nonatomic) BOOL onlineActivation;
@property (nonatomic) NSString *startDate;
@property (nonatomic) NSString *status;
@property (nonatomic) NSString *contractType;

@property (nonatomic) NSNumber *duration;


+ (instancetype)reexContractWithParams:(NSDictionary*)params;

@end

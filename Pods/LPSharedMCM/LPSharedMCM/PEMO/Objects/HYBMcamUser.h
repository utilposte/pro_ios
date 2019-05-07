//
//  HYBMcamUser.h
//  LPSharedMCM
//
//  Created by Issam DAHECH on 04/05/2018.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@class HYBMcamCountry;
@interface HYBMcamUser : MTLModel <MTLJSONSerializing>

@property (nonatomic) HYBMcamCountry *country;
@property (nonatomic) NSString *firstName;
@property (nonatomic) NSString *idMcmaExpediteur;
@property (nonatomic) NSString *lastName;
@property (nonatomic) NSString *line1;
@property (nonatomic) NSString *postalCode;
@property (nonatomic) BOOL      shippingAddress;
@property (nonatomic) NSString *town;
@property (nonatomic) BOOL      visibleInAddressBook;

+ (instancetype)mcamUserWithParams:(NSDictionary*)params;

@end

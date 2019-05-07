//
//  MCMUser.h
//  laposte
//
//  Created by Ricardo Suarez on 08/08/16.
//  Copyright © 2016 laposte. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCMUser : NSObject

@property (nonatomic, strong) NSDictionary *completeAccessToken;
@property (nonatomic, strong) NSString *uId;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *birthDate;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *customerIdentifier;
@property (nonatomic, strong) NSNumber *isNewCustomer;

// user address

@property (nonatomic, strong) NSString *floor;
@property (nonatomic, strong) NSString *building;
@property (nonatomic, strong) NSString *street;
@property (nonatomic, strong) NSString *town;
@property (nonatomic, strong) NSString *locality;
@property (nonatomic, strong) NSString *postalCode;
@property (nonatomic, strong) NSString *countryIsoCode;
@property (nonatomic, strong) NSString *countryName;

- (id)initWithValues:(NSDictionary *)values;
- (id)initWithUser:(MCMUser *)user;

@end

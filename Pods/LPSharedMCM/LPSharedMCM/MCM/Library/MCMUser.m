//
//  MCMUser.m
//  laposte
//
//  Created by Ricardo Suarez on 08/08/16.
//  Copyright © 2016 laposte. All rights reserved.
//

#import "MCMUser.h"

#import "MCMUserConstants.h"

@interface MCMUser ()

@end

@implementation MCMUser

#pragma mark - Initializer

- (id) initWithValues:(NSDictionary *)values {
    
    self = [super init];
    
    if (self) {
        [self setupUserData:values];
    }
    return self;
}

- (id)initWithUser:(MCMUser *)user {
    
    self = [super init];
    
    if (self) {
        [self setupUser:user];
    }
    return self;
}

#pragma mark - Internal

- (void)setupUserData:(NSDictionary *)values {
    
    _completeAccessToken = [values valueForKey:MCMUser_Complete_Access_Token_Key];
    _uId = [values valueForKey:MCMUser_UId_Key] ? [values valueForKey:MCMUser_UId_Key] : [values valueForKey:MCMUser_Email_Key];
    _floor = [values valueForKey:MCMUser_Floor_Key] ? [values valueForKey:MCMUser_Floor_Key] : @"";
    _building = [values valueForKey:MCMUser_Building_Key] ? [values valueForKey:MCMUser_Building_Key] : @"";
    _street = [values valueForKey:MCMUser_Street_Key] ? [values valueForKey:MCMUser_Street_Key] : @"";
    _town = [values valueForKey:MCMUser_Town_Key] ? [values valueForKey:MCMUser_Town_Key] : @"";
    _locality = [values valueForKey:MCMUser_Locality_Key] ? [values valueForKey:MCMUser_Locality_Key] : @"";
    _postalCode = [values valueForKey:MCMUser_Postal_Code_Key] ? [values valueForKey:MCMUser_Postal_Code_Key] : @"";
    _countryIsoCode = [values valueForKey:MCMUser_Country_Iso_Code_Key] ? [values valueForKey:MCMUser_Country_Iso_Code_Key] : @"";
    _countryName = [values valueForKey:MCMUser_Country_Name_Key] ? [values valueForKey:MCMUser_Country_Name_Key] : @"";
    _firstName = [values valueForKey:MCMUser_First_Name_Key] ? [values valueForKey:MCMUser_First_Name_Key] : @"";
    _lastName = [values valueForKey:MCMUser_Last_Name_Key] ? [values valueForKey:MCMUser_Last_Name_Key] : @"";
    _title = [values valueForKey:MCMUser_Title_Key] ? [values valueForKey:MCMUser_Title_Key] : @"";
    _phoneNumber = [values valueForKey:MCMUser_Phone_Number_Key] ? [values valueForKey:MCMUser_Phone_Number_Key] : @"";
    _birthDate = [values valueForKey:MCMUser_Birth_Date_Key] ? [values valueForKey:MCMUser_Birth_Date_Key] : @"";
    _email = [values valueForKey:MCMUser_Email_Key] ? [values valueForKey:MCMUser_Email_Key] : @"";
    _customerIdentifier = [values valueForKey:MCMUser_Customer_ID_Key] ? [values valueForKey:MCMUser_Customer_ID_Key] : @"";
    _isNewCustomer = [values valueForKey:MCMUser_New_Customer_Key] ? [values valueForKey:MCMUser_New_Customer_Key] : @"";
}

- (void)setupUser:(MCMUser *)user {
    
    _completeAccessToken = user.completeAccessToken;
    _uId = user.uId ? user.uId : @"";
    _floor = user.floor ? user.floor : @"";
    _building = user.building ? user.building : @"";
    _street = user.street ? user.street : @"";
    _town = user.town ? user.town : @"";
    _locality = user.locality ? user.locality : @"";
    _postalCode = user.postalCode ? user.postalCode : @"";
    _countryIsoCode = user.countryIsoCode ? user.countryIsoCode : @"";
    _countryName = user.countryName ? user.countryName : @"";
    _firstName = user.firstName ? user.firstName : @"";
    _lastName = user.lastName ? user.lastName : @"";
    _title = user.title ? user.title : @"";
    _phoneNumber = user.phoneNumber ? user.phoneNumber : @"";
    _birthDate = user.birthDate ? user.birthDate : @"";
    _email = user.email ? user.email : @"";
    _customerIdentifier = user.customerIdentifier ? user.customerIdentifier : @"";
    _isNewCustomer = user.isNewCustomer ? user.isNewCustomer : @"";
}

@end

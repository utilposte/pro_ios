//
//  Reexpedition.h
//  laposte
//
//  Created by Lassad Tiss on 05/02/2018.
//  Copyright © 2018 laposte. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef REEXPEDITION_IMPORTED
#define REEXPEDITION_IMPORTED

typedef NS_ENUM (NSUInteger, REXActivationType) {
    NONE,
    AllReadyLeftHomeForNationalReexActivation,
    StillAtHomeForNationalReexActivation,
    AllReadyLeftHomeForInternationalReexActivation,
    SomeoneAtHomeForInternationalReexActivation,
    StillAtHomeForInationalReexActivation
};

@interface Reexpedition : NSObject

@property (assign,nonatomic) BOOL isNationnalReex;
@property (assign,nonatomic) BOOL alreadyLeftOldAddressActivation;
@property (assign,nonatomic) BOOL posteOfficeActivation;
@property (assign,nonatomic) BOOL onlineActivation;
@property (assign,nonatomic) REXActivationType activationType;
@property (strong,nonatomic) NSString *recapActivationBlocText;
@property (strong,nonatomic) NSMutableString *recapValidationBlocText;
@property (nonatomic) BOOL isNewAddress;
@property (nonatomic) BOOL useAddress;

// DH
@property (strong,nonatomic) NSString   *ayantDroitNom;
@property (strong,nonatomic) NSString   *ayantDroitPrenom;
@property (strong,nonatomic) NSString   *dhName;
@property (strong,nonatomic) NSString   *dhCivilite;
@property (strong,nonatomic) NSArray    *dhOptins;
@property (assign,nonatomic) NSNumber   *deadPerson;

// Beneficiary
@property (strong,nonatomic) NSArray    *beneficiaryArray;
@property (assign,nonatomic) NSNumber   *allPersons;

@property (strong,nonatomic) NSString *contratStartDate;
@property (strong,nonatomic) NSString *contratEndDate;
@property (strong,nonatomic) NSString *contratDuration;
@property (strong,nonatomic) NSString *contratPrice;
@property (strong,nonatomic) NSDictionary *initialAddress;
@property (strong,nonatomic) NSDictionary *destinationAddress;

@property (strong,nonatomic) NSString *activationTime;
@property (strong,nonatomic) NSString *duration;
@property (assign,nonatomic) NSInteger monthsnumber;

//Calendar
@property (strong, nonatomic) NSString *nextValidDate;
@property (strong, nonatomic) NSArray *holidays;

// Countries list


- (NSArray *)countries;
- (void)setCountries:(NSArray *)countries;

@end

#endif

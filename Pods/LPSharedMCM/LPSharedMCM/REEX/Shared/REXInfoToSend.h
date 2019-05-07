//
//  REXInfoToSend.h
//  laposte
//
//  Created by Mohamed Helmi Ben Jabeur on 11/09/2017.
//  Copyright © 2017 laposte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reexpedition.h"

/*typedef NS_ENUM (NSUInteger, REXActivationType) {
    NONE,
    AllReadyLeftHomeForNationalReexActivation,
    StillAtHomeForNationalReexActivation,
    AllReadyLeftHomeForInternationalReexActivation,
    SomeoneAtHomeForInternationalReexActivation,
    StillAtHomeForInationalReexActivation
};*/

@interface REXInfoToSend : NSObject

/*@property (assign,nonatomic) BOOL isNationnalReex;
@property (assign,nonatomic) BOOL alreadyLeftOldAddressActivation;
@property (assign,nonatomic) BOOL PosteOfficeActivation;
@property (assign,nonatomic) BOOL OnlineActivation;
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
@property (strong,nonatomic) NSDictionary *DestinationAddress;

@property (strong,nonatomic) NSString *activationTime;
@property (strong,nonatomic) NSString *duration;

//Calendar
@property (strong, nonatomic) NSString *nextValidDate;
@property (strong, nonatomic) NSArray *holidays;

// Countries list
@property (strong, nonatomic) NSArray *countries;*/

@property (nonatomic, strong) Reexpedition *definitiveReexpedition;
@property (nonatomic, strong) Reexpedition *temporaryReexpedition;
@property (nonatomic) BOOL isDefinitive;

+ (REXInfoToSend *) sharedInstance;
+ (void)resetSharedInstance;
- (void)resetSharedDataAfterLogout;


@end

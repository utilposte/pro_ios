//
//  REXGeoCoderManager.h
//  laposte
//
//  Created by Issam DAHECH on 18/09/2017.
//  Copyright © 2017 laposte. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol REXGeoCoderManagerDelegate <NSObject>
- (void)didGetAddress:(NSDictionary *)aDic;
- (void)didGetAddressError:(NSString *)errorMessage;
@end

#define kREX_streetNameNumberKey    @"streetNameNumber"
#define kREX_postalCodeKey          @"postalCode"
#define kREX_localityKey            @"locality"
#define kREX_countryKey             @"country"
@interface REXGeoCoderManager : NSObject

@property id<REXGeoCoderManagerDelegate> delegate;

+ (REXGeoCoderManager *) sharedManager;
+ (BOOL)locationServicesEnabled;
- (void)requestCurrentAdress;
- (BOOL)askForRequestWhenInUseAuthorization;

@end

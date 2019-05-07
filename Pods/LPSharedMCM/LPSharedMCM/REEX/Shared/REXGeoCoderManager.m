//
//  REXGeoCoderManager.m
//  laposte
//
//  Created by Issam DAHECH on 18/09/2017.
//  Copyright © 2017 laposte. All rights reserved.
//

#import "REXGeoCoderManager.h"
#import <CoreLocation/CoreLocation.h>
#import "REXInfoToSend.h"
#import "MCMLoadingManager.h"


@interface REXGeoCoderManager() <CLLocationManagerDelegate> {
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
}

@end

@implementation REXGeoCoderManager

+ (REXGeoCoderManager *)sharedManager {
    static REXGeoCoderManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (id) init {
    self = [super init];
    if (self) {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [locationManager requestWhenInUseAuthorization];
        }
        geocoder = [[CLGeocoder alloc] init];
    }
    return self;
}

- (void)requestCurrentAdress {
    [[MCMLoadingManager sharedInstance] showLoading];
    //[UIAppDelegate displayLoader];
    [locationManager startUpdatingLocation];
}

- (BOOL)askForRequestWhenInUseAuthorization {
    if([CLLocationManager locationServicesEnabled]) {
        if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [locationManager requestWhenInUseAuthorization];
        }
        return NO;
    } else {
        return YES;
    }
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [[MCMLoadingManager sharedInstance] hideLoading];
    //[UIAppDelegate hideLoader];
    NSLog(@"didFailWithError: %@", error);
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied){
        if (_delegate && [_delegate respondsToSelector:@selector(didGetAddressError:)]) {
            [_delegate didGetAddressError:@"  Vous avez refusé la demande de géolocalisation"];
            
        }
    }
    else {
        if (_delegate && [_delegate respondsToSelector:@selector(didGetAddressError:)]) {
            [_delegate didGetAddressError:@"  La géolocalisation est actuellement indisponible"];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocation *currentLocation = newLocation;
     [locationManager stopUpdatingLocation];
    if (currentLocation != nil) {
        [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
            if (error == nil && [placemarks count] > 0) {
                placemark = [placemarks lastObject];
                [self checkValidAddress:placemark];
                [[MCMLoadingManager sharedInstance] hideLoading];
            }
            else {
                NSLog(@"%@", error.debugDescription);
                [_delegate didGetAddressError:@"  La géolocalisation est actuellement indisponible"];
                [[MCMLoadingManager sharedInstance] hideLoading];
            }
        } ];
    }
}

- (NSDictionary *)adressDicFromPlacemark:(CLPlacemark*) placeMark {
    NSMutableDictionary *tmpDic = [[NSMutableDictionary alloc] init];
    NSMutableString* buildString = [NSMutableString stringWithString:@""];
    
    if (placeMark.subThoroughfare) {
        [buildString appendString:placeMark.subThoroughfare];
        [buildString appendString:@" "];
    }
    
    if (placeMark.thoroughfare) {
        [buildString appendString:placeMark.thoroughfare];
    }
    [tmpDic setObject:buildString forKey:kREX_streetNameNumberKey];
    
    if (placeMark.postalCode) {
        [tmpDic setObject:placeMark.postalCode forKey:kREX_postalCodeKey];
    }
    else {
        [tmpDic setObject:@"" forKey:kREX_postalCodeKey];
    }
    
    if (placeMark.locality) {
        [tmpDic setObject:placeMark.locality forKey:kREX_localityKey];
    }
    else {
        [tmpDic setObject:@"" forKey:kREX_localityKey];
    }
    
    if (placeMark.ISOcountryCode) {
        NSString *countryCode = [placemark ISOcountryCode];
        NSString *identifier = [NSLocale localeIdentifierFromComponents: [NSDictionary dictionaryWithObject: countryCode forKey: NSLocaleCountryCode]];
        NSString *country = [[[NSLocale alloc] initWithLocaleIdentifier:@"fr_FR"] displayNameForKey: NSLocaleIdentifier value:identifier];
        [tmpDic setObject:country forKey:kREX_countryKey];
    }
    else {
        [tmpDic setObject:@"" forKey:kREX_countryKey];
    }
    return tmpDic;
}

- (void)checkValidAddress:(CLPlacemark*) placeMark {
    
    /*
     France                             FR
     Saint Barthélemy                   BL
     Mayotte                            YT
     Nouvelle Calédonie                 NC
     Saint-Martin (partie française)    MF
     Polynésie française                PF
     Guadeloupe                         GP
     Guyane                             GY
     Wallis-et-Futuna                   WF
     Martinique                         MQ
     Terres australes françaises        TF
     Réunion                            RE
     */
    
    if ([REXInfoToSend sharedInstance].temporaryReexpedition.isNewAddress == YES || [REXInfoToSend sharedInstance].temporaryReexpedition.isNationnalReex == YES) {
        NSArray *nationlCounties = @[@"FR",@"BL",@"YT",@"NC",@"MF",@"PF",@"GP",@"GY",@"WF",@"MQ",@"TF",@"RE"];
        if ( [nationlCounties containsObject:placemark.ISOcountryCode] ) {
            NSDictionary *address = [self adressDicFromPlacemark:placemark];
            if (_delegate && [_delegate respondsToSelector:@selector(didGetAddress:)]) {
                [_delegate didGetAddress:address];
            }
        } else {
            if (_delegate && [_delegate respondsToSelector:@selector(didGetAddressError:)]) {
                [_delegate didGetAddressError:@"  Vous ne pouvez souscrire un contrat depuis votre position actuelle"];
            }
        }
    }
    else {
        NSDictionary *address = [self adressDicFromPlacemark:placemark];
        if (_delegate && [_delegate respondsToSelector:@selector(didGetAddress:)]) {
            [_delegate didGetAddress:address];
        }
    }
}

+(BOOL) locationServicesEnabled
{
    return [CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse);
}
@end

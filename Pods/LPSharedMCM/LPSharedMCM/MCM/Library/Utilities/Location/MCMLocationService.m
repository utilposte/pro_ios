//
//  MCMLocationService.m
//  laposteCommon
//
//  Created by Hobart Wong on 24/02/2016.
//  Copyright © 2016 DigitasLBi. All rights reserved.
//

#import "MCMLocationService.h"

#import "HYBAddress.h"
#import "HYBCountry.h"

@interface MCMLocationService()
{
    CLLocationManager* _locationManager;
}

@end

@implementation MCMLocationService

+ (MCMLocationService *)sharedInstance
{
    static dispatch_once_t once;
    static MCMLocationService *_sharedInstance;
    dispatch_once(&once, ^ {
        _sharedInstance = [[MCMLocationService alloc] init];
    });
    return _sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        //init the location service
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        
//        if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
//            [_locationManager requestAlwaysAuthorization];
//        }
        if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [_locationManager requestWhenInUseAuthorization];
        }
        _geocoder = [[CLGeocoder alloc] init];
    }
    return self;
}

- (void) startUpdatingLocation
{
    [_locationManager startUpdatingLocation];
}

- (void) stopUpdatingLocation
{
    [_locationManager stopUpdatingLocation];
}

+(BOOL) locationServicesEnabled
{
    return [CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse);
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if(self.delegate != nil) {
        [self.delegate latestLocation:nil withError:error];
    }
    
    //Stop the location service
    [_locationManager stopUpdatingLocation];
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation* newLocation = locations.lastObject;
    
    if(newLocation.verticalAccuracy < 17 && newLocation.horizontalAccuracy < 17)
    {
        [_locationManager stopUpdatingLocation];
    }
    
    NSLog(@"didUpdateToLocation: %@", newLocation);
    self.latestLocation = newLocation;
    if(self.delegate != nil) {
        [self.delegate latestLocation:newLocation withError:nil];
    }
}

//+ (HYBAddress*) mapGoogleAddressToHybrisAddress:(GMSAddress*) googleAddress
//{
//    HYBAddress* newAddress = [HYBAddress new];
//    if(googleAddress.thoroughfare) {
//        newAddress.line1 = googleAddress.thoroughfare;
//    }
//    if(googleAddress.locality) {
//        newAddress.town = googleAddress.locality;
//    }
//    if(googleAddress.postalCode) {
//        newAddress.postalCode = googleAddress.postalCode;
//    }
//    if(googleAddress.country) {
//        HYBCountry* newCountry = [HYBCountry new];
//        newCountry.name = googleAddress.country;
//        newCountry.isocode = [self isoCountryCodeFromName:googleAddress.country];
//        newAddress.country = newCountry;
//    }
//
//    return newAddress;
//}

+ (HYBAddress*) mapApplePlaceMarkToHybrisAddress:(CLPlacemark*) appleAddress
{
    HYBAddress* newAddress = [HYBAddress new];
    if(appleAddress.subThoroughfare) {
        newAddress.line1 = appleAddress.subThoroughfare;
    }
    if(appleAddress.thoroughfare && newAddress.line1) {
        newAddress.line1 = [NSString stringWithFormat:@"%@ %@", newAddress.line1, appleAddress.thoroughfare];
    } else if (appleAddress.thoroughfare && newAddress.line1 == nil) {
        newAddress.line1 = [NSString stringWithFormat:@"%@", appleAddress.thoroughfare];
    }
    if(appleAddress.locality) {
        newAddress.town = appleAddress.locality;
    }
    if(appleAddress.postalCode) {
        newAddress.postalCode = appleAddress.postalCode;
    }
    if(appleAddress.country) {
        HYBCountry* newCountry = [HYBCountry new];
        newCountry.name = appleAddress.country;
        newCountry.isocode = [self isoCountryCodeFromName:appleAddress.country];
        newAddress.country = newCountry;
    }
    
    return newAddress;
}

+(NSString*) isoCountryCodeFromName:(NSString*) countryName
{
    NSArray *countryCodes = [NSLocale ISOCountryCodes];
    NSMutableArray *countries = [NSMutableArray arrayWithCapacity:[countryCodes count]];
    
    for (NSString *countryCode in countryCodes) {
        NSString *identifier = [NSLocale localeIdentifierFromComponents: [NSDictionary dictionaryWithObject: countryCode forKey: NSLocaleCountryCode]];
        NSString *country = [[[NSLocale alloc] initWithLocaleIdentifier:@"fr_FR"] displayNameForKey: NSLocaleIdentifier value: identifier];
        [countries addObject: country];
    }
    
    NSDictionary *codeForCountryDictionary = [[NSDictionary alloc] initWithObjects:countryCodes forKeys:countries];
    for (NSString* key in codeForCountryDictionary) {
        if([key isEqualToString:countryName]){
            return [codeForCountryDictionary[key] lowercaseString];
        }
    }
    return @"fr"; //default
}

+(NSString*) countryNameFromISOCode:(NSString*) isoCode
{
    NSArray *countryCodes = [NSLocale ISOCountryCodes];
    NSMutableArray *countries = [NSMutableArray arrayWithCapacity:[countryCodes count]];
    
    for (NSString *countryCode in countryCodes)
    {
        NSString *identifier = [NSLocale localeIdentifierFromComponents: [NSDictionary dictionaryWithObject: countryCode forKey: NSLocaleCountryCode]];
        NSString *country = [[[NSLocale alloc] initWithLocaleIdentifier:@"fr_FR"] displayNameForKey: NSLocaleIdentifier value: identifier];
        [countries addObject: country];
    }
    
    NSDictionary *codeForCountryDictionary = [[NSDictionary alloc] initWithObjects:countryCodes forKeys:countries];
    
    for (NSString* key in codeForCountryDictionary) {
        if([[codeForCountryDictionary[key] lowercaseString] isEqualToString:[isoCode lowercaseString]]) {
            return key;
        }
    }
    return @"France"; //default
}

-(void) assignAddress:(HYBAddress*) address ForAddressType:(MCMAddressType) addressType {
    switch (addressType) {
        case MCMAddressDeliveryType:
            self.lastDeliveryAddress = address;
            break;
        case MCMAddressLocationType:
            self.lastGeoCodedAddress = address;
            break;
        case MCMAddressBillingType:
            self.lastBillingAddress = address;
            break;
    }
}

-(void) resetAddresses {
    self.lastGeoCodedAddress = nil;
    self.lastDeliveryAddress = nil;
    self.lastBillingAddress = nil;
}

+ (void)reverseGeoCodeLocation:(CLLocationCoordinate2D) newLocation withCompletion:(void (^)(NSArray *placemarks)) completion {
    
    CLGeocoder* geocoder = [MCMLocationService sharedInstance].geocoder;
    CLLocation* location = [[CLLocation alloc] initWithLatitude:newLocation.latitude longitude:newLocation.longitude];
    [geocoder reverseGeocodeLocation:location completionHandler:
     ^(NSArray* placemarks, NSError* error){
         completion(placemarks);
     }];
}

@end


//
//  MCMLocationService.h
//  laposteCommon
//
//  Created by Hobart Wong on 24/02/2016.
//  Copyright © 2016 DigitasLBi. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
//#import <GoogleMaps/GoogleMaps.h>

//#import "MCMBaseAddressCreateAndEditViewController.h"

@class HYBAddress;
//@class GMSAddress;

typedef NS_ENUM (NSInteger, MCMAddressType) {
    MCMAddressDeliveryType = 0,
    MCMAddressLocationType,
    MCMAddressBillingType
};

@protocol MCMLocationServiceDelegate
-(void) latestLocation:(CLLocation*) newLocation withError:(NSError*) error;
@end

@interface MCMLocationService : NSObject <CLLocationManagerDelegate>

@property(retain, nonatomic) CLLocation* latestLocation;
@property(retain, nonatomic) CLGeocoder* geocoder;
@property(retain, nonatomic) HYBAddress* lastGeoCodedAddress;
@property(retain, nonatomic) HYBAddress* lastDeliveryAddress;
@property(retain, nonatomic) HYBAddress* lastBillingAddress;
@property(assign, nonatomic) id<MCMLocationServiceDelegate> delegate;

+ (MCMLocationService *)sharedInstance;
+(BOOL) locationServicesEnabled;
- (void) startUpdatingLocation;
- (void) stopUpdatingLocation;
//+ (HYBAddress*) mapGoogleAddressToHybrisAddress:(GMSAddress*) googleAddress;
+ (HYBAddress*) mapApplePlaceMarkToHybrisAddress:(CLPlacemark*) appleAddress;
+(NSString*) countryNameFromISOCode:(NSString*) isoCode;
-(void) assignAddress:(HYBAddress*) address ForAddressType:(MCMAddressType) addressType;
-(void) resetAddresses;
+(NSString*) isoCountryCodeFromName:(NSString*) countryName;
+ (void)reverseGeoCodeLocation:(CLLocationCoordinate2D) newLocation withCompletion:(void (^)(NSArray *placemarks)) completion;
@end


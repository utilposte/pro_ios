//
//  LOCPostalOffice.h
//  laposte
//
//  Created by Sofien Azzouz on 18/07/2017.
//  Copyright © 2017 laposte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LOCPostalOfficeStatus.h"
#import <CoreLocation/CoreLocation.h>

@interface LOCPostalOffice : NSObject

@property(nonatomic) CLLocationCoordinate2D position;
@property(nonatomic) NSString *name;

@property (nonatomic) NSString *adresse;
@property (nonatomic) NSString *codePostal;
@property (nonatomic) NSString *codeSite;
@property (nonatomic) NSString *libelleSite;
@property (nonatomic) NSString *complementAdresse;
@property (nonatomic) NSString *lieuDit;
@property (nonatomic) NSString *localite;
@property (nonatomic) LOCPostalOfficeStatus *statut;
@property (nonatomic) NSString *type;
@property (nonatomic) NSString *libelleType;
@property (nonatomic) NSString *url;

@property (nonatomic) NSArray *services;
@property (nonatomic) NSArray *accessibilite;

@property (nonatomic) NSArray *horaires;
@property (nonatomic) NSArray *horaireRetraitDepot
;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;

- (id)initFromList:(NSDictionary *)aDict;
- (id)initFromDetailDictionary:(NSDictionary *)aDict;
@end

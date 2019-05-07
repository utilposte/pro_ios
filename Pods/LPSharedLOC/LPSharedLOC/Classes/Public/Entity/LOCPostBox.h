//
//  LOCPostBox.h
//  laposte
//
//  Created by Sofien Azzouz on 20/11/2017.
//  Copyright © 2017 laposte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LOCPostBox : NSObject

@property(nonatomic) CLLocationCoordinate2D position;

@property (nonatomic) NSString *datasetid;
@property (nonatomic) NSString *recordid;
@property (nonatomic) NSString *lb_com;
@property (nonatomic) NSString *co_mup;
@property (nonatomic) NSString *syst_proj_ini;
@property (nonatomic) NSString *co_insee_com;
@property (nonatomic) NSString *co_postal;
@property (nonatomic) double va_coord_adr_x;
@property (nonatomic) double a_coord_adr_y;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nonatomic) NSString *lb_type_geo;
@property (nonatomic) NSString *va_no_voie;
@property (nonatomic) NSString *lb_voie_ext;

-(id)initWithDictionary:(NSDictionary *)aDict;

@end

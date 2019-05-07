//
//  LOCPostBox.m
//  laposte
//
//  Created by Sofien Azzouz on 20/11/2017.
//  Copyright © 2017 laposte. All rights reserved.
//

#import "LOCPostBox.h"

@implementation LOCPostBox

-(id)initWithDictionary:(NSDictionary *)aDict {
    if (self = [super init]) {
        
        self.datasetid          = aDict[@"datasetid"];
        self.recordid           = aDict[@"recordid"];
        self.lb_com             = aDict[@"fields"][@"lb_com"];
        self.co_mup             = aDict[@"fields"][@"co_mup"];
        self.syst_proj_ini      = aDict[@"fields"][@"syst_proj_ini"];
        self.co_insee_com       = aDict[@"fields"][@"co_insee_com"];
        self.co_postal          = aDict[@"fields"][@"co_postal"];
        self.va_coord_adr_x     = [aDict[@"fields"][@"va_coord_adr_x"] doubleValue];
        self.a_coord_adr_y      = [aDict[@"fields"][@"a_coord_adr_y"] doubleValue];
        self.latitude           = [aDict[@"fields"][@"latlong"][0] doubleValue];
        self.longitude          = [aDict[@"fields"][@"latlong"][1] doubleValue];
        self.lb_type_geo        = aDict[@"fields"][@"lb_type_geo"];
        self.va_no_voie         = aDict[@"fields"][@"va_no_voie"];
        self.lb_voie_ext        = aDict[@"fields"][@"lb_voie_ext"];
        self.position = CLLocationCoordinate2DMake(self.latitude, self.longitude);

    }
    return self;
}

@end

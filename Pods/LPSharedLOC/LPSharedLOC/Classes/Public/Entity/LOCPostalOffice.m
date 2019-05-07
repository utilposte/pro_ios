//
//  LOCPostalOffice.m
//  laposte
//
//  Created by Sofien Azzouz on 18/07/2017.
//  Copyright © 2017 laposte. All rights reserved.
//

#import "LOCPostalOffice.h"
#import <CoreLocation/CoreLocation.h>

@implementation LOCPostalOffice

- (id)initFromList:(NSDictionary *)aDict {
    
    if (self = [super init]) {
        self.adresse        = aDict[@"adresse"];
        self.codePostal     = aDict[@"codePostal"];
        self.codeSite       = aDict[@"codeSite"];
        self.libelleSite    = aDict[@"libelleSite"];
        self.localite       = aDict[@"localite"];
        self.complementAdresse = aDict[@"complementAdresse"];
        self.lieuDit        = aDict[@"lieuDit"];
        self.statut         = [[LOCPostalOfficeStatus alloc] initWithStatus:aDict[@"statut"]];
        self.latitude       = [aDict[@"lat"] doubleValue];
        self.longitude      = [aDict[@"lng"]doubleValue];
        
        
        
        self.services       = aDict[@"services"];
        self.type       = aDict[@"type"];
        
        
        self.position = CLLocationCoordinate2DMake(self.latitude, self.longitude);
        self.name = self.libelleSite;
    }
    
    return self;
}

-(id)initFromDetailDictionary:(NSDictionary *)aDict {
    if (self = [super init]) {
        
        // General
        NSDictionary *generalDic = aDict[@"general"];
        self.adresse        = generalDic[@"adresse"];
        self.codePostal     = generalDic[@"codePostal"];
        self.codeSite       = generalDic[@"codeSite"];
        self.libelleSite    = generalDic[@"libelleSite"];
        self.localite       = generalDic[@"localite"];
        self.complementAdresse = generalDic[@"complementAdresse"];
        self.lieuDit        = aDict[@"lieuDit"];
        self.statut         = [[LOCPostalOfficeStatus alloc] initWithStatus:generalDic[@"statut"]];
        self.latitude       = [generalDic[@"lat"] doubleValue];
        self.longitude      = [generalDic[@"lng"]doubleValue];
        self.type           = generalDic[@"type"];
        self.libelleType    = generalDic[@"libelleType"];
        
        // Clustering
        self.position = CLLocationCoordinate2DMake(self.latitude, self.longitude);
        self.name = self.libelleSite;
        // Horaires
        self.horaires = [[NSArray alloc] init];
        if ([aDict[@"horaires"] isKindOfClass:[NSDictionary class]]) {
            NSArray *array = [aDict[@"horaires"] allValues];
            NSSortDescriptor *brandDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
            NSArray *sortDescriptors = [NSArray arrayWithObject:brandDescriptor];
            NSArray *sortedArray = [array sortedArrayUsingDescriptors:sortDescriptors];
            self.horaires       = sortedArray;
        }
        
        self.horaireRetraitDepot = [[NSArray alloc] init];
        if ([aDict[@"horaires"] isKindOfClass:[NSArray class]] && ((NSArray *)aDict[@"horaires"]).count > 0) {
            // ==> IS A DEPOT/RETRAT !!!!
            self.horaireRetraitDepot = aDict[@"horaires"];
        }

        //Accesibility
        self.accessibilite = [[NSArray alloc] init];
        if ([aDict[@"accessibilite"] isKindOfClass:[NSDictionary class]]) {
            self.accessibilite       = [aDict[@"accessibilite"] allValues];
        }
        // Pb with W.S !!!!!
        else if ([aDict[@"accessiblite"] isKindOfClass:[NSDictionary class]]) {
            self.accessibilite       = [aDict[@"accessiblite"] allValues];
        }
        // Services
        self.services = [[NSArray alloc] init];
        if ([aDict[@"services"] isKindOfClass:[NSDictionary class]]) {
            self.services       = [aDict[@"services"] allValues];
        }
        // URL
        self.url            = aDict[@"url"];
    }
    return self;
}
@end

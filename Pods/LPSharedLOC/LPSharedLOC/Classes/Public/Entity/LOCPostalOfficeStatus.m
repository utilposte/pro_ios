//
//  PostalOfficeStatus.m
//  laposte
//
//  Created by Issam DAHECH on 24/07/2017.
//  Copyright © 2017 laposte. All rights reserved.
//

#import "LOCPostalOfficeStatus.h"

@implementation LOCPostalOfficeStatus
- (id)initWithStatus:(NSDictionary *)aDict {
    
    if (self = [super init]) {
        self.dateCalcul         = aDict[@"dateCalcul"];
        self.dateChangement     = aDict[@"dateChangement"];
        self.heure              = aDict[@"heure"];
        self.statut             = aDict[@"statut"];
        NSNumber *boolNumber    = aDict[@"isDOM"];
        self.isDOM              = [boolNumber boolValue];
    }
    return self;
}

@end

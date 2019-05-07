//
//  HYBOrderEntry+missingFields.m
//  laposteCommon
//
//  Created by Hobart Wong on 15/03/2016.
//  Copyright © 2016 DigitasLBi. All rights reserved.
//

#import "HYBOrderEntry+MissingFields.h"

@implementation HYBOrderEntry (MissingFields)

-(NSString*) getCountry {
    return @"France";
}

-(float) getWeight {
    return 100.0f;
}

-(NSString*) getdetailFieldsText {
    return @"Caracteristiques\n\nNature de l'envoi\nLettre verte\nDestination autorisee\nFrance\nNombre de timbres\n12";
}


@end

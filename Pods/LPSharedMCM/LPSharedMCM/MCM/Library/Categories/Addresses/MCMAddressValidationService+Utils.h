//
//  MCMAddressValidationService+Utils.h
//  laposte
//
//  Created by Ricardo Suarez on 20/07/16.
//  Copyright © 2016 laposte. All rights reserved.
//

#import "MCMAddressValidationService.h"

@interface MCMAddressValidationService (Utils)

+(NSDictionary *) removeSpecialCharactersFromAddressComponents:(NSDictionary *) components;

@end

//
//  MCMNewAddressValidationHelper.h
//  laposte
//
//  Created by Ricardo Suarez on 10/02/16.
//  Copyright © 2016 laposte. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCMNewAddressValidationHelper : NSObject

+ (BOOL) validateFrancePostalCode:(NSString *) postalCode;

@end

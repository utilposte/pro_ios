//
//  MCMNewAddressValidationHelper.m
//  laposte
//
//  Created by Ricardo Suarez on 10/02/16.
//  Copyright © 2016 laposte. All rights reserved.
//

#import "MCMNewAddressValidationHelper.h"

NSString *const France_Postal_Code_Regex = @"^(F-)?((2[A|B])|[0-9]{2})[0-9]{3}$";

@implementation MCMNewAddressValidationHelper

#pragma mark - ---- LIFE CICLE

#pragma mark - ---- INTERNAL

#pragma mark - ---- PUBLIC

+ (BOOL) validateTextOnlyNumbers:(NSString *) text {
    NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:text];
    return [alphaNums isSupersetOfSet:inStringSet];
    
}

+ (BOOL) validateFrancePostalCode:(NSString *) postalCode {
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:France_Postal_Code_Regex
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    if (error) {
        NSLog(@"error %@", error);
    }
    
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:postalCode
                                                        options:0
                                                          range:NSMakeRange(0, [postalCode length])];
    return numberOfMatches > 0 && [MCMNewAddressValidationHelper validateTextOnlyNumbers:postalCode];
}

@end

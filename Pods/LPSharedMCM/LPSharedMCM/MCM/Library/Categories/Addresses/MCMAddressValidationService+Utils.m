//
//  MCMAddressValidationService+Utils.m
//  laposte
//
//  Created by Ricardo Suarez on 20/07/16.
//  Copyright © 2016 laposte. All rights reserved.
//

#import "MCMAddressValidationService+Utils.h"

@implementation MCMAddressValidationService (Utils)

#pragma mark - ---- LIFE CICLE

#pragma mark - ---- INTERNAL

#pragma mark - ---- PUBLIC

+(NSDictionary *) removeSpecialCharactersFromAddressComponents:(NSDictionary *) components {
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:components];
    for (NSString *key in components) {
        NSString *newValue = [components[key] stringByReplacingOccurrencesOfString:@"-" withString:@" "];
        newValue = [newValue stringByReplacingOccurrencesOfString:@"/" withString:@""];
        [result setObject:newValue forKey:key];
    }
    return result;
}

@end

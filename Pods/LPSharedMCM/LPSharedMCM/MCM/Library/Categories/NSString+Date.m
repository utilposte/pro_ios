//
//  NSString+Date.m
//  laposteCommon
//
//  Created by Ricardo Suarez on 20/04/16.
//  Copyright © 2016 DigitasLBi. All rights reserved.
//

#import "NSString+Date.h"

@implementation NSString (Date)

#pragma mark - ---- LIFE CICLE

#pragma mark - ---- INTERNAL

#pragma mark - ---- PUBLIC

- (NSString *) getFormattedDateText {
    NSDate *date = [self getDate];
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    return [dateFormatter stringFromDate:date];
}

- (NSDate *) getDate {
    NSDateFormatter *dateStringFormatter  = [NSDateFormatter new];
    [dateStringFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
    [dateStringFormatter setDateFormat:@"yyy-MM-dd'T'HH:mm:ssZZZZZ"];
    return [dateStringFormatter dateFromString:self];
}

@end

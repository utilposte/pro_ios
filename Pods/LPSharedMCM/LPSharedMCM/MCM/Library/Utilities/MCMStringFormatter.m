//
//  MCMStringFormatter.m
//  laposteCommon
//
//  Created by Hobart Wong on 07/03/2016.
//  Copyright © 2016 DigitasLBi. All rights reserved.
//

#import "MCMStringFormatter.h"

@interface MCMStringFormatter()
{
    NSNumberFormatter* _currencyFormatter;
    NSDateFormatter* _dateFormatter;
    NSDateFormatter* _hybrisAPIdateFormatter;
}

@end

@implementation MCMStringFormatter

+ (MCMStringFormatter *)sharedInstance
{
    static dispatch_once_t once;
    static MCMStringFormatter *_sharedInstance;
    dispatch_once(&once, ^ {
        _sharedInstance = [[MCMStringFormatter alloc] init];
    });
    return _sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        //init the location service
        _currencyFormatter = [[NSNumberFormatter alloc] init];
        [_currencyFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
        [_currencyFormatter setLocale:[NSLocale currentLocale]];
        
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"dd-MM-yyyy"];
        
        _hybrisAPIdateFormatter = [[NSDateFormatter alloc] init];
        [_hybrisAPIdateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'+'zzzz"];
        [_hybrisAPIdateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    }
    return self;
}

-(NSString*) currencyStringForPrice:(NSNumber*) price {
    return [_currencyFormatter stringFromNumber:price];
}

-(NSString*) dateStringForDate:(NSDate*) date {
    return [_dateFormatter stringFromDate:date];
}

-(NSDate*) dateFromHybrisAPIString:(NSString*) dateString {
    NSDate* date = [_hybrisAPIdateFormatter dateFromString:dateString];
    return date;
}




@end

//
//  MCMStringFormatter.h
//  laposteCommon
//
//  Created by Hobart Wong on 07/03/2016.
//  Copyright © 2016 DigitasLBi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCMStringFormatter : NSObject

+ (MCMStringFormatter *)sharedInstance;
-(NSString*) currencyStringForPrice:(NSNumber*) price;
-(NSString*) dateStringForDate:(NSDate*) date;
-(NSDate*) dateFromHybrisAPIString:(NSString*) dateString;

@end

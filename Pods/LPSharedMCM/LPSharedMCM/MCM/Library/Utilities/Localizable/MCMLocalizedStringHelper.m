//
//  MCMLocalizedStringHelper.m
//  laposte
//
//  Created by Jerilyn Goncalves Figueira on 16/08/16.
//  Copyright © 2016 laposte. All rights reserved.
//

#import "MCMLocalizedStringHelper.h"
#import "MCMBundleHelper.h"

@implementation MCMLocalizedStringHelper

+ (NSString *)stringForKey:(NSString *)key {
    
    NSString *result = [[MCMBundleHelper moduleBundle] localizedStringForKey:key value:@"" table:@"MCMLocalizable"];
    return result;
    
}

@end

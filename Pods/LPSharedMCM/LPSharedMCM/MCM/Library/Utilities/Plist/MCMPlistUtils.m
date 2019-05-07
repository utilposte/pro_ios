//
//  MCMPlistUtils.m
//  laposte
//
//  Created by Alberto Delgado on 29/07/16.
//  Copyright © 2016 laposte. All rights reserved.
//

#import "MCMPlistUtils.h"
#import "CocoaLumberjack.h"
#import "HYBConstants.h"

@implementation MCMPlistUtils

+ (id)readPlist:(NSString *)fileName inBundle:(NSBundle *)bundle {
    
    NSData *plistData;
    NSError *error;
    NSPropertyListFormat format;
    id plist;
    
    NSString *localizedPath = [bundle pathForResource:fileName ofType:@"plist"];
    plistData = [NSData dataWithContentsOfFile:localizedPath];
    
    if (plistData) {
        
        plist = [NSPropertyListSerialization propertyListWithData:plistData options:NSPropertyListImmutable format:&format error:&error];
        
        if (!plist) {
            DDLogDebug(@"Error reading plist from file '%s', error = '%@'", [localizedPath UTF8String], error.description);
        }
    
    }
    
    return plist;
}

+ (NSDictionary *)getDictionary:(NSString *)fileName inBundle:(NSBundle *)bundle {
    
    return (NSDictionary *)[self readPlist:fileName inBundle:bundle];
}

+ (NSString *)getValue:(NSString *)key fromPlist:(NSString *)fileName inBundle:(NSBundle *)bundle {
    
    NSDictionary *plist = [self getDictionary:fileName inBundle:bundle];
    
    if ([plist objectForKey:key] != nil) {
        return [plist objectForKey:key];
    }
    
    return nil;
}

@end

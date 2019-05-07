//
//  MCMStyles+Helper.m
//  laposte
//
//  Created by Jerilyn Goncalves Figueira on 01/08/16.
//  Copyright © 2016 laposte. All rights reserved.
//

#import "MCMStyles+Helper.h"
#import "MCMBundleHelper.h"
#import "MCMPlistUtils.h"
#import "UIColor+HEXValue.h"

@implementation MCMStyles (Helper)

#pragma mark - Public methods

- (NSDictionary *)loadStyles {
    
    NSDictionary *defaultStylesDictionary;
    NSDictionary *customStylesDictionary;
    
    defaultStylesDictionary = [MCMPlistUtils getDictionary:self.defaultStylesPlistName inBundle:[MCMBundleHelper moduleBundle]];
    
    if (self.customStylesPlistName) {
        
        customStylesDictionary = [MCMPlistUtils getDictionary:self.customStylesPlistName inBundle:[NSBundle mainBundle]];
        NSDictionary *stylesDictionary = [self mergeCustomStyles:customStylesDictionary withDefaultStyles:defaultStylesDictionary];
        
        return stylesDictionary;
        
    } else {
        
        NSDictionary *defaultStyles = [self flattenStylesDictionary:defaultStylesDictionary];
        return defaultStyles;
    
    }
}

- (id)valueForKeys:(NSArray *)keys {

    NSMutableString *formattedKey;
    for (NSString *key in keys) {
        
        if (formattedKey) {
            
            [formattedKey appendString:@"-"];
            [formattedKey appendString:key];
        
        } else {
        
            formattedKey = [[NSMutableString alloc] initWithString:key];
        }
    
    }
    
    return self.stylesDictionary[formattedKey];
}

#pragma mark - Private helpers

- (NSDictionary *)mergeCustomStyles:(NSDictionary *)customStylesDictionary withDefaultStyles:(NSDictionary *)defaultStylesDictionary {
    
    NSMutableDictionary *defaultStyles = [self flattenStylesDictionary:defaultStylesDictionary];
    NSMutableDictionary *customStyles = [self flattenStylesDictionary:customStylesDictionary];
    
    [defaultStyles addEntriesFromDictionary:customStyles];
    
    return defaultStyles;
    
}

- (NSMutableDictionary *)flattenStylesDictionary:(NSDictionary *)stylesDictionary {
    
    NSMutableDictionary *result = [self normalizeColorValuesForStylesDictionary:stylesDictionary];
    [self flattenNestedDictionary:stylesDictionary intoFlatDictionary:result withRootKey:nil];
    
    return result;

}

- (void)flattenNestedDictionary:(NSDictionary *)nestedDictionary intoFlatDictionary:(NSMutableDictionary *)flatDictionary withRootKey:(NSString *)rootKey {
    
    for (id key in nestedDictionary) {
        
        id nestedValue = nestedDictionary[key];
        NSString *nestedKey = rootKey ? [NSString stringWithFormat:@"%@-%@", rootKey, key] : key;

        if ([nestedValue isKindOfClass:[NSDictionary class]]) {
            
            // Iterate
            [self flattenNestedDictionary:nestedValue intoFlatDictionary:flatDictionary withRootKey:nestedKey];
            
        } else if ([nestedValue isKindOfClass:[NSNumber class]] && nestedValue >= 0) {
            
            // Number values
            [flatDictionary setValue:nestedValue forKey:nestedKey];
            
        } else if ([nestedValue isKindOfClass:[NSString class]]) {
            
            // String values
            if ([[nestedKey componentsSeparatedByString:MCM_Color_Dictionary_Key] count] > 1) {
                
                    UIColor *color = [self colorForValue:nestedValue inDictionary:flatDictionary];
                    if (color) {
                        [flatDictionary setValue:color forKey:nestedKey];
                    } else {
                        
                        NSString *parentColorKey = [NSString stringWithFormat:@"%@-%@", MCM_Color_Dictionary_Key, key];
                        UIColor *parentColorValue = flatDictionary[parentColorKey];
                        if (parentColorValue) {
                            [flatDictionary setValue:parentColorValue forKey:nestedKey];
                        }
                        
                    }
                
            } else {
                
                [flatDictionary setValue:nestedValue forKey:nestedKey];
            
            }
        }
    }
}

- (UIColor *)colorForValue:(NSString *)value inDictionary:(NSDictionary *)dictionary {
    
    if ([value isEqualToString:MCM_Color_Primary_Key] || [value isEqualToString:MCM_Color_Secondary_Key] || [value isEqualToString:MCM_Color_Alternative_Key]) {
        
        NSString *parentColorKey = [NSString stringWithFormat:@"%@-%@", MCM_Color_Dictionary_Key, value];
        return dictionary[parentColorKey];
        
    } else {
        
        UIColor *color = [UIColor colorWithHexString:value];
        return color;
        
    }

    
}

- (NSMutableDictionary *)normalizeColorValuesForStylesDictionary:(NSDictionary *)stylesDictionary {
    
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    
    NSDictionary *colorsDictionary = stylesDictionary[MCM_Color_Dictionary_Key];
    if (colorsDictionary) {
        
        for (NSString *colorKey in @[MCM_Color_Primary_Key, MCM_Color_Secondary_Key, MCM_Color_Alternative_Key]) {
        
            NSString *colorValue = colorsDictionary[colorKey];
            if (colorValue) {
                
                UIColor *color = [UIColor colorWithHexString:colorValue];
                if (color) {
                    
                    [result setValue:color forKey:[NSString stringWithFormat:@"%@-%@", MCM_Color_Dictionary_Key, colorKey]];
                }
            }
        }
    }
    
    return result;
}

@end

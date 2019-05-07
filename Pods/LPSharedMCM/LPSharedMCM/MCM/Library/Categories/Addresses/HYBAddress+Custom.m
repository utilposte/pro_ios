//
//  HYBAddress+Custom.m
//  laposte
//
//  Created by Ricardo Suarez on 04/02/16.
//  Copyright © 2016 laposte. All rights reserved.
//

#import "HYBAddress+Custom.h"
#import "HYBAddress.h"
#import "HYBCountry.h"
#import "MCMDefine.h"

#import <objc/runtime.h>

@implementation HYBAddress (Custom)
@dynamic apartment;
@dynamic building;

#pragma mark - ---- LIFE CICLE

#pragma mark - ---- INTERNAL

- (BOOL)isEqualToAddresss:(HYBAddress *)address {
    if (!address) {
        return NO;
    }
    
    return [self.id isEqualToString: address.id];
}

#pragma mark - ---- PUBLIC

- (NSString *) getFormattedAddressString {
    
    NSMutableString *addressText = [[NSMutableString alloc] init];
    if (self.firstName.length > 0) {
        [addressText appendFormat:@"%@ ", self.firstName];
    }
    
    if (self.lastName.length > 0) {
        [addressText appendFormat:@"%@\n", self.lastName];
    }    
    
    if (self.apartment.length > 0) {
        [addressText appendFormat:@"%@ ", self.apartment];
    }
    
    if (self.building.length > 0) {
        [addressText appendFormat:@"%@\n", self.building];
    }
    
    if (self.line1.length > 0) {
        [addressText appendFormat:@"%@", self.line1];
    }
        
    if (self.line2.length > 0) {
        [addressText appendFormat:@" %@", self.line2];
    }
    [addressText appendFormat:@"\n"];
    
    if (self.postalCode.length > 0) {
        [addressText appendFormat:@"%@", self.postalCode];
    }
        
    if (self.town.length > 0) {
        [addressText appendFormat:@" %@", self.town];
    }
    
    [addressText appendFormat:@"\nFRANCE"];
    
    return addressText;
}

-(void) appendString:(NSMutableString*) buildString withValue:(NSString*) string {
    if (buildString.length > 0) {
        [buildString appendFormat:@"\n%@", string];
    } else {
        [buildString appendFormat:@"%@", string];
    }
}

- (void)setApartment:(id)object {
    objc_setAssociatedObject(self, @selector(apartment), object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)apartment {
    return objc_getAssociatedObject(self, @selector(apartment));
}

- (void)setBuilding:(id)object {
    objc_setAssociatedObject(self, @selector(building), object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)building {
    return objc_getAssociatedObject(self, @selector(building));
}

- (BOOL) isInFrance {
    return [self.country.isocode isEqual:kFranceISOCode];
}


#pragma mark - NSObject

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[HYBAddress class]]) {
        return NO;
    }
    
    return [self isEqualToAddresss:(HYBAddress *)object];
}

@end

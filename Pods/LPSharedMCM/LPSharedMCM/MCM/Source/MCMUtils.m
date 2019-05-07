//
//  MCMUtils.m
//  Pods
//
//  Created by Mohamed Helmi Ben Jabeur on 02/05/2017.
//
//

#import "MCMUtils.h"
#import "StringUtils.h"

@implementation MCMUtils

+ (BOOL) isEmptyAddress:(HYBAddress *) address {
    if(address == nil)
        return YES;
    else if([StringUtils isEmptyOrNil:address.line1] ||  [StringUtils isEmptyOrNil:address.postalCode] || [StringUtils isEmptyOrNil:address.town])
        return YES;
    else
        return NO;
}

+ (NSString *)removeNonAutorisedCharacter:(NSString *)text {
    NSData *temp = [text dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    return [[NSString alloc] initWithData:temp encoding:NSASCIIStringEncoding];
}

@end

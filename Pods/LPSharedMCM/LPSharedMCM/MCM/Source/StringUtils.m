//
//  StringUtils.m
//  Pods
//
//  Created by Mohamed Helmi Ben Jabeur on 28/04/2017.
//
//

#import "StringUtils.h"

@implementation StringUtils


+ (BOOL) isEmptyOrNil:(NSString *) stringForTest{
    if([stringForTest isEqualToString:@""] || stringForTest == nil)
        return YES;
    else
        return NO;
}

@end

//
//  MCMTrackingKeyHelper.m
//  MCommerce
//
//  Created by Jerilyn Goncalves Figueira on 05/09/16.
//  Copyright © 2016 DigitasLBi. All rights reserved.
//

#import "MCMTrackingKeyHelper.h"
#import "MCMBundleHelper.h"

@implementation MCMTrackingKeyHelper

+ (NSString *)trackingKeyForScreenWithName:(NSString *)screenName {

    NSString *formattedScreenName = [NSString stringWithFormat:@"MCMTracking_Layout_ID_%@", screenName];
    NSString *trackingKey = [[MCMBundleHelper moduleBundle] localizedStringForKey:formattedScreenName value:@"" table:@"MCMTrackingKeys"];
    
    return trackingKey;
}

@end

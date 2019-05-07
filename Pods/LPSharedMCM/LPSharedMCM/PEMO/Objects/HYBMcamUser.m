//
//  HYBMcamExpediteur.m
//  LPSharedMCM
//
//  Created by Issam DAHECH on 04/05/2018.
//

#import "HYBMcamUser.h"
#import "HYBMcamCountry.h"

@implementation HYBMcamUser

+ (instancetype)mcamUserWithParams:(NSDictionary*)params {
    
    NSError *error = nil;
    HYBMcamUser *object = [MTLJSONAdapter modelOfClass:[HYBMcamUser class] fromJSONDictionary:params error:&error];
    
    if (error) {
        NSLog(@"1 Couldn't convert JSON to model HYBMcamExpediteur");
        return nil;
    }
    
    return object;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"country"                 : @"country",
             @"firstName"               : @"firstName",
             @"id"                      : @"idMcmaExpediteur",
             @"lastName"                : @"lastName",
             @"line1"                   : @"line1",
             @"postalCode"              : @"postalCode",
             @"shippingAddress"         : @"shippingAddress",
             @"town"                    : @"town",
             @"visibleInAddressBook"    : @"visibleInAddressBook"
             };
}

+ (NSValueTransformer *)countryJSONTransformer {
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[HYBMcamCountry class]];
}

@end

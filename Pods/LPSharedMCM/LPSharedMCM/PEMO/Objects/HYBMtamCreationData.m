//
//  HYBMtamCreationData.m
//  LPSharedMCM
//
//  Created by Issam DAHECH on 30/04/2018.
//

#import "HYBMtamCreationData.h"

@implementation HYBMtamCreationData


+ (instancetype)mtamCreationDataWithParams:(NSDictionary*)params {
    
    NSError *error = nil;
    HYBMtamCreationData *object = [MTLJSONAdapter modelOfClass:[HYBMtamCreationData class] fromJSONDictionary:params error:&error];
    
    if (error) {
        NSLog(@"1 Couldn't convert JSON to model HYBMtamCreationData");
        return nil;
    }
    
    return object;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"destination"             : @"destination",
             @"nature"                  : @"nature",
             @"orientation"             : @"orientation",
             @"poids"                   : @"poids",
             @"prixaffranchissement"    : @"prixaffranchissement",
             @"prixpersonnalisation"    : @"prixpersonnalisation",
             @"typeproduit"             : @"typeproduit",
             @"nomcreation"             : @"nomcreation",
             @"url"                     : @"url"
             };
}


@end

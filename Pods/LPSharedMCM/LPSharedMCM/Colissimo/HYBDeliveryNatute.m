//
//  HYBDeliveryNatute.m
//  LPSharedMCM
//
//  Created by SPASOV DIMITROV Vladimir on 7/11/18.
//

#import "HYBDeliveryNatute.h"

@implementation HYBDeliveryNatute

+ (instancetype)customsFormalitiesWithParams:(NSDictionary*)params {
    
    NSError *error = nil;
    HYBDeliveryNatute *object = [MTLJSONAdapter modelOfClass:[HYBDeliveryNatute class] fromJSONDictionary:params error:&error];
    
    if (error) {
        NSLog(@"1 Couldn't convert JSON to model HYBDeliveryNatute");
        return nil;
    }
    
    return object;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"code": @"code",
             @"nom": @"nom"
             };
}

@end

//
//  HYBCustomsFormalities.m
//  LPSharedMCM
//
//  Created by SPASOV DIMITROV Vladimir on 7/11/18.
//

#import "HYBCustomsFormalities.h"
#import "HYBPackageContents.h"
#import "HYBDeliveryNatute.h"

#import "NSValueTransformer+MTLPredefinedTransformerAdditions.h"

@implementation HYBCustomsFormalities

+ (instancetype)customsFormalitiesWithParams:(NSDictionary*)params {
    
    NSError *error = nil;
    HYBCustomsFormalities *object = [MTLJSONAdapter modelOfClass:[HYBCustomsFormalities class] fromJSONDictionary:params error:&error];
    
    if (error) {
        NSLog(@"1 Couldn't convert JSON to model HYBCustomsFormalities");
        return nil;
    }
    
    return object;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"natureEnvoi": @"natureEnvoi",
             @"code": @"code",
             @"contenusColis": @"contenusColis",
             @"returnReason": @"returnReason"
             };
}

+ (NSValueTransformer *)contenusColisJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[HYBPackageContents class]];
}

+ (NSValueTransformer *)natureEnvoiJSONTransformer {
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[HYBDeliveryNatute class]];
}

@end

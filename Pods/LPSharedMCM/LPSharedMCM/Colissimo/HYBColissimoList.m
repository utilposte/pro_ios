//
//  HYBColissimoList.m
//  LPSharedMCM
//
//  Created by SPASOV DIMITROV Vladimir on 15/11/2018.
//

#import "HYBColissimoList.h"
#import "HYBColissimoCreationData.h"

#import "NSValueTransformer+MTLPredefinedTransformerAdditions.h"


@implementation HYBColissimoList

+ (instancetype)colissimoListWithParams:(NSDictionary*)params {
    
    NSError *error = nil;
    HYBColissimoList *object = [MTLJSONAdapter modelOfClass:[HYBColissimoList class] fromJSONDictionary:params error:&error];
    
    if (error) {
        NSLog(@"Couldn't convert JSON to model HYBCollisimoList");
        return nil;
    }
    
    return object;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"products" : @"products"
             };
}

+ (NSValueTransformer *)productsJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[HYBColissimoCreationData class]];
}

@end

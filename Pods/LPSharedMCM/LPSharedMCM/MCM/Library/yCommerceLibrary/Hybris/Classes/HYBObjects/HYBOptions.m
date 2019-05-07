//
//  HYBOptions.m
// [y] hybris Platform
//
//  Created by Sofien Azzouz on 27/09/2017.
//

#import "HYBOptions.h"
#import "NSValueTransformer+MTLPredefinedTransformerAdditions.h"
#import "HYBReexContract.h"
#import "HYBMtamCreationData.h"
#import "HYBMcamCreationData.h"
#import "HYBMcamPackCreationData.h"
#import "HYBColissimoCreationData.h"

@implementation HYBOptions

+ (instancetype)optionsWithParams:(NSDictionary*)params {
    
    NSError *error = nil;
    HYBOptions *object = [MTLJSONAdapter modelOfClass:[HYBOptions class] fromJSONDictionary:params error:&error];
    
    if (error) {
        NSLog(@"1 Couldn't convert JSON to model HYBOptions");
        return nil;
    }
    
    return object;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"reexContract" : @"reexContract",
             @"mtamCreationData" : @"mtamCreationData",
             @"mcamCreationData" : @"mcamCreationData",
             @"mcamPackCreationData" : @"mcamPackCreationData",
             @"colissimoColisData" : @"colissimoColisData"
             };
}

+ (NSValueTransformer *)reexContractJSONTransformer {
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[HYBReexContract class]];
}

+ (NSValueTransformer *)mtamCreationDataJSONTransformer {
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[HYBMtamCreationData class]];
}

+ (NSValueTransformer *)mcamCreationDataJSONTransformer {
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[HYBMcamCreationData class]];
}

+ (NSValueTransformer *)mcamPackCreationDataJSONTransformer {
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[HYBMcamPackCreationData class]];
}

+ (NSValueTransformer *)colissimoColisDataJSONTransformer {
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[HYBColissimoCreationData class]];
}
@end

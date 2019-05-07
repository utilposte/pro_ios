//
//  HYBMcamCreationData.m
//  AFNetworking
//
//  Created by Issam DAHECH on 04/05/2018.
//

#import "HYBMcamCreationData.h"
#import "HYBMcamUser.h"
#import "HYBMcamRectoVersoImage.h"

@implementation HYBMcamCreationData

+ (instancetype)mcamCreationDataWithParams:(NSDictionary*)params {
    
    NSError *error = nil;
    HYBMcamCreationData *object = [MTLJSONAdapter modelOfClass:[HYBMcamCreationData class] fromJSONDictionary:params error:&error];
    
    if (error) {
        NSLog(@"1 Couldn't convert JSON to model HYBMcamCreationData");
        return nil;
    }
    
    return object;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"expediteur"      : @"expediteur",
             @"frontUrl"        : @"frontUrl",
             @"location"        : @"location",
             @"lstDestinataire" : @"lstDestinataire",
             @"frontImages"     : @"frontImages"
             };
}

+ (NSValueTransformer *)lstDestinataireJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[HYBMcamUser class]];
}

+ (NSValueTransformer *)frontImagesJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[HYBMcamRectoVersoImage class]];
}

+ (NSValueTransformer *)expediteurJSONTransformer {
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[HYBMcamUser class]];
}
@end

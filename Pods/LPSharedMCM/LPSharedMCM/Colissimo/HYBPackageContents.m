//
//  HYBPackageContents.m
//  LPSharedMCM
//
//  Created by SPASOV DIMITROV Vladimir on 7/11/18.
//

#import "HYBPackageContents.h"

@implementation HYBPackageContents

+ (instancetype)customsFormalitiesWithParams:(NSDictionary*)params {
    
    NSError *error = nil;
    HYBPackageContents *object = [MTLJSONAdapter modelOfClass:[HYBPackageContents class] fromJSONDictionary:params error:&error];
    
    if (error) {
        NSLog(@"1 Couldn't convert JSON to model HYBPackageContents");
        return nil;
    }
    
    return object;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"descriptionArticle": @"descriptionArticle",
             @"poidsNet": @"poidsNet",
             @"quantite": @"quantite",
             @"valeurUnitaire": @"valeurUnitaire",
//             @"paysOrigine": @"paysOrigine",
//             @"numeroTarifaire": @"numeroTarifaire"
             };
}

@end

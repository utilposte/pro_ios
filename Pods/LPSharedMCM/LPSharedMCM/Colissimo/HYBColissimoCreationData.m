//
//  HYBColissimoCreationData.m
//  LPSharedMCM
//
//  Created by SPASOV DIMITROV Vladimir on 7/11/18.
//

#import "HYBColissimoCreationData.h"

#import "HYBAddress.h"
#import "HYBPrice.h"
#import "HYBCustomsFormalities.h"



@implementation HYBColissimoCreationData

+ (instancetype)colissimoCreationDataWithParams:(NSDictionary*)params {
    
    NSError *error = nil;
    HYBColissimoCreationData *object = [MTLJSONAdapter modelOfClass:[HYBColissimoCreationData class] fromJSONDictionary:params error:&error];
    
    if (error) {
        NSLog(@"1 Couldn't convert JSON to model HYBColissimoCreationData");
        return nil;
    }
    
    return object;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"expediteurAddress": @"expediteurAddress",
             @"deliveryAddress": @"deliveryAddress",
             @"toIsoCode": @"toISOCode",
             @"fromIsoCode": @"fromISOCode",
             @"colisRegime": @"colisRegime",
             @"typeColis": @"typeColis",
             @"modeDepot": @"modeDepot",
             @"modeLivraison": @"modeLivraison",
             @"avecAssurance": @"avecAssurance",
             @"dateDepot": @"dateDepot",
             @"formalitesDouaniere": @"formalitesDouaniere",
             @"poidsColis": @"poidsColis",
             @"indemnitePlus": @"isIndemnitePlus",
             @"totalNetPriceColis": @"totalNetPriceColis",
             
             @"pkColisFavoris": @"pkColisFavoris",
             
             
             @"labelAssuranceColis": @"labelAssuranceColis",
             @"totalNetPriceAssurance": @"totalNetPriceAssurance",
             @"recommendationLevel": @"recommendationLevel",
             @"typeSupplColis": @"typeSupplColis",
             @"totalNetPriceSurcout": @"totalNetPriceSurcout",
             @"insuredValue": @"insuredValue",
             @"refColis": @"refColis",
             @"suiviEmail": @"suiviEmail",
             @"emailDestinataire": @"emailDestinataire",
             @"avecSiganture": @"avecSiganture",
             @"nameColisFavoris": @"nameColisFavoris",
             @"originalId": @"originalID",
             @"id": @"identifier",
             @"livraisonAvecSignature": @"isLivraisonAvecSignature"
             };
}


+ (NSValueTransformer *)expediteurAddressJSONTransformer {
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[HYBAddress class]];
}

+ (NSValueTransformer *)deliveryAddressJSONTransformer {
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[HYBAddress class]];
}

+ (NSValueTransformer *)formalitesDouaniereJSONTransformer {
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[HYBCustomsFormalities class]];
}

+ (NSValueTransformer *)totalNetPriceAssuranceJSONTransformer {
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[HYBPrice class]];
}

+ (NSValueTransformer *)totalNetPriceSurcoutJSONTransformer {
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[HYBPrice class]];
}

+ (NSValueTransformer *)totalNetPriceColisJSONTransformer {
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[HYBPrice class]];
}

@end

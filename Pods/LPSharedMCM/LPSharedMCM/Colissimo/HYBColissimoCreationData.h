//
//  HYBColissimoCreationData.h
//  LPSharedMCM
//
//  Created by SPASOV DIMITROV Vladimir on 7/11/18.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>


@class HYBAddress;
@class HYBPrice;
@class HYBCustomsFormalities;

@interface HYBColissimoCreationData : MTLModel <MTLJSONSerializing>

@property (nonatomic, nullable) HYBAddress *expediteurAddress;
@property (nonatomic, nullable) HYBAddress *deliveryAddress;
@property (nonatomic, nullable) NSString *toISOCode;
@property (nonatomic, nullable) NSString *fromISOCode;
@property (nonatomic, nullable) NSString *colisRegime;
@property (nonatomic, nullable) NSString *typeColis;
@property (nonatomic, nullable) NSString *modeDepot;
@property (nonatomic, nullable) NSString *modeLivraison;
@property (nonatomic) BOOL avecAssurance;
@property (nonatomic, nullable) NSString *dateDepot;
@property (nonatomic, nullable) NSArray<NSString *> *suiviEmail;
@property (nonatomic, nullable) NSString *emailDestinataire;
@property (nonatomic, nullable) HYBCustomsFormalities *formalitesDouaniere;
@property (nonatomic, nullable) NSString *refColis;
@property (nonatomic, nullable) NSDecimalNumber *poidsColis;
@property (nonatomic) BOOL avecSiganture;
@property (nonatomic) BOOL isIndemnitePlus;
@property (nonatomic, nullable) NSString *labelAssuranceColis;
@property (nonatomic, nullable) HYBPrice *totalNetPriceAssurance;
@property (nonatomic, nullable) NSString *recommendationLevel;
@property (nonatomic, nullable) NSString *typeSupplColis;
@property (nonatomic, nullable) HYBPrice *totalNetPriceSurcout;
@property (nonatomic, nullable) NSDecimalNumber *insuredValue;
@property (nonatomic, nullable) HYBPrice *totalNetPriceColis;
@property (nonatomic, nullable) NSString *nameColisFavoris;
@property (nonatomic, nullable) NSString *originalID;
@property (nonatomic, nullable) NSString *identifier;
@property (nonatomic) BOOL isLivraisonAvecSignature;

@property (nonatomic) int pkColisFavoris;



+ (instancetype)colissimoCreationDataWithParams:(NSDictionary*)params;

@end


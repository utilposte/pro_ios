//
//  HYBPackageContents.h
//  LPSharedMCM
//
//  Created by SPASOV DIMITROV Vladimir on 7/11/18.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface HYBPackageContents : MTLModel <MTLJSONSerializing>

@property (nonatomic) NSString *descriptionArticle;
@property (nonatomic) NSDecimalNumber *poidsNet;
@property (nonatomic) NSInteger quantite;
@property (nonatomic) NSDecimalNumber *valeurUnitaire;
@property (nonatomic) NSString *paysOrigine;
@property (nonatomic) NSString *numeroTarifaire;

@end


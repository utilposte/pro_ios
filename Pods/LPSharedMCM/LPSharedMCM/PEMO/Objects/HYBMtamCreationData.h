//
//  HYBMtamCreationData.h
//  LPSharedMCM
//
//  Created by Issam DAHECH on 30/04/2018.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface HYBMtamCreationData : MTLModel <MTLJSONSerializing>

@property (nonatomic) NSString *destination;
@property (nonatomic) NSString *nature;
@property (nonatomic) NSString *orientation;
@property (nonatomic) NSString *poids;
@property (nonatomic) NSString *typeproduit;
@property (nonatomic) NSString *url;
@property (nonatomic) NSNumber *prixaffranchissement;
@property (nonatomic) NSNumber *prixpersonnalisation;
@property (nonatomic) NSString *nomcreation;
@property (nonatomic) NSNumber *duration;


+ (instancetype)mtamCreationDataWithParams:(NSDictionary*)params;

@end

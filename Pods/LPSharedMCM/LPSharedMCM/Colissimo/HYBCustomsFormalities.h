//
//  HYBCustomsFormalities.h
//  LPSharedMCM
//
//  Created by SPASOV DIMITROV Vladimir on 7/11/18.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>


@class HYBDeliveryNatute;
@class HYBPackageContents;

@interface HYBCustomsFormalities : MTLModel <MTLJSONSerializing>

@property (nonatomic) HYBDeliveryNatute *natureEnvoi;
@property (nonatomic) NSString *code;
@property (nonatomic) NSArray *contenusColis;
@property (nonatomic) NSString * returnReason;

+ (instancetype)customsFormalitiesWithParams:(NSDictionary*)params;

@end


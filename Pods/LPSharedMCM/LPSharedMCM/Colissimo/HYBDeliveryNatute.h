//
//  HYBDeliveryNatute.h
//  LPSharedMCM
//
//  Created by SPASOV DIMITROV Vladimir on 7/11/18.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface HYBDeliveryNatute : MTLModel <MTLJSONSerializing>

@property (nonatomic) NSString *code;
@property (nonatomic) NSString *nom;

+ (instancetype)deliveryNatuteWithParams:(NSDictionary*)params;

@end


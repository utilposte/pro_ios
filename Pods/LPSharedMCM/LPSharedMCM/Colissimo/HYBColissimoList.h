//
//  HYBColissimoList.h
//  LPSharedMCM
//
//  Created by SPASOV DIMITROV Vladimir on 15/11/2018.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface HYBColissimoList : MTLModel <MTLJSONSerializing>

@property (nonatomic) NSArray *products;

+ (instancetype)colissimoListWithParams:(NSDictionary*)params;

@end


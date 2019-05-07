//
//  HYBDestinationEnvoi.h
//  Pods
//
//  Created by Rafik ISSOLAH - Direction du numérique on 07/03/2016.
//
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>




@interface HYBDestinationEnvoi : MTLModel <MTLJSONSerializing>

@property (nonatomic) NSString *code;
@property (nonatomic) NSString *label;



+ (instancetype)destinationEnvoiWithParams:(NSDictionary*)params;

@end


//
//  HYBDestinationEnvoi2.h
//  Pods
//
//  Created by Rafik ISSOLAH - Direction du numérique on 07/03/2016.
//
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>




@interface HYBDestinationEnvoi2 : MTLModel <MTLJSONSerializing>

@property (nonatomic) NSString *code;
@property (nonatomic) NSString *label;



+ (instancetype)destinationEnvoi2WithParams:(NSDictionary*)params;

@end

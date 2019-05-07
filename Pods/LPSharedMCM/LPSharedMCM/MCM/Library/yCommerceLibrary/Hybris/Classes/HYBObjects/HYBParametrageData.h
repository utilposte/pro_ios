//
//  HYBParametrageData.h
//  Pods
//
//  Created by Nabil KAABI on 31/03/16.
//
//


#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>




@interface HYBParametrageData : MTLModel <MTLJSONSerializing>

@property (nonatomic) NSString *code;
@property (nonatomic) NSString *label;



+ (instancetype)parametrageDataWithParams:(NSDictionary*)params;

@end

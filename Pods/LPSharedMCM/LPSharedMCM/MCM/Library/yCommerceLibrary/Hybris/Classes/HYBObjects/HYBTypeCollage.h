//
//  HYBTypeCollage.h
//  Pods
//
//  Created by Rafik ISSOLAH Direction du numérique on 07/03/2016.
//
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>




@interface HYBTypeCollage : MTLModel <MTLJSONSerializing>

@property (nonatomic) NSString *code;
@property (nonatomic) NSString *label;



+ (instancetype)typeCollageWithParams:(NSDictionary*)params;

@end

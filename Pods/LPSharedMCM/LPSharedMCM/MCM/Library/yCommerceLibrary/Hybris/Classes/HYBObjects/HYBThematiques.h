//
//  HYBThematiques.h
//  LPSharedMCM
//
//  Created by Yonael Tordjman on 20/02/2019.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface HYBThematiques: MTLModel <MTLJSONSerializing>

@property (nonatomic) NSString *label;
@property (nonatomic) NSString *code;

+ (instancetype)thematiquesWithParams:(NSDictionary*)params;

@end

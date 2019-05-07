//
//  HYBMcamCountry.h
//  LPSharedMCM
//
//  Created by Issam DAHECH on 04/05/2018.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface HYBMcamCountry : MTLModel <MTLJSONSerializing>

@property (nonatomic) NSString *isocode;
@property (nonatomic) NSString *name;

+ (instancetype)mcamCountryWithParams:(NSDictionary*)params;

@end

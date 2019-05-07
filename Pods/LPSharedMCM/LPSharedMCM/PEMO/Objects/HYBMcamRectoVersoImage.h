//
//  HYBMcamRectoImage.h
//  LPSharedMCM
//
//  Created by Issam DAHECH on 04/05/2018.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>
@interface HYBMcamRectoVersoImage : MTLModel <MTLJSONSerializing>

@property (nonatomic) NSString *format;
@property (nonatomic) NSString *url;

+ (instancetype)mcamRectoVersoWithParams:(NSDictionary*)params;

@end

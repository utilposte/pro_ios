//
//  HYBMcamCreationData.h
//  AFNetworking
//
//  Created by Issam DAHECH on 04/05/2018.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>


@class HYBMcamUser;
@interface HYBMcamCreationData : MTLModel <MTLJSONSerializing>

@property (nonatomic) HYBMcamUser       *expediteur;
@property (nonatomic) NSString          *frontUrl;
@property (nonatomic) NSString          *location;
@property (nonatomic) NSArray           *lstDestinataire;
@property (nonatomic) NSArray           *frontImages;

+ (instancetype)mcamCreationDataWithParams:(NSDictionary*)params;

@end

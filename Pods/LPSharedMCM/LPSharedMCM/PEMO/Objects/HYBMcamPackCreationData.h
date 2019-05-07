//
//  HYBMcamPackCreationData.h
//  LPSharedMCM
//
//  Created by Issam DAHECH on 04/06/2018.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface HYBMcamPackCreationData : MTLModel <MTLJSONSerializing>

@property (nonatomic) NSString *codeCreation;
@property (nonatomic) NSString *codeOffreCredit;
@property (nonatomic) NSString *codePack;
@property (nonatomic) NSString *isForGift;

+ (instancetype)mcamPackCreationDataWithParams:(NSDictionary*)params;

@end

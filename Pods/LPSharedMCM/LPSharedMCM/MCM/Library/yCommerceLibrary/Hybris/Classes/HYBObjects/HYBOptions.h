//
//  HYBOptions.h
// [y] hybris Platform
//
//  Created by Sofien Azzouz on 27/09/2017.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>


@class HYBReexContract;
@class HYBMtamCreationData;
@class HYBMcamCreationData;
@class HYBMcamPackCreationData;
@class HYBColissimoCreationData;



@interface HYBOptions : MTLModel <MTLJSONSerializing>

@property (nonatomic) HYBReexContract *reexContract;
@property (nonatomic) HYBMtamCreationData *mtamCreationData;
@property (nonatomic) HYBMcamCreationData *mcamCreationData;
@property (nonatomic) HYBMcamPackCreationData *mcamPackCreationData;
@property (nonatomic) HYBColissimoCreationData *colissimoColisData;

@end


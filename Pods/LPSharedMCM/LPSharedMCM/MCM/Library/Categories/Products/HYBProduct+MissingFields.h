//
//  HYBProduct+MissingFields.h
//  laposteCommon
//
//  Created by Hobart Wong on 07/03/2016.
//  Copyright © 2016 DigitasLBi. All rights reserved.
//

#import "HYBProduct.h"

@interface HYBProduct (MissingFields)

-(NSString*) getCountry;
-(NSString*) getWeight;
- (NSString *)getNatureOfPackage;
- (NSString *)getAuthorizedDestination;
- (NSString *)getModeDeCollage;
- (NSString *)getPermanentValidity;
- (NSString *)getValidityArea;
- (NSString *)getStampsFamilyName;
- (NSString *)getProductPresentationFormat;
- (NSString *)getCharacteristics;
- (NSString *)getEmissionDate;
- (NSString *)getLegalMentions;

- (NSDictionary *)getListOfAdditionalProductInformation;

- (NSString *) getFormattedWeight;

@end

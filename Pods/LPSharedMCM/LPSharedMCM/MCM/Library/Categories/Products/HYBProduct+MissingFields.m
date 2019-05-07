//
//  HYBProduct+MissingFields.m
//  laposteCommon
//
//  Created by Hobart Wong on 07/03/2016.
//  Copyright © 2016 DigitasLBi. All rights reserved.
//

#import "HYBProduct+MissingFields.h"
#import "HYBParametrageData.h"
#import "MCMStringFormatter.h"
#import "MCMLocalizedStringHelper.h"

@implementation HYBProduct (MissingFields)

//TODO: we'll later on, modify this category so the returned values are retrieved from the model directly

-(NSString*) getCountry
{
    return @"France";
}

-(NSString*) getWeight
{
    if(self.poidsMaxEnvoi.floatValue >= 0){
        return [NSString stringWithFormat:@"%.0f g", self.poidsMaxEnvoi.floatValue];
    } else {
        return nil;
    }
}

- (NSString *)getNatureOfPackage
{
    return self.delaiEnvoi.label;
}

- (NSString *)getAuthorizedDestination
{
    return [NSString stringWithFormat:@"%@ %@", self.destinationEnvoi.label, self.destinationEnvoi2.label];
}

- (NSString *)getModeDeCollage
{
    return self.typeCollage.label;
}

- (NSString *)getPermanentValidity
{
    return self.valeurPermanente ? [MCMLocalizedStringHelper stringForKey:@"Hybris::yes"] : [MCMLocalizedStringHelper stringForKey:@"Hybris::no"];
}

- (NSString *)getProductPresentationFormat
{
    return self.packaging.label;
}

- (NSString *)getValidityArea
{
    return self.zoneValidite;
}

//TODO: we leave this until Paris clarifies it.
- (NSString *)getStampsFamilyName
{
    return @"12";
}

- (NSString *)getCharacteristics
{
    return @"avancées";
}

- (NSString *)getEmissionDate
{
    return [[MCMStringFormatter sharedInstance] dateStringForDate:[[MCMStringFormatter sharedInstance] dateFromHybrisAPIString:self.dateEmissionLegale]];
}

//TODO: missing the dimensions timbre

- (NSString *)getStampSizing
{
    return self.formatAvecDents;
}

- (NSString *)getLegalMentions
{
    return self.mentionsLegales;
}

- (NSDictionary *)getListOfAdditionalProductInformation
{
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    
    [self addEntry:[self getNatureOfPackage] withTitle:[MCMLocalizedStringHelper stringForKey:@"Hybris::ProductDetail::Characteristics::PackageNature"] withDict:dict];
    [self addEntry:[self getAuthorizedDestination] withTitle:[MCMLocalizedStringHelper stringForKey:@"Hybris::ProductDetail::Characteristics::DestinationAuthorization"] withDict:dict];
    [self addEntry:[self getProductPresentationFormat] withTitle:[MCMLocalizedStringHelper stringForKey:@"Hybris::ProductDetail::Characteristics::ProductPresentation"] withDict:dict];
    [self addEntry:[self getWeight] withTitle:[MCMLocalizedStringHelper stringForKey:@"Hybris::ProductDetail::Characteristics::MaxWeight"] withDict:dict];
    [self addEntry:[self getModeDeCollage] withTitle:[MCMLocalizedStringHelper stringForKey:@"Hybris::ProductDetail::Characteristics::CollageMode"] withDict:dict];
    [self addEntry:[self getPermanentValidity] withTitle:[MCMLocalizedStringHelper stringForKey:@"Hybris::ProductDetail::Characteristics::PermanentValidity"] withDict:dict];
    [self addEntry:[self getValidityArea] withTitle:[MCMLocalizedStringHelper stringForKey:@"Hybris::ProductDetail::Characteristics::ValidiyZone"] withDict:dict];
    [self addEntry:[self getEmissionDate] withTitle:[MCMLocalizedStringHelper stringForKey:@"Hybris::ProductDetail::Characteristics::EmissionDate"] withDict:dict];
//    [self addEntry:[self getStampSizing] withTitle:[MCMLocalizedStringHelper stringForKey:@"Hybris::ProductDetail::Characteristics::StampSize"] withDict:dict];
//    [self addEntry:[self getLegalMentions] withTitle:[MCMLocalizedStringHelper stringForKey:@"Hybris::ProductDetail::Characteristics::LegalMentions"] withDict:dict];
    
    return [NSDictionary dictionaryWithDictionary:dict];           
}

-(void) addEntry:(NSString*) value withTitle:(NSString*) title withDict:(NSMutableDictionary*) dict {
    if (value) {
        dict[title] = value;
    }
}

- (NSString *)getFormattedWeight {
    
    return [NSString stringWithFormat:[MCMLocalizedStringHelper stringForKey:@"Hybris::ProductDetail::Characteristics::TotalWeigth"], [self getWeight]];
}

@end

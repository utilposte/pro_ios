//
//  LPAddressEntity.m
//  AFNetworking
//
//  Created by LaPoste on 26/11/2018.
//

#import "LPAddressEntity.h"

@implementation LPAddressEntity

-(NSString *) toString{
//    @property (nonatomic) NSString *civility;
//    @property (nonatomic) NSString *companyName;
//    @property (nonatomic) NSString *serviceName;
//    @property (nonatomic) NSString *firstName;
//    @property (nonatomic) NSString *lastName;
//    @property (nonatomic) NSString *email;
//    @property (nonatomic) NSString *phone;
//    @property (nonatomic) NSString *complementaryAddress;
//    @property (nonatomic) NSString *street;
//    @property (nonatomic) NSString *postalCode;
//    @property (nonatomic) NSString *locality;
//    @property (nonatomic) NSString *countryName;
//    @property (nonatomic) NSString *countryIsoCode;
//    @property (nonatomic) NSString *formattedAddress;
//    @property (nonatomic) NSString *placeIDForGooglePlaces;
//    @property (nonatomic) NSString *isLocal;
    
    NSString *civilty = [[NSString alloc] init];
    if ([[self.civility uppercaseString] isEqualToString:@"MR"]) {
        civilty = @"Mr";
    } else {
        civilty = @"Mme";
    }
    
    NSString * name = [NSString stringWithFormat:@"%@ %@ %@", civilty,self.firstName, self.lastName];
    NSString * city = [NSString stringWithFormat:@"%@ %@ ", self.postalCode,self.locality];
    
    if ((self.firstName == nil || self.lastName == nil) && self.companyName == nil) {
        return [NSString stringWithFormat: @"%@ \n%@ \n%@", self.street, city, self.countryName];
    } else if ((self.firstName == nil || self.lastName == nil) && self.companyName != nil) {
        return [NSString stringWithFormat: @"%@ \n%@ \n%@ \n%@", self.companyName, self.street, city, self.countryName];
    } else if ((self.firstName != nil && self.lastName != nil) && self.companyName == nil) {
        return [NSString stringWithFormat: @"%@ \n%@ \n%@ \n%@", name, self.street, city, self.countryName];
    } else {
        return [NSString stringWithFormat: @"%@ \n%@ \n%@ \n%@ \n%@", name, self.companyName, self.street, city, self.countryName];
    }
}


-(NSDictionary *)dictionary
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue:self.civility forKey:@"civility"];
    [dict setValue:self.companyName forKey:@"companyName" ];
    [dict setValue:self.serviceName forKey:@"serviceName"];
    [dict setValue:self.firstName forKey:@"firstName" ];
    [dict setValue:self.email forKey:@"email"];
    [dict setValue:self.phone forKey:@"phone" ];
    [dict setValue:self.complementaryAddress forKey:@"complementaryAddress" ];
    [dict setValue:self.street forKey:@"street"];
    [dict setValue:self.postalCode forKey:@"postalCode"];
    [dict setValue:self.locality forKey:@"locality" ];
    [dict setValue:self.countryName forKey:@"countryName"];
    [dict setValue:self.countryIsoCode forKey:@"countryIsoCode" ];
    
    return dict;
}

@end

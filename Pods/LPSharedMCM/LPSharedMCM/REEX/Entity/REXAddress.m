//
//  REXAddress.m
//  laposte
//
//  Created by Sofien Azzouz on 02/10/2017.
//  Copyright © 2017 laposte. All rights reserved.
//

#import "REXAddress.h"


@implementation REXAddress

- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    
    if (self) {
        self.adresseL3 = [dic objectForKey:@"adresseL3"];
        self.adresseL4 = [dic objectForKey:@"adresseL4"];
        self.adresseL4MotVoie = [dic objectForKey:@"adresseL6CP"];
        self.adresseL5 = [dic objectForKey:@"adresseL5"];
        self.adresseL6CP = [dic objectForKey:@"adresseL6CP"];
        self.adresseL6CodeLocalite = [dic objectForKey:@"adresseL6CodeLocalite"];
        self.adresseL6Localite = [dic objectForKey:@"adresseL6Localite"];
        self.adresseType = [dic objectForKey:@"adresseType"];
        self.ancienQL = [dic objectForKey:@"ancienQL"];
        self.countryCode = [dic[@"country"][@"isocode"] lowercaseString];//[[dic objectForKey:@"country"] objectForKey:@"countryCode"];
        self.countryName = dic[@"country"][@"name"];//[[dic objectForKey:@"country"] objectForKey:@"countryName"];
        self.ql = [dic objectForKey:@"ql"];
        self.verifMascadia = [dic objectForKey:@"verifMascadia"];
    }
    return self;
}

@end

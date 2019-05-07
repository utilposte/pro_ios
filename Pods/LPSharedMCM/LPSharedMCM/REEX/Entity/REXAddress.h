//
//  REXAddress.h
//  laposte
//
//  Created by Sofien Azzouz on 02/10/2017.
//  Copyright © 2017 laposte. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface REXAddress : NSObject

@property (nonatomic) NSString *adresseL3;
@property (nonatomic) NSString *adresseL4;
@property (nonatomic) NSString *adresseL4MotVoie;
@property (nonatomic) NSString *adresseL5;
@property (nonatomic) NSString *adresseL6CP;
@property (nonatomic) NSString *adresseL6CodeLocalite;
@property (nonatomic) NSString *adresseL6Localite;
@property (nonatomic) NSString *adresseType;
@property (nonatomic) NSString *ancienQL;
@property (nonatomic) NSString *countryCode;
@property (nonatomic) NSString *countryName;
@property (nonatomic) NSString *ql;
@property (nonatomic) BOOL verifMascadia;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end

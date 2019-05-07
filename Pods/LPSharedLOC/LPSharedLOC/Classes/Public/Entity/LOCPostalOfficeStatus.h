//
//  PostalOfficeStatus.h
//  laposte
//
//  Created by Issam DAHECH on 24/07/2017.
//  Copyright © 2017 laposte. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LOCPostalOfficeStatus : NSObject

@property (nonatomic) NSString *dateCalcul;
@property (nonatomic) NSString *dateChangement;
@property (nonatomic) NSString *heure;
@property (nonatomic) NSString *statut;
@property BOOL isDOM;

- (id)initWithStatus:(NSDictionary *)aDict;
@end

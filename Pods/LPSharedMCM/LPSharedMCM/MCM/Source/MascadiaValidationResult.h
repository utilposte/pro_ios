//
//  MascadiaValidationResult.h
//  laposte
//
//  Created by Mohamed Helmi Ben Jabeur on 18/09/2017.
//  Copyright © 2017 laposte. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM (NSUInteger, MascadiaResponseStatus) {
    MascadiaResponseStatusCorrectAddress,
    MascadiaResponseStatusWrongAddressNoOptions,
    MascadiaResponseStatusWrongAddressWithOptions
};

@interface MascadiaValidationResult : NSObject
    
    @property (nonatomic) MascadiaResponseStatus generalStatus;
    @property (nonatomic) NSInteger ligne4Feu;
    @property (nonatomic) NSInteger ligne6Feu;
    
@end

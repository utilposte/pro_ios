//
//  LPNetworkError.h
//  laposte
//
//  Created by Matthieu Lemonnier on 14/03/2018.
//  Copyright © 2018 laposte. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    unknown = 0,
    authorization,
    noConnection,
    
} LPNetworkErrorType;

@interface LPNetworkError : NSObject

@property LPNetworkErrorType type;
@property NSError* error;

- (id) initWithError:(NSError *) error;
- (id) initWithError:(NSError *) error andType: (LPNetworkErrorType *) type;

@end

//
//  LPNetworkError.m
//  laposte
//
//  Created by Matthieu Lemonnier on 14/03/2018.
//  Copyright © 2018 laposte. All rights reserved.
//

#import "LPNetworkError.h"

@implementation LPNetworkError

- (id) initWithError:(NSError *) error
{
    self = [super init];
    self.error = error;
    return self;
}

- (id) initWithError:(NSError *) error andType: (LPNetworkErrorType *) type
{
    self = [super init];
    self.error = error;
    self.type = type;
    return self;
}

@end

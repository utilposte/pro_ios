//
//  MCMTrackingNetworkProtocol.h
//  laposte
//
//  Created by Matthieu Lemonnier on 27/02/2018.
//  Copyright © 2018 laposte. All rights reserved.
//

typedef enum : NSUInteger {
    TrackLoginOptions = 1009,
    TrackLogin
} TrackCode;

@protocol MCMTrackingNetworkProtocol
- (void) track:(TrackCode) code;
@end



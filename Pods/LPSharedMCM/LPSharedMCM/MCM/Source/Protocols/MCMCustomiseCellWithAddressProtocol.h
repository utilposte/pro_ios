//
//  MCMCustomiseCellWithAddressProtocol.h
//  laposte
//
//  Created by Jerilyn Goncalves Figueira on 08/08/16.
//  Copyright © 2016 laposte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYBAddress.h"

@protocol MCMCustomiseCellWithAddressProtocol <NSObject>

- (void)customiseCellWithAddress:(HYBAddress *)address;

@end

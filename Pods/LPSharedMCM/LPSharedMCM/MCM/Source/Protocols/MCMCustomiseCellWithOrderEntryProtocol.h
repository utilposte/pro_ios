//
//  MCMCustomiseCellWithOrderEntryProtocol.h
//  laposte
//
//  Created by Jerilyn Goncalves Figueira on 09/08/16.
//  Copyright © 2016 laposte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYBOrderEntry.h"

@protocol MCMCustomiseCellWithOrderEntryProtocol <NSObject>

- (void)customiseCellWithOrderEntry:(HYBOrderEntry *)orderEntry;

@end

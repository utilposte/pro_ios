//
//  MCMCustomiseCellWithOrderHistoryProtocol.h
//  laposte
//
//  Created by Ricardo Suarez on 16/06/16.
//  Copyright © 2016 laposte. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HYBOrderHistory;

@protocol MCMCustomiseCellWithOrderHistoryProtocol <NSObject>

- (void)customiseCellWithOrderHistory:(HYBOrderHistory *)order;

@end

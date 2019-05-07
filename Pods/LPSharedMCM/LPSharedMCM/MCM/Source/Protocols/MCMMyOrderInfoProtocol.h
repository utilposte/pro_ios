//
//  MCMMyOrderInfoProtocol.h
//  laposte
//
//  Created by Hobart Wong on 15/06/2016.
//  Copyright © 2016 laposte. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HYBOrder;

@protocol MCMMyOrderInfoProtocol <NSObject>
-(void) customiseWithOrder:(HYBOrder*) order;
@end

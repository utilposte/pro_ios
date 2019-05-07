//
//  MCMCustomiseCellWithCartProtocol.h
//  laposte
//
//  Created by Hobart Wong on 20/06/2016.
//  Copyright © 2016 laposte. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HYBCart;

@protocol MCMCustomiseCellWithCartProtocol <NSObject>

- (void)customiseCellWithCart:(HYBCart *)cart;

@end

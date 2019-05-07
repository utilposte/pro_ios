//
//  MCMCustomiseCellWithTitleProtocolProtocol.h
//  laposte
//
//  Created by Jerilyn Goncalves Figueira on 08/08/16.
//  Copyright © 2016 laposte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYBCart.h"


@protocol MCMCustomiseCellWithTitleProtocol <NSObject>

- (void)customiseCellWithCart:(HYBCart *)cart;
- (void)customiseCellWithTitle:(NSString *)titleText;



@end

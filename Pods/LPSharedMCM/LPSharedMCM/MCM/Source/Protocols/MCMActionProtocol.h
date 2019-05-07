//
//  MCMActionProtocol.h
//  laposte
//
//  Created by Hobart Wong on 15/06/2016.
//  Copyright © 2016 laposte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol MCMActionProtocol <NSObject>
-(void) objectHitEvent:(id) object withEvent:(UIEvent*) event;
@end



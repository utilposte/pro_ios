//
//  MCMViewProtocol.h
//  laposte
//
//  Created by Hobart Wong on 15/06/2016.
//  Copyright © 2016 laposte. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MCMViewProtocol <NSObject>
- (void) initializeViews;
-(void) displayInfo:(id) info;
@end

//
//  REXContractHelper.h
//  laposte
//
//  Created by ISSOLAH Rafik on 17/11/2017.
//  Copyright © 2017 laposte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYBReexContract.h"
#import "REXUtils.h"
#import "REXServices.h"

@protocol RexContractDelegate <NSObject>

- (void)goToReexContract:(HYBReexContract *)contract;

@end

@interface REXContractHelper : NSObject

@property (nonatomic, weak) id<RexContractDelegate> delegate;

+ (REXContractHelper *)sharedInstance;

- (void)proceedCommands:(NSString *) emailUser activated:(void (^) (void))block;

@end

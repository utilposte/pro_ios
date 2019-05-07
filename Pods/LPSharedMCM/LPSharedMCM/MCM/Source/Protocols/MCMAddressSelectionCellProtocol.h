//
//  MCMAddressSelectionCellProtocol.h
//  laposte
//
//  Created by Hobart Wong on 15/06/2016.
//  Copyright © 2016 laposte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCMAddressSelectionCellDelegate.h"
@class HYBAddress;

@protocol MCMAddressSelectionCellProtocol <NSObject>

- (void)showAddress:(HYBAddress*)address;
- (void)showSelected:(BOOL)show;
- (void)showChevron:(BOOL)show;

@end

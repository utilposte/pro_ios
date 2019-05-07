//
//  MCMAddressSelectionCellDelegate.h
//  laposte
//
//  Created by Hobart Wong on 15/06/2016.
//  Copyright © 2016 laposte. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MCMAddressSelectionCell;
@class HYBAddress;

@protocol MCMAddressSelectionCellDelegate <NSObject>

- (void)hybrisAddressSelectioinHeaderCellDidSelectSetAsDeliveryAddress:(MCMAddressSelectionCell *)header withAddress:(HYBAddress *)address;
- (void)hybrisAddressSelectioinHeaderCellDidSelectSModifyAddress:(MCMAddressSelectionCell *)header withAddress:(HYBAddress *)address;

@end
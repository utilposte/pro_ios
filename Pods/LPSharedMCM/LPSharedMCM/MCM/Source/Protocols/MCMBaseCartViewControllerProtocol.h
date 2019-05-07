//
//  MCMBaseCartViewControllerProtocol.h
//  laposte
//
//  Created by Ricardo Suarez on 16/06/16.
//  Copyright © 2016 laposte. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MCMGenericButtonCell, HYBCart;

@protocol MCMBaseCartViewControllerProtocol <NSObject>

@property (nonatomic, strong) HYBCart *currentCart;
- (MCMGenericButtonCell *)genericButtonCartCellForTableView:(UITableView *)tableView withTitle:(NSString *) title;
- (void)refreshCartFromServer;

@end


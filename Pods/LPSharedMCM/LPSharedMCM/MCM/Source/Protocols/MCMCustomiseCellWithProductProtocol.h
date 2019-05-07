//
//  MCMCustomiseCellWithProductProtocol.h
//  laposte
//
//  Created by Jerilyn Goncalves Figueira on 09/08/16.
//  Copyright © 2016 laposte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYBProduct.h"

typedef NS_ENUM (NSInteger, MCMProductCellMode) {
    MCMProductCellVisualisationMode = 0,
    MCMProductCellEditionMode
};

@protocol MCMCustomiseCellWithProductProtocol <NSObject>

- (void)customiseCellWithProduct:(HYBProduct *)product;

@optional
- (void)customiseCellWithProduct:(HYBProduct *)product quantity:(NSNumber *)productQuantity;

@end

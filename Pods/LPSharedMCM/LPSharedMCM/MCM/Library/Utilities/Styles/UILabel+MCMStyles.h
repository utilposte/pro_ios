//
//  UILabel+MCMStyles.h
//  laposte
//
//  Created by Jerilyn Goncalves Figueira on 01/08/16.
//  Copyright © 2016 laposte. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCMStyles.h"

@interface UILabel (MCMStyles)

/**
 *  Customises a label with the base Font and the given text size and color
 *
 *  @param textSize    MCMTextSize the size of the text
 *  @param colorOption MCMStyleOption the color of the text (primary, secondary or default)
 */
- (void)customiseLabelWithSize:(MCMTextSize)textSize color:(MCMStyleOption)colorOption;

/**
 *  Customises a label with the base Font and the given text size and Stock availability Color
 *
 *  @param textSize    MCMTextSize the size of the text
 *  @param colorOption MCMStockAvailabity the color related to the stock (inStock, LowStock, OutOfStock)
 */
- (void)customiseLabelWithSize:(MCMTextSize)textSize stockColor:(MCMStockAvailabity)colorOption;

/**
 *  Customises a label with the Bold Font and the given text size and Stock availability Color
 *
 *  @param textSize    MCMTextSize the size of the text
 *  @param colorOption MCMStockAvailabity the color related to the stock (inStock, LowStock, OutOfStock)
 */
- (void)customiseBoldLabelWithSize:(MCMTextSize)textSize stockColor:(MCMStockAvailabity)colorOption;

/**
 *  Customises a label with Bold Font and the given text size and color
 *
 *  @param textSize    MCMTextSize the size of the text
 *  @param colorOption MCMStyleOption the color of the text (primary, secondary or default)
 */
- (void)customiseBoldLabelWithSize:(MCMTextSize)textSize color:(MCMStyleOption)colorOption;

/**
 *  Customises a label with Medium Font and the given text size and color
 *
 *  @param textSize    MCMTextSize the size of the text
 *  @param colorOption MCMStyleOption the color of the text (primary, secondary or default)
 */
- (void)customiseMediumLabelWithSize:(MCMTextSize)textSize color:(MCMStyleOption)colorOption;

@end

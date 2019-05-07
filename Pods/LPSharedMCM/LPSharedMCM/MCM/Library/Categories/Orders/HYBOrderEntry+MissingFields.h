//
//  HYBOrderEntry+MissingFields.h
//  laposteCommon
//
//  Created by Hobart Wong on 15/03/2016.
//  Copyright © 2016 DigitasLBi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYBOrderEntry.h"

@interface HYBOrderEntry (missingFields)

-(NSString*) getCountry;
-(float) getWeight;
-(NSString*) getdetailFieldsText;

@end

//
//  MCMSortPickerValueCreator.h
//  Pods
//
//  Created by Mohamed Helmi Ben Jabeur on 19/01/2017.
//
//

#import <Foundation/Foundation.h>

@interface MCMSortPickerValueCreator : NSObject
+ (NSArray*) valuesForStockLevel:(NSMutableArray*) sortsArray;
+ (NSArray*) codesForStockLevel:(NSMutableArray*) sortsArray;

@end

//
//  MCMUtils.h
//  Pods
//
//  Created by Mohamed Helmi Ben Jabeur on 02/05/2017.
//
//

#import <Foundation/Foundation.h>
#import "HYBAddress.h"

@interface MCMUtils : NSObject

+ (BOOL) isEmptyAddress:(HYBAddress *) address;
+ (NSString *)removeNonAutorisedCharacter:(NSString *)text;

@end

//
//  NSString+MCMCustom.h
//  laposte
//
//  Created by Ricardo Suarez on 04/08/16.
//  Copyright © 2016 laposte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (MCMCustom)

- (BOOL)hasContent;
- (CGSize)newSizeWithFont:(UIFont*) font constrainedToSize:(CGSize) contraintSize;
- (NSMutableAttributedString *)getUnderlineTextWithUnderlineParts:(NSArray *) stringParts;
- (NSMutableAttributedString *)getUnderlineText;
- (NSString *)getSHA256;
- (NSString *)removeSpecialCharacters;


@end

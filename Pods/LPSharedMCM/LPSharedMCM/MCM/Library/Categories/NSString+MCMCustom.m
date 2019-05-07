//
//  NSString+MCMCustom.m
//  laposte
//
//  Created by Ricardo Suarez on 04/08/16.
//  Copyright © 2016 laposte. All rights reserved.
//

#import "NSString+MCMCustom.h"

#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>
#include <CommonCrypto/CommonDigest.h>

@implementation NSString (MCMCustom)

#pragma mark - ---- LIFE CICLE

#pragma mark - ---- INTERNAL

#pragma mark - ---- PUBLIC

- (NSMutableAttributedString *) getUnderlineText {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    [attributedString appendAttributedString:[[NSAttributedString alloc]
                                              initWithString:self
                                              attributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),
                                                           NSBackgroundColorAttributeName: [UIColor clearColor]}]];
    return attributedString;
}

- (NSMutableAttributedString *) getUnderlineTextWithUnderlineParts:(NSArray *) stringParts {
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    for (NSString *part in stringParts) {
        [attributedString addAttribute:(NSString *)kCTUnderlineStyleAttributeName
                                 value:[NSNumber numberWithInt:kCTUnderlineStyleSingle]
                                 range:[self rangeOfString:part]];
    }
    
    return attributedString;
}

- (NSString *) getSHA256 {
    const char *s=[self cStringUsingEncoding:NSASCIIStringEncoding];
    NSData *keyData=[NSData dataWithBytes:s length:strlen(s)];
    
    uint8_t digest[CC_SHA256_DIGEST_LENGTH]={0};
    CC_SHA256(keyData.bytes, (CC_LONG) keyData.length, digest);
    NSData *out=[NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
    NSString *hash=[out description];
    hash = [hash stringByReplacingOccurrencesOfString:@" " withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@"<" withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@">" withString:@""];
    return hash;
}

-(BOOL) hasContent {
    return self.length > 0;
}

-(CGSize) newSizeWithFont:(UIFont*) font constrainedToSize:(CGSize) contraintSize {
    return [self newSizeWithFont:font constrainedToSize:contraintSize lineBreakMode:NSLineBreakByWordWrapping];
}

-(CGSize) newSizeWithFont:(UIFont*) font constrainedToSize:(CGSize) contraintSize lineBreakMode:(NSLineBreakMode) lineBreakMode {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = lineBreakMode; //set the line break mode
    NSStringDrawingOptions drawOptions = (NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading);
    CGSize newSize = [self boundingRectWithSize:contraintSize options:drawOptions attributes:@{NSFontAttributeName: font, NSParagraphStyleAttributeName : paragraphStyle} context:nil].size;
    return CGSizeMake(ceilf(newSize.width), ceilf(newSize.height));
}

-(CGSize) newSizeWithFont:(UIFont*) font {
    CGSize size = [self sizeWithAttributes: @{NSFontAttributeName: font}];
    return CGSizeMake(ceilf(size.width), ceilf(size.height));
}

/**
 *  Removes all special characters from a NSString.
 *
 *  @param dirtyString
 *
 *  @return cleanString
 */

- (NSString *)removeSpecialCharacters {
    
    NSString *cleanString = [self stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    cleanString = [cleanString stringByReplacingOccurrencesOfString:@"'" withString:@"_"];
    cleanString = [cleanString stringByReplacingOccurrencesOfString:@"é" withString:@"e"];
    cleanString = [cleanString stringByReplacingOccurrencesOfString:@"è" withString:@"e"];
    cleanString = [cleanString stringByReplacingOccurrencesOfString:@"à" withString:@"a"];
    cleanString = [cleanString stringByReplacingOccurrencesOfString:@"ï" withString:@"i"];
    cleanString = [cleanString stringByReplacingOccurrencesOfString:@"ê" withString:@"e"];
    cleanString = [cleanString stringByReplacingOccurrencesOfString:@"î" withString:@"i"];
    cleanString = [cleanString stringByReplacingOccurrencesOfString:@"ô" withString:@"o"];
    cleanString = [cleanString stringByReplacingOccurrencesOfString:@"ö" withString:@"o"];
    cleanString = [cleanString stringByReplacingOccurrencesOfString:@"û" withString:@"u"];
    
    return cleanString;
}

@end

#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "LOCConstant.h"
#import "NSString+Crypting.h"
#import "LOCPostalOffice.h"
#import "LOCPostalOfficeStatus.h"
#import "LOCPostBox.h"
#import "LOCSharedManager.h"

FOUNDATION_EXPORT double LPSharedLOCVersionNumber;
FOUNDATION_EXPORT const unsigned char LPSharedLOCVersionString[];


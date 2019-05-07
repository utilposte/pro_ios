#import <UIKit/UIKit.h>

@interface UIColor (HEXValue)

- (NSString *)hexStringValue;
+ (UIColor *)colorWithHexString:(NSString *)hexString;

@end

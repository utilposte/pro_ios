//
//  LoaderView.m
//  LoaderViewProject
//
//  Created by Issam DAHECH on 06/06/2017.
//  Copyright © 2017 Issam DAHECH. All rights reserved.
//

#import "LoaderView.h"
#import <QuartzCore/QuartzCore.h>

//#define kImage1 [UIImage imageNamed:@"loader-1"]
//#define kImage2 [UIImage imageNamed:@"loader-2"]
//#define kImage3 [UIImage imageNamed:@"loader-3"]

@interface LoaderView() {
    UIImageView *imageView;
    BOOL enableAnimation;
    UIImage *kImage1;
    UIImage *kImage2;
    UIImage *kImage3;
    
}
@end

@implementation LoaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self baseInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self baseInit];
    }
    return self;
}

- (void)baseInit {
    kImage1 = [UIImage imageNamed:@"loader-1"];
    kImage2 = [UIImage imageNamed:@"loader-2"];
    kImage3 = [UIImage imageNamed:@"loader-3"];
    
    UIView *background = [[UIView alloc] initWithFrame:self.bounds];
    background.backgroundColor = [UIColor whiteColor]; //[self colorFromHexString:@"#FFC526"];;
    background.layer.cornerRadius   = background.bounds.size.width/2;
    background.layer.masksToBounds  = YES;
    
    imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(20, 20, background.frame.size.width - 40, background.frame.size.height - 40);
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [background addSubview:imageView];
    
    [self addSubview:background];
//    [self startAnimation];
    
}

- (UIColor *)colorFromHexString:(NSString *)hexString
{
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

- (void)startAnimation {
    imageView.image = kImage1;
    [self stopAnimation];
    enableAnimation = YES;
    [self animateView];
    [self performSelector:@selector(changeImage) withObject:nil afterDelay:0.5];
}

- (void)animateView {
    if (enableAnimation) {
        [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
            imageView.layer.transform = CATransform3DMakeRotation(M_PI,0.0,1.0,0.0);
        } completion:^(BOOL finished){
            if (finished) {
                [self performSelector:@selector(changeImage) withObject:nil afterDelay:0.5];
                [self animateView];
            }
        }];
    }
}

- (void)changeImage {
    if (enableAnimation) {
        imageView.layer.transform = CATransform3DMakeRotation(M_PI,0.0,0.0,0.0);
        if (imageView.image == kImage1) {
            imageView.image = kImage2;
        }
        else if (imageView.image == kImage2){
            imageView.image = kImage3;
        }
        else {
            imageView.image = kImage1;
        }
    }
}

- (void)stopAnimation {
    enableAnimation = NO;
    imageView.layer.transform = CATransform3DMakeRotation(M_PI,0.0,0.0,0.0);
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(changeImage) object: nil];
    [imageView.layer removeAllAnimations];
}

@end

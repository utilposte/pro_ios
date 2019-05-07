//
//  MCMGenericImageTextButtonProtocol.h
//  laposte
//
//  Created by Hobart Wong on 15/06/2016.
//  Copyright © 2016 laposte. All rights reserved.
//

#import <UIKit/UIkit.h>
#import "MCMGenericScreenActionProtocol.h"

@protocol MCMGenericImageTextButtonProtocol <NSObject>

@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) NSString *descriptiveText;
@property (nonatomic, strong) NSString *buttonTitle;
@property (nonatomic, strong) UIButton *yellowButton;
@property (nonatomic, strong) UILabel *descriptiveTextLabel;

- (CGFloat)getImageHeight;
- (CGFloat)getImageWidth;
- (void)setupViews;
- (instancetype)initWithImageName:(NSString*) imageName descriptiveText:(NSString*) text ctaTitle:(NSString*) title;
- (instancetype)initWithImageName:(NSString*) imageName descriptiveText:(NSString*) text ctaTitle:(NSString*) title delegatedTarget:(id<MCMGenericScreenActionProtocol>) target;

@end
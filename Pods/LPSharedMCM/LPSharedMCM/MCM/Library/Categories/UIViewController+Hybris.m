//
//  UIViewController+Hybris.m
//  laposteCommon
//
//  Created by Ricardo Suarez on 29/02/16.
//  Copyright © 2016 DigitasLBi. All rights reserved.
//

#import "UIViewController+Hybris.h"

#import "Masonry.h"
#import "MCMImageHelper.h"
#import "MCMStyles.h"
#import "UILabel+MCMStyles.h"
#import "MCMDefine.h"
#import "MCMManager.h"

static NSString *const kCatalogScreenClassName = @"MCMCatalogViewController";
static NSString *const kItemDetailScreenClassName = @"MCMCatalogItemDetailViewController";
static NSString *const kCategoriesViewControlelrClassName = @"MCMCategoriesViewController";



@implementation UIViewController (Hybris)

#pragma mark - ---- INTERNAL

#pragma mark - ---- PUBLIC

- (void)setupNavigationBar {
}

- (void) addBackButtonWithImage:(UIImage *) image {
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.exclusiveTouch = YES;
    [closeButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [closeButton setImage:image forState:UIControlStateNormal];
    closeButton.imageEdgeInsets = UIEdgeInsetsMake(-1, 0, 0, kButton_ImageEdgeInsetRight);
    closeButton.contentEdgeInsets = UIEdgeInsetsMake(-5, -5, -5, -5);
    closeButton.frame = CGRectMake(0, 0, kView_BackButtonWidth, kView_BackButtonHeight);
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
    
    self.navigationItem.leftBarButtonItem =  backItem;
}

-(void) createLeftNavigationBarButton :(UIImage *) image {
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.exclusiveTouch = YES;
    [closeButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [closeButton setImage:image forState:UIControlStateNormal];
    closeButton.imageEdgeInsets = UIEdgeInsetsMake(-1, 0, 0, kButton_ImageEdgeInsetRight);
    closeButton.contentEdgeInsets = UIEdgeInsetsMake(-5, -5, -5, -5);
    closeButton.frame = CGRectMake(0, 0, kView_BackButtonWidth, kView_BackButtonHeight);
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
    
    UIButton *accountButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [accountButton setImage:[MCMImageHelper loadImageNamed:MCMHomeIcon] forState:UIControlStateNormal];
    [accountButton setFrame:CGRectMake(0, 0, 30, 30)];
    accountButton.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    [accountButton addTarget:self action:@selector(homeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* accountItem = [[UIBarButtonItem alloc] initWithCustomView:accountButton];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -15.0f;
    
    self.navigationItem.leftBarButtonItems =  [NSArray arrayWithObjects:backItem,accountItem,nil];
}



-(void) addLeftNavigationItems{
    [self createLeftNavigationBarButton:[MCMImageHelper loadImageNamed:MCMBackArrowWhite]];
}


- (void) addBackButton {
    [self addBackButtonWithImage:[MCMImageHelper loadImageNamed:MCMBackArrowWhite]];
}

- (void) addBlackBackButton {
    [self addBackButtonWithImage:[MCMImageHelper loadImageNamed:MCMBackArrowBlack]];
}

- (void)homeButtonClick:(id)sender {
    
    [[[MCMManager sharedInstance] behaviourDelegate] navigateToRootViewController];
}


- (void)addCloseButton {
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setImage:[MCMImageHelper loadImageNamed:MCMCartCloseIcon] forState:UIControlStateNormal];
    [closeButton setFrame:CGRectMake(0, 0, 20, 20)];
    closeButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [closeButton addTarget:self action:@selector(closeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *accountItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
    self.navigationItem.rightBarButtonItem = accountItem;
}

- (void) backButtonClicked:(id) sender {
    id<MCMTrackingProtocol> trackingDelegate = [[MCMManager sharedInstance] trackingDelegate];
    if([trackingDelegate respondsToSelector:@selector(trackHeaderAction:)]) {
        [trackingDelegate trackHeaderAction:@"retour"];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)closeButtonClicked {
    UIViewController *controller = nil;
    for (UIViewController *viewController in self.parentViewController.childViewControllers) {
        if (([[viewController class] isSubclassOfClass:[NSClassFromString(kCatalogScreenClassName) class]]) ||
            ([viewController class] == NSClassFromString(kItemDetailScreenClassName)) ||
            ([viewController class] == NSClassFromString(kCategoriesViewControlelrClassName))){
            if (!controller ||  (controller && [controller class] != NSClassFromString(kItemDetailScreenClassName))) {
                controller = viewController;
            }
        }
        
        NSLog(@"fired");
    }
    if (controller) {
        [self.navigationController pushViewController:controller animated:NO];
    }
}

- (void) showNoImplementedAlert {
    [[[UIAlertView alloc] initWithTitle:@"Avertissement"
                                message:@"Cette fonctionnalité n'est pas implementé encore"
                               delegate:nil
                      cancelButtonTitle:@"Accepter"
                      otherButtonTitles:nil] show];
}

- (UIView *)createViewWithTitle:(NSString *)title detail:(NSString *)detail isBold:(BOOL)isBold
{
    UIView *plainView = [UIView new];
    [plainView setBackgroundColor:[MCMStyles clearColor]];
    UILabel *titleLabel = [UILabel new];
    [titleLabel setText:title];
    [self customiseLabel:titleLabel withSize:MCMTextSizeXL isBold:isBold];
    [titleLabel setTextAlignment:NSTextAlignmentLeft];
    [plainView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(plainView.mas_top);
        make.bottom.equalTo(plainView.mas_bottom);
        make.left.equalTo(plainView.mas_left).with.offset([[MCMStyles sharedInstance] preferredSizeForHorizontalSpacing]);
    }];
    
    UILabel *detailLabel = [UILabel new];
    [detailLabel setText:detail];
    [self customiseLabel:detailLabel withSize:MCMTextSizeXL isBold:isBold];
    [detailLabel setTextAlignment:NSTextAlignmentRight];
    [plainView addSubview:detailLabel];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(plainView.mas_top);
        make.bottom.equalTo(plainView.mas_bottom);
        make.left.greaterThanOrEqualTo(titleLabel.mas_right).with.offset([[MCMStyles sharedInstance] preferredSizeForHorizontalSpacing]).with.priorityLow();
        make.right.equalTo(plainView.mas_right).with.offset(-[[MCMStyles sharedInstance] preferredSizeForHorizontalSpacing]);
    }];
    return plainView;
}

- (void)customiseLabel:(UILabel *)label withSize:(MCMTextSize)textSize isBold:(BOOL)isBold {
    
    if (isBold) {
        [label customiseBoldLabelWithSize:textSize color:MCMStyleOptionDefault];
    } else {
        [label customiseLabelWithSize:textSize color:MCMStyleOptionDefault];
    }
}

- (void)attachView:(UIView *)subView asSubviewOf:(UIView *)view belowView:(UIView *)topView withHeight:(CGFloat) height
{
    [view addSubview:subView];
    [subView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(height));
        if  (topView == view) {
            make.top.equalTo(view.mas_top).with.equalTo(@([[MCMStyles sharedInstance] preferredSizeForVerticalSpacing]));
        } else {
            make.top.equalTo(topView.mas_bottom).with.equalTo(@([[MCMStyles sharedInstance] preferredSizeForVerticalSpacing]));
        }
        make.left.right.equalTo(view);
    }];
}

- (BOOL)isModal {
    if([self presentingViewController])
        return YES;
    if([[[self navigationController] presentingViewController] presentedViewController] == [self navigationController])
        return YES;
    if([[[self tabBarController] presentingViewController] isKindOfClass:[UITabBarController class]])
        return YES;
    
    return NO;
}

@end

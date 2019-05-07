//
//  LPMascadiaAddressCell.m
//  RefonteFormulaire
//
//  Created by Sofien Azzouz on 19/01/2018.
//  Copyright © 2018 Sofien Azzouz. All rights reserved.
//

#import "LPMascadiaAddressCell.h"
#import "LPAddressValidationService.h"
#import "CLDefine.h"
#import <LPColissimoUI/LPColissimoUI-Swift.h>

@implementation LPMascadiaAddressCell
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setupWithAddress:(NSDictionary *)address order:(LPSarcadiaAddressCellRowOrder)order isChecked:(BOOL)isChecked color:(UIColor *)color {
    
    
//    [Utils editImageWithColor:self.checkBoxImageView color:color];
    self.addressLabel.textColor = color;
    
    if (isChecked) {
        self.checkBoxImageView.image = [self loadImage:@"app-reex-odestination-checked.png"];
    } else {
        self.checkBoxImageView.image = [self loadImage:@"app-reex-unchecked.png"];
    }
//    Utils.editImage(withColor: self.logoImageView, color: themeColor)
//    [Utils editImageWithColor:self.checkBoxImageView color:color];
    
    NSMutableString *addressText = [[NSMutableString alloc] init];

    if(address[kJsonValue_Ligne4][kJsonValue_Value])
        [addressText appendString:[NSString stringWithFormat:@"%@\n", address[kJsonValue_Ligne4][kJsonValue_Value]]];
    if(address[kJsonValue_Ligne6][kJsonValue_Value])
        [addressText appendString:[NSString stringWithFormat:@"%@\n", address[kJsonValue_Ligne6][kJsonValue_Value]]];
    if(address[kJsonValue_Ligne7][kJsonValue_Value])
        [addressText appendString:[NSString stringWithFormat:@"%@", address[kJsonValue_Ligne7][kJsonValue_Value]]];
    [self.addressLabel setText:addressText];
    
    float cornerRadius = 20.0;
    
    switch (order) {
        case LPSarcadiaAddressCellFirst:
            [self setMaskTo:self.containerView byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight withCornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
            break;
            
        case LPSarcadiaAddressCellLast:
            [self setMaskTo:self.containerView byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight withCornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
            break;
        case LPSarcadiaAddressCellAlone:
            [self setMaskTo:self.containerView byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight|UIRectCornerBottomLeft|UIRectCornerBottomRight withCornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
            break;
        default:
            break;
    }
    
}

//class func loadImage(name: String) -> UIImage? {
//    let podBundle = Bundle(for: ColissimoHomeServices.classForCoder())
//    if let bundleURL = podBundle.url(forResource: "LPColissimoUI_Images", withExtension: "bundle") {
//        let bundle = Bundle(url: bundleURL)
//        return UIImage(named: name, in: bundle, compatibleWith: nil)
//    }
//    return nil
//}

- (UIImage *) loadImage:(NSString *)name {
    UIImage *image;
    NSBundle *podBundle = [NSBundle bundleForClass:[self classForCoder]];
    NSURL *bundleURL = [podBundle URLForResource:@"LPColissimoUI_Images" withExtension:@"bundle"];
    if (bundleURL != nil) {
        NSBundle *bundle = [NSBundle bundleWithURL:bundleURL];
        image = [UIImage imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];
    }
    return image;
}

- (void)setMaskTo:(UIView *)view byRoundingCorners:(UIRectCorner)corners withCornerRadii:(CGSize)radii {
    
    UIBezierPath *shapePath = [UIBezierPath bezierPathWithRoundedRect:view.bounds
                                                    byRoundingCorners:corners
                                                          cornerRadii:radii];
    
    CAShapeLayer *newCornerLayer = [CAShapeLayer layer];
    newCornerLayer.frame = view.bounds;
    newCornerLayer.path = shapePath.CGPath;
    [view layer].mask = newCornerLayer;
}


@end

//
//  REXSarcadiaAddressCell.h
//  RefonteFormulaire
//
//  Created by Sofien Azzouz on 19/01/2018.
//  Copyright © 2018 Sofien Azzouz. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum : NSUInteger {
    LPSarcadiaAddressCellFirst = 0,
    LPSarcadiaAddressCellMiddle,
    LPSarcadiaAddressCellLast,
    LPSarcadiaAddressCellAlone
    
} LPSarcadiaAddressCellRowOrder;

@interface LPMascadiaAddressCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIImageView *checkBoxImageView;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

- (void)setupWithAddress:(NSDictionary *)address order:(LPSarcadiaAddressCellRowOrder)order isChecked:(BOOL)isChecked color:(UIColor *)color;
@end

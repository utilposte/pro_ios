//
//  MCMBasePaymentWebViewController.h
//  laposte
//
//  Created by Ricardo Suarez on 15/06/16.
//  Copyright © 2016 laposte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class HYBCart, MCMPaymentSummaryData;

@interface MCMPaymentWebViewController : UIViewController

@property (nonatomic, strong) NSString *initalPaymentFormHTML;
@property (nonatomic, strong) NSString *hybrisUrl;


//@property (nonatomic, assign) HybrisPaymentFinishStatus finishStatus;
@property (nonatomic, strong) NSString *finishJsonSummaryURL;
@property (nonatomic, strong) NSString *orderNumber;
@property (nonatomic, strong) HYBCart *cart;
@property (nonatomic, strong) MCMPaymentSummaryData *finishSummary;
@property (nonatomic, strong) NSURLConnection *urlConnection;
@property (nonatomic, strong) NSString *paymentMean;
@property (nonatomic, assign) BOOL debugMode;

@end

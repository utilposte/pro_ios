//
//  REXContractHelper.m
//  laposte
//
//  Created by ISSOLAH Rafik on 17/11/2017.
//  Copyright © 2017 laposte. All rights reserved.
//

#import "REXContractHelper.h"
#import "MCMDefine.h"

@implementation REXContractHelper

+ (REXContractHelper *)sharedInstance {
    
    static dispatch_once_t once;
    static REXContractHelper *_sharedInstance;
    dispatch_once(&once, ^ {
        _sharedInstance = [[REXContractHelper alloc] init];
    });
    return _sharedInstance;
    
}

- (void)proceedCommands:(NSString *) emailUser activated:(void (^) (void))block {
    
//    NSString * userId = userAccount.UId;
//    NSString * accessToken = userAccount.accessToken;
    

    
    [REXServices getReexContractsForUser:emailUser andExecute:^(id responseObject, NSError *error) {
        
        if (responseObject) {
            
            NSArray *contracts = [responseObject objectForKey:@"contracts"];
            
            for (int i=0; i < contracts.count; i++) {
                
                HYBReexContract * contract = [HYBReexContract reexContractWithParams:[contracts objectAtIndex:i]];
                NSString * status = contract.status;
                
                
                // Show activation Popin when contract's status is waiting
                if ([status isEqualToString:@"B"] || ([status isEqualToString:@"C"] && contract.number)) {
                    
                    NSString * alertTitle = [REXUtils stringForKey:@"activation_alert_title"];
                    NSString * reexType;
                    NSString * alertMessage;
                    if ([contract.contractType containsString:@"TN"]) {
                        reexType = @"nationale";
                        alertMessage = [NSString stringWithFormat:[REXUtils stringForKey:@"activation_alert_message"], reexType, contract.number];
                    } else if ([contract.contractType containsString:@"TI"]) {
                        reexType = @"internationale";
                        alertMessage = [NSString stringWithFormat:[REXUtils stringForKey:@"activation_alert_message"], reexType, contract.number];
                    } else if ([contract.contractType containsString:@"DN"]) {
                        reexType = @"nationale";
                        alertMessage = [NSString stringWithFormat:[REXUtils stringForKey:@"activation_alert_message_international"], reexType, contract.number];
                    } else if ([contract.contractType containsString:@"DI"]) {
                        reexType = @"internationale";
                        alertMessage = [NSString stringWithFormat:[REXUtils stringForKey:@"activation_alert_message_international"], reexType, contract.number];
                    }

                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:alertTitle message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction * activateButton = [UIAlertAction actionWithTitle:@"Activer" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        block();
                        [self goToReexContract:contract];
                        
                    }];
                    
                    UIAlertAction * cancelButton = [UIAlertAction actionWithTitle:@"Annuler" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    UIAlertAction * notShowAgainButton = [UIAlertAction actionWithTitle:@"Ne plus afficher" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                        [userDefault setBool:YES forKey:@"reex_contracts_check_canceled"];
                    }];
                    
                    [alert addAction:activateButton];
                    [alert addAction:cancelButton];
                    [alert addAction:notShowAgainButton];
                    
                    UIViewController *rootViewController = [self topViewController];
                    [rootViewController presentViewController:alert animated:YES completion:nil];
                    
                    return;
                }
            }
        }
    }];
}

-(void)goToReexContract:(HYBReexContract *)contract {
    [self.delegate goToReexContract:contract];
}

- (UIViewController *)topViewController {
    return [self topViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (UIViewController *)topViewController:(UIViewController *)rootViewController {
    if (rootViewController.presentedViewController == nil) {
        return rootViewController;
    }
    if ([rootViewController.presentedViewController isMemberOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController.presentedViewController;
        UIViewController *lastViewController = [[navigationController viewControllers] lastObject];
        return [self topViewController:lastViewController];
    }
    
    UIViewController *presentedViewController = (UIViewController *)rootViewController.presentedViewController;
    return [self topViewController:presentedViewController];
}

@end

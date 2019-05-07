//
//  MCMBehaviourDelegate.h
//  laposte
//
//  Created by Jerilyn Goncalves Figueira on 18/08/16.
//  Copyright © 2016 laposte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYBCart.h"


@protocol MCMBehaviourDelegate <NSObject>

// Login
- (BOOL)isUserLoggedIn;
- (NSString *)getHybrisHostURL;

- (BOOL)validateAccessToken;

// Show views
- (BOOL)showLoginViewController;
- (BOOL)showRegistrationViewController;
- (BOOL)navigateToRootViewController;
- (BOOL)showDetailedCartViewController;
- (BOOL)showCatalogViewController;
- (BOOL)pushConnectedAccount;

//UPDATE La Poste
- (BOOL)showOrdersHistory;

// Navigation type
- (void)shouldPresentAsPopOverNavigation;
- (void)shouldPresentAsPushNavigation;

@optional

// Cart updates
- (void)updatedCart:(HYBCart *)cart;


// Handle the opening of tracked URLs
- (void)openTrackedURL:(NSURL *)URL;

@end

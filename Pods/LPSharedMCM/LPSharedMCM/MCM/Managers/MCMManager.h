//
//  MCMManager.h
//  laposte
//
//  Created by Ricardo Suarez on 05/08/16.
//  Copyright © 2016 laposte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "MCMTrackingProtocol.h"
#import "MCMBehaviourDelegate.h"

@protocol MCMManagerDelegate <NSObject>

- (NSString *_Nonnull)getHybrisServiceHost;
- (NSString *_Nonnull)getSercadiaServiceHost;
- (NSString *_Nullable)getAppHeaderName;

- (void)showHideLoader:(BOOL)show;

@end

@class MCMUser;
@interface MCMManager : NSObject

+ (MCMManager *) sharedInstance; // Be careful to call to initSharedInstanceWithAppId:(NSString *) appId

- (instancetype) init __attribute__((unavailable("init not available")));

@property (nonatomic, readonly) MCMUser *user;
@property (nonatomic, weak, readonly) id<MCMBehaviourDelegate> behaviourDelegate;
@property (nonatomic, weak, readonly) id<MCMTrackingProtocol> trackingDelegate;
@property (nonatomic, weak) id<MCMManagerDelegate> delegate;


/**
 *  Sets up the initial configuration for the mCommerce Module.
 *
 *  This method must be called right after the first time MCMManager is instantiated in your app.
 *
 *  @param environmentPlistName NSString with Hybris' environment configuration property list file name. If not provided, the default configuration will be used.
 *  @param stylesPlistName NSString with the custom styles configuration property list file name. If not provided, the default configuration will be used.
 *  @param behaviourDelegate id<MCMBehaviourDelegate> that conforms to the behaviour protocol for MCM.
 */
- (void)initWithEnvironmentPlist:(NSString * _Nullable)environmentPlistName
                     stylesPlist:(NSString * _Nullable)stylesPlistName
               behaviourDelegate:(id<MCMBehaviourDelegate> _Nonnull)behaviourDelegate
                trackingDelegate:(id<MCMTrackingProtocol> _Nullable) trackingDelegate;

/**
 *  Point of entry to the main MCM flow. (Catalog Use case)
 *
 *  @return a UIViewController belonging to the MCM module that will be the start of the flow.
 */
- (UIViewController *)getCatalogFlowController;

/**
 *  Point of entry for 'My Orders' Hybris Use case
 *
 *  @return a UIViewController belonging to the MCM module representing the User's orders flow
 */
- (UIViewController *)getMyOrdersFlowController;

/**
 *  Point of entry for 'History of Orders' Hybris Use case
 *
 *  @return a UIViewController belonging to the MCM module representing the User's orders flow
 */
- (UIViewController *)getHistoryOrdersFlowController;

/**
 *  Sets the user account data inside the module.
 *  This data is composed of the user's info and the token from the main app
 *
 *  @param values NSDictionary with the user's hybris representation
 */
- (void)setUserCredentials:(NSDictionary *)values;

/**
 *  Erases all user related data as well as the token
 *  This action is usually triggered after user tries to logout
 */
- (void)eraseUserCredentials;

- (BOOL)haveGoalProduct:(NSArray *)entries;

@end

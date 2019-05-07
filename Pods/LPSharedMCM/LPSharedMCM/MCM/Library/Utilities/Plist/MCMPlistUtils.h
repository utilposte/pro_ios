//
//  MCMPlistUtils.h
//  laposte
//
//  Created by Alberto Delgado on 29/07/16.
//  Copyright © 2016 laposte. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCMPlistUtils : NSObject

/**
 *  Opens up a plist given its name
 *
 *  @param fileName the name of the plist file
 *	@param bundle NSBundle where the plist file is located
 *
 *  @return the plist in a raw format
 */
+ (id)readPlist:(NSString *)fileName inBundle:(NSBundle *)bundle;

/**
 *	Retrieve dictionary with plist info
 *
 *	@param fileName	file name of plist
 *	@param bundle NSBundle where the plist file is located
 *
 *	@return	dictionary with plsit info
 */
+ (NSDictionary *)getDictionary:(NSString *)fileName inBundle:(NSBundle *)bundle;

/**
 *	Retrieve value for selected key from list file
 *
 *	@param	key	Dictionary key that want retrieve
 *	@param	fileName	file name of plsit file
 *	@param	bundle NSBundle where the plist file is located
 *
 *	@return	value of key if exists, if not, return nil
 */
+ (NSString *)getValue:(NSString *)key fromPlist:(NSString *)fileName inBundle:(NSBundle *)bundle;


@end

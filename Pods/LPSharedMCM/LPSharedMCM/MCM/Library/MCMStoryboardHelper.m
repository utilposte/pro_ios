//
//  MCMStoryboardHelper.m
//  laposte
//
//  Created by Jerilyn Goncalves Figueira on 18/08/16.
//  Copyright © 2016 laposte. All rights reserved.
//

#import "MCMStoryboardHelper.h"

#import "MCMManager.h"
#import "MCMDefine.h"
#import "MCMBundleHelper.h"

@implementation MCMStoryboardHelper

+ (UIStoryboard *)storyboard {
    
    NSBundle *moduleBundle = [MCMBundleHelper moduleBundle];
    return [UIStoryboard storyboardWithName:MCM_UIStoryboard_Name bundle:moduleBundle];
    
}

@end

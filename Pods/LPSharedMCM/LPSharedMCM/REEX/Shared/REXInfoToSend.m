//
//  REXInfoToSend.m
//  laposte
//
//  Created by Mohamed Helmi Ben Jabeur on 11/09/2017.
//  Copyright © 2017 laposte. All rights reserved.
//

#import "REXInfoToSend.h"
#import "REXUtils.h"


@implementation REXInfoToSend

static REXInfoToSend *sharedData = nil;

+ (REXInfoToSend *) sharedInstance {
    if (!sharedData) {
        sharedData = [[self alloc] init];
//        [self sharedInit];
        sharedData.definitiveReexpedition = [[Reexpedition alloc] init];
        sharedData.temporaryReexpedition = [[Reexpedition alloc] init];
        //sharedData.isNationnalReex = YES;
        //sharedData.activationType = NONE,
        //sharedData.allPersons = [NSNumber numberWithBool:NO];
    }

    return  sharedData;
}

+ (void)resetSharedInstance {
    sharedData = nil;
//    sharedData = [[self alloc] init];
}


- (void)resetSharedDataAfterLogout {
    if (sharedData != nil && sharedData.isDefinitive) {
        [self resetCCUData:sharedData.definitiveReexpedition];
    } else {
        [self resetCCUData:sharedData.temporaryReexpedition];
    }
}

- (void)resetCCUData:(Reexpedition *) reexpedition {
    if ([REXUtils isEqualAddress:reexpedition.initialAddress destinationAddress:[REXUtils mapUserAccountAddressToReexDictionaryAddress]]) {
        reexpedition.initialAddress = nil;
    } else if ([REXUtils isEqualAddress:reexpedition.destinationAddress destinationAddress:[REXUtils mapUserAccountAddressToReexDictionaryAddress]]) {
        reexpedition.destinationAddress = nil;
    }
    
    if (reexpedition.beneficiaryArray != nil && reexpedition.beneficiaryArray.count == 1) {
        reexpedition.beneficiaryArray = nil;
    } else if (reexpedition.beneficiaryArray != nil && reexpedition.beneficiaryArray.count > 1) {
        [(NSMutableArray *)reexpedition.beneficiaryArray removeObject:[reexpedition.beneficiaryArray objectAtIndex:0]];
//        [reexpedition.beneficiaryArray removeObject:[reexpedition.beneficiaryArray objectAtIndex:0]];
    }
}


@end

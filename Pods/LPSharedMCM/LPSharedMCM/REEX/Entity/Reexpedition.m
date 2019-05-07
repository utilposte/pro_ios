//
//  Reexpedition.m
//  laposte
//
//  Created by Lassad Tiss on 05/02/2018.
//  Copyright © 2018 laposte. All rights reserved.
//

#import "Reexpedition.h"
#import "REXUtils.h"

@interface Reexpedition(){
    NSArray *countries;
}

@end

@implementation Reexpedition

- (instancetype)init {
    if (self = [super init]) {
        self.isNationnalReex = YES;
        self.activationType = NONE;
        self.allPersons = [NSNumber numberWithBool:NO];
    }
    return self;
}

- (NSArray *)countries {
    return self->countries;
}

- (void)setCountries:(NSArray *)countries {
    self->countries = [self filterCountries:countries];
}

- (NSArray *)filterCountries:(NSArray *)countries {
    if (countries) {
        NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in countries) {
            if (![[REXUtils forbiddenList] containsObject: dic[@"name"]]) {
                [tmpArray addObject:dic];
            }
        }
        return tmpArray;
    }
    return [[NSArray alloc] init];
}

@end

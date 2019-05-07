//
//  HYBStatusPhila.m
//  LPSharedMCM
//
//  Created by Issam DAHECH on 06/06/2018.
//

#import "HYBStatusPhila.h"

@implementation HYBStatusPhila

    + (instancetype)statusPhilaWithParams:(NSDictionary*)params {
        
        NSError *error = nil;
        HYBStatusPhila *object = [MTLJSONAdapter modelOfClass:[HYBStatusPhila class] fromJSONDictionary:params error:&error];
        
        if (error) {
            NSLog(@"1 Couldn't convert JSON to model HYBStatusPhila");
            return nil;
        }
        
        return object;
    }
    
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"code"        : @"code",
             @"displayName" : @"displayName"
             };
}
    
@end

//
//  HYBStatusPhila.h
//  LPSharedMCM
//
//  Created by Issam DAHECH on 06/06/2018.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface HYBStatusPhila : MTLModel <MTLJSONSerializing>
    
    @property (nonatomic) NSString *code;
    @property (nonatomic) NSString *displayName;
    
    + (instancetype)statusPhilaWithParams:(NSDictionary*)params;
    
@end

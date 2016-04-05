//
//  CoordinateGesture.m
//  CBXDriver
//
//  Created by Chris Fuentes on 4/5/16.
//  Copyright © 2016 Calabash. All rights reserved.
//

#import "CBCoordinateGesture.h"

@implementation CBCoordinateGesture
/*
    Defaults for all coordinate gestures
 */
- (NSArray <NSString *> *)requiredOptions { return @[ CB_COORDINATE_KEY ]; }
- (NSArray <NSString *> *)requiredSpecifiers { return @[]; }
- (NSArray <NSString *> *)optionalOptions { return @[ CB_DURATION_KEY ]; }
- (NSArray <NSString *> *)optionalSpecifiers { return @[]; }

/*
    Default coordinate validation: Requires a coordinate. 
 */
- (void)validate {
    NSDictionary *coordDict = [self.query coordinate];
    if (!coordDict) {
        NSString *msg = [NSString stringWithFormat:@"%@ requires a coordinate. Syntax is [ x, y ] or { x : #, y : # }.", self.class.name];
        @throw [CBInvalidArgumentException withFormat:@"[%@] %@ Query: %@",
                self.class.name,
                msg,
                [self.query toJSONString]];
    }
    [JSONUtils validatePointJSON:coordDict]; 
}
@end

//
//  CBGestureFactory.m
//  CBXDriver
//
//  Created by Chris Fuentes on 3/18/16.
//  Copyright © 2016 Calabash. All rights reserved.
//

#import "CBInvalidArgumentException.h"
#import "CBGestureFactory.h"
#import "CBTapCoordinate.h"

@implementation CBGestureFactory
+ (void)executeGestureWithJSON:(NSDictionary *)json completion:(CompletionBlock)completion {
    NSString *gesture = json[@"gesture"];
    NSArray *keys = [json allKeys];
    if (!gesture) {
        @throw [CBInvalidArgumentException withMessage:@"Invalid gesture: missing 'gesture' key."];
    }
    
    if ([gesture isEqualToString:@"tap"]) {
        if ([keys containsObject:CB_COORDINATE_KEY]) {
            [CBTapCoordinate executeWithJSON:json completion:completion];
        }
    }
    
    @throw [CBInvalidArgumentException withMessage:
            [NSString stringWithFormat:
             @"Invalid gesture: No matching gesture for '%@' with specifiers: %@", gesture, json]];
}
@end

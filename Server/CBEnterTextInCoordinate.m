//
//  CBEnterTextInCoordinates.m
//  CBXDriver
//
//  Created by Chris Fuentes on 4/4/16.
//  Copyright © 2016 Calabash. All rights reserved.
//

#import "CBEnterTextInCoordinate.h"
#import "CBTapCoordinate.h"
#import "JSONUtils.h"

@implementation CBEnterTextInCoordinate
+ (NSString *)name { return @"enter_text_in_coordinate"; }

+ (CBGesture *)executeWithJSON:(NSDictionary *)json completion:(CompletionBlock)completion {
    NSMutableDictionary *j = [json mutableCopy];
    
    if (![[j allKeys] containsObject:CB_STRING_KEY]) {
        @throw [CBInvalidArgumentException withFormat:@"Missing required key 'string'"];
    }
    
    NSString *string = j[CB_STRING_KEY];
    [j removeObjectForKey:CB_STRING_KEY];
    
    CBTapCoordinate *tap = [CBTapCoordinate withJSON:j];
    [tap execute:^(NSError *e) {
        if (e) {
            completion(e);
        } else {
            [[Testmanagerd get] _XCT_sendString:string completion:^(NSError *e) {
                if (e) @throw [CBException withMessage:@"Error performing gesture"];
            }];
            completion(e);
        }
    }];
    
    return tap;
}
@end

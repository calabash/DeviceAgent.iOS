//
//  CBEnterTextInCoordinates.m
//  CBXDriver
//
//  Created by Chris Fuentes on 4/4/16.
//  Copyright © 2016 Calabash. All rights reserved.
//

#import "CBEnterTextIn.h"
#import "JSONUtils.h"
#import "CBTouch.h"

@implementation CBEnterTextIn
+ (NSString *)name { return @"enter_text_in"; }

+ (CBGesture *)executeWithGestureConfiguration:(GestureConfiguration *)gestureConfig
                                         query:(CBQuery *)query
                                    completion:(CompletionBlock)completion {
    
    NSString *string = gestureConfig[CB_STRING_KEY];
    if (!string) {
        @throw [CBInvalidArgumentException withFormat:@"Missing required key 'string'"];
    }
    
    CBTouch *touch = [CBTouch withGestureConfiguration:gestureConfig query:query];
    [touch execute:^(NSError *e) {
        if (e) {
            completion(e);
        } else {
            [[Testmanagerd get] _XCT_sendString:string completion:^(NSError *e) {
                if (e) @throw [CBException withMessage:@"Error performing gesture"];
            }];
            completion(e);
        }
    }];
    
    return touch;
}
@end

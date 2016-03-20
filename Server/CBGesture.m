//
//  CBGesture.m
//  CBXDriver
//
//  Created by Chris Fuentes on 3/17/16.
//  Copyright © 2016 Calabash. All rights reserved.
//

#import "CBGesture.h"

@implementation CBGesture

+ (CBGesture *)executeWithJSON:(NSDictionary *)json
                    completion:(CompletionBlock)completion {
    CBGesture *gest = [self withJSON:json];
    [gest execute:completion];
    return gest;
}

+ (instancetype)withJSON:(NSDictionary *)json {
    CBGesture *gesture = [self new];
    gesture.name = json[@"gesture"];
    
    id specs = [json mutableCopy];
    [specs removeObjectForKey:@"gesture"];
    
    if (json[@"query"]) {
        [specs removeObjectForKey:@"query"];
        gesture.query = [CBElementQuery withQueryString:json[@"query"] specifiers:specs];
    } else {
        gesture.query = [CBElementQuery withSpecifiers:json];
    }
    
    return gesture;
}

- (XCSynthesizedEventRecord *)event {
    _must_override_exception;
}

- (XCTouchGesture *)gesture {
    _must_override_exception;
}

- (void)execute:(CompletionBlock)completion {
    [self validate];
    if ([[XCTestDriver sharedTestDriver] daemonProtocolVersion] != 0x0) {
        [[Testmanagerd get] _XCT_synthesizeEvent:[self event] completion:completion];
    } else {
        [[Testmanagerd get] _XCT_performTouchGesture:[self gesture] completion:completion];
    }
}

- (void)validate {
    _must_override_exception;
}
@end

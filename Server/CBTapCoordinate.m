//
//  CBTap.m
//  CBXDriver
//
//  Created by Chris Fuentes on 3/18/16.
//  Copyright © 2016 Calabash. All rights reserved.
//

#import "CBInvalidArgumentException.h"
#import "CBTapCoordinate.h"
#import "XCTouchGesture.h"
#import "XCTouchPath.h"
#import "JSONUtils.h"

@implementation CBTapCoordinate
- (id)init {
    if (self = [super init]) {
        self.name = @"tap";
    }
    return self;
}

- (void)validate {
    if (![self.query coordinate]) {
        NSString *msg = @"TapCoordinate requires a coordinate. Syntax is [ x, y ] or { x : #, y : # }";
        @throw [CBInvalidArgumentException withMessage:[NSString stringWithFormat:@"%@\nQuery: %@", msg, self.query]];
    }
}

- (void)_executePrivate:(CompletionBlock)completion {
    CGPoint coordinate = [JSONUtils pointFromCoordinateJSON:[self.query coordinate]];
    float duration = [self.query.specifiers.allKeys containsObject:@"duration"] ?
        [self.query.specifiers[@"duration"] floatValue] :
        0.2;
    XCTouchPath *touchPath = [[XCTouchPath alloc] initWithTouchDown:coordinate orientation:0 offset:0];
    [touchPath liftUpAtPoint:coordinate offset:duration];
    
    XCTouchGesture *touch = [XCTouchGesture new];
    [touch addTouchPath:touchPath];
    
    [[Testmanagerd get] _XCT_performTouchGesture:touch completion:completion];
}
@end

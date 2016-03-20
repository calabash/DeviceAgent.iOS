//
//  CBDoubleTapCoordinate.m
//  CBXDriver
//
//  Created by Chris Fuentes on 3/19/16.
//  Copyright © 2016 Calabash. All rights reserved.
//

#import "CBDoubleTapCoordinate.h"

@implementation CBDoubleTapCoordinate
- (id)init {
    if (self = [super init]) {
        self.name = @"double tap";
    }
    return self;
}

- (void)validate {
    if (![self.query coordinate]) {
        NSString *msg = @"TapCoordinate requires a coordinate. Syntax is [ x, y ] or { x : #, y : # }.";
        @throw [CBInvalidArgumentException withMessage:[NSString stringWithFormat:@"[%@] %@ Query: %@", self.name, msg, self.query]];
    }
}

- (XCSynthesizedEventRecord *)event {
    XCSynthesizedEventRecord *event = [[XCSynthesizedEventRecord alloc] initWithName:@"tap"
                                                                interfaceOrientation:0];
    
    CGPoint coordinate = [JSONUtils pointFromCoordinateJSON:[self.query coordinate]];
    
    XCPointerEventPath *path = [[XCPointerEventPath alloc] initForTouchAtPoint:coordinate
                                                                        offset:0];
    
    float duration = [self.query.specifiers.allKeys containsObject:CB_DURATION_KEY] ?
    [self.query.specifiers[CB_DURATION_KEY] floatValue] : 0;
    [path liftUpAtOffset:duration];
    [event addPointerEventPath:path]; //tap 1
    
    path = [[XCPointerEventPath alloc] initForTouchAtPoint:coordinate
                                                    offset:0];
    [path liftUpAtOffset:duration];
    [event addPointerEventPath:path]; //tap 2
    
    return event;
}

- (XCTouchGesture *)gesture {
    XCTouchGesture *gesture = [[XCTouchGesture alloc] initWithName:@"tap"];
    
    CGPoint coordinate = [JSONUtils pointFromCoordinateJSON:[self.query coordinate]];
    
    XCTouchPath *path = [[XCTouchPath alloc] initWithTouchDown:coordinate
                                                   orientation:0
                                                        offset:0];
    
    float duration = [self.query.specifiers.allKeys containsObject:CB_DURATION_KEY] ?
    [self.query.specifiers[CB_DURATION_KEY] floatValue] : 0;
    [path liftUpAtPoint:coordinate
                 offset:duration];
    [gesture addTouchPath:path]; //tap 1
    
    path = [[XCTouchPath alloc] initWithTouchDown:coordinate
                                      orientation:0
                                           offset:0];
    [path liftUpAtPoint:coordinate
                 offset:duration];
    [gesture addTouchPath:path]; //tap 2
    return gesture;
}
@end

//
//  CBDragCoordinate.m
//  CBXDriver
//
//  Created by Chris Fuentes on 3/20/16.
//  Copyright © 2016 Calabash. All rights reserved.
//

#import "CBDrag.h"

@implementation CBDrag
+ (NSString *)name { return @"drag"; }
- (NSArray <NSString *> *)requiredOptions { return @[ CB_COORDINATES_KEY ]; }

- (XCSynthesizedEventRecord *)eventWithCoordinates:(NSArray<CBCoordinate *> *)coordinates {
    XCSynthesizedEventRecord *event = [[XCSynthesizedEventRecord alloc] initWithName:self.class.name
                                                                interfaceOrientation:0];
    float duration = self.gestureConfiguration[CB_DURATION_KEY] ?
        [self.gestureConfiguration[CB_DURATION_KEY] floatValue] :
        CB_DEFAULT_DURATION;
    
    CGPoint coordinate = coordinates[0].cgpoint;
    XCPointerEventPath *path = [[XCPointerEventPath alloc] initForTouchAtPoint:coordinate
                                                                        offset:0];
    
    for (CBCoordinate *coord in coordinates) {
        if (coord == coordinates.firstObject) { continue; }
        duration += duration;
        coordinate = coord.cgpoint;
        [path moveToPoint:coordinate atOffset:duration];
    }
    
    [path liftUpAtOffset:duration];
    [event addPointerEventPath:path];
    
    return event;
}

- (XCTouchGesture *)gestureWithCoordinates:(NSArray<CBCoordinate *> *)coordinates {
    XCTouchGesture *gesture = [[XCTouchGesture alloc] initWithName:self.class.name];
    
    CGPoint coordinate = coordinates[0].cgpoint;
    float duration = self.gestureConfiguration[CB_DURATION_KEY] ?
        [self.gestureConfiguration[CB_DURATION_KEY] floatValue] :
        CB_DEFAULT_DURATION;
    
    XCTouchPath *path = [[XCTouchPath alloc] initWithTouchDown:coordinate
                                                   orientation:0
                                                        offset:0];
    for (CBCoordinate *coord in coordinates) {
        if (coord == coordinates.firstObject) { continue; }
        duration += duration;
        coordinate = coord.cgpoint;
        [path moveToPoint:coordinate atOffset:duration];
    }
    duration += CB_GESTURE_EPSILON;
    
    [path liftUpAtPoint:coordinate
                 offset:duration];
    [gesture addTouchPath:path];
    return gesture;
}
@end

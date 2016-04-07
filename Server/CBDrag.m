//
//  CBDragCoordinate.m
//  CBXDriver
//
//  Created by Chris Fuentes on 3/20/16.
//  Copyright © 2016 Calabash. All rights reserved.
//

#import "CoordinateQueryConfiguration.h"
#import "CBDrag.h"

@implementation CBDrag
+ (NSString *)name { return @"drag"; }

+ (NSArray <NSString *> *)optionalKeys { return @[CB_DURATION_KEY, CB_REPITITIONS_KEY]; }

- (void)validate {
    NSArray *coords = [[self.query.queryConfiguration asCoordinateQueryConfiguration] coordinates];
    if (!coords || coords.count < 2) {
        @throw [CBInvalidArgumentException withFormat:@"Expected at least 2 coordinates for drag, got %li",
                (long)coords.count];
    }
}

- (XCSynthesizedEventRecord *)eventWithCoordinates:(NSArray<CBCoordinate *> *)coordinates {
    XCSynthesizedEventRecord *event = [[XCSynthesizedEventRecord alloc] initWithName:self.class.name
                                                                interfaceOrientation:0];
    float duration = [self duration];
    float offset = duration;
    
    CGPoint coordinate = coordinates[0].cgpoint;
    XCPointerEventPath *path = [[XCPointerEventPath alloc] initForTouchAtPoint:coordinate
                                                                        offset:0];
    
    for (int i = 0; i < [self repititions]; i ++) {
        for (CBCoordinate *coord in coordinates) {
            if (coord == coordinates.firstObject) { continue; }
            offset += duration;
            coordinate = coord.cgpoint;
            [path moveToPoint:coordinate atOffset:offset];
        }
    }
    
    [path liftUpAtOffset:offset];
    [event addPointerEventPath:path];
    
    return event;
}

- (XCTouchGesture *)gestureWithCoordinates:(NSArray<CBCoordinate *> *)coordinates {
    XCTouchGesture *gesture = [[XCTouchGesture alloc] initWithName:self.class.name];
    
    CGPoint coordinate = coordinates[0].cgpoint;
    float duration = [self duration];
    float offset = duration;
    
    XCTouchPath *path = [[XCTouchPath alloc] initWithTouchDown:coordinate
                                                   orientation:0
                                                        offset:0];
    for (int i = 0; i < [self repititions]; i ++) {
        for (CBCoordinate *coord in coordinates) {
            if (coord == coordinates.firstObject) { continue; }
            offset += duration;
            coordinate = coord.cgpoint;
            [path moveToPoint:coordinate atOffset:offset];
        }
    }
    offset += CB_GESTURE_EPSILON;
    
    [path liftUpAtPoint:coordinate
                 offset:offset];
    [gesture addTouchPath:path];
    return gesture;
}
@end

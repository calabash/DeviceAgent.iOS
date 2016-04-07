//
//  CBTap.m
//  CBXDriver
//
//  Created by Chris Fuentes on 3/18/16.
//  Copyright © 2016 Calabash. All rights reserved.
//

#import "CoordinateQueryConfiguration.h"
#import "CBTouch.h"

@implementation CBTouch

+ (NSString *)name { return @"touch"; }

- (XCSynthesizedEventRecord *)eventWithCoordinates:(NSArray<CBCoordinate *> *)coordinates {
    if (coordinates.count == 0) {
        @throw [CBInvalidArgumentException withFormat:@"%@ requires at least one coordinate.",  [self.class name]];
    }
    
    XCSynthesizedEventRecord *event = [[XCSynthesizedEventRecord alloc] initWithName:self.class.name
                                                                interfaceOrientation:0];
    
    CGPoint coordinate = coordinates[0].cgpoint;
    
    XCPointerEventPath *path = [[XCPointerEventPath alloc] initForTouchAtPoint:coordinate
                                                                        offset:0];
    
    float duration = [self duration];
    
    [path liftUpAtOffset:duration];
    
    
    [event addPointerEventPath:path];
    return event;
}

- (XCTouchGesture *)gestureWithCoordinates:(NSArray<CBCoordinate *> *)coordinates {
    if (coordinates.count == 0) {
        @throw [CBInvalidArgumentException withFormat:@"%@ requires at least one coordinate.",  [self.class name]];
    }
    
    XCTouchGesture *gesture = [[XCTouchGesture alloc] initWithName:self.class.name];
    
    CGPoint coordinate = coordinates[0].cgpoint;
    
    XCTouchPath *path = [[XCTouchPath alloc] initWithTouchDown:coordinate
                                                   orientation:0
                                                        offset:0];
    
    float duration = [self duration];
    
    [path liftUpAtPoint:coordinate
                 offset:duration];
    [gesture addTouchPath:path];
    return gesture;
}

@end

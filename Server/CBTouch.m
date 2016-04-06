//
//  CBTap.m
//  CBXDriver
//
//  Created by Chris Fuentes on 3/18/16.
//  Copyright © 2016 Calabash. All rights reserved.
//

#import "CBTouch.h"

@implementation CBTouch

+ (NSString *)name { return @"touch"; }

- (XCSynthesizedEventRecord *)eventWithCoordinates:(NSArray<CBCoordinate *> *)coordinates {
    XCSynthesizedEventRecord *event = [[XCSynthesizedEventRecord alloc] initWithName:self.class.name
                                                                interfaceOrientation:0];
    
    CGPoint coordinate = coordinates[0].cgpoint;
    
    XCPointerEventPath *path = [[XCPointerEventPath alloc] initForTouchAtPoint:coordinate
                                                                        offset:0];
    
    float duration = self.query[CB_DURATION_KEY] ?
        [self.query[CB_DURATION_KEY] floatValue] :
        CB_DEFAULT_DURATION;
    
    [path liftUpAtOffset:duration];
    [event addPointerEventPath:path];
    return event;
}

- (XCTouchGesture *)gestureWithCoordinates:(NSArray<CBCoordinate *> *)coordinates {
    XCTouchGesture *gesture = [[XCTouchGesture alloc] initWithName:self.class.name];
    
    CGPoint coordinate = coordinates[0].cgpoint;
    
    XCTouchPath *path = [[XCTouchPath alloc] initWithTouchDown:coordinate
                                                   orientation:0
                                                        offset:0];
    
    float duration = self.query[CB_DURATION_KEY] ?
        [self.query[CB_DURATION_KEY] floatValue] :
        CB_DEFAULT_DURATION;
    
    [path liftUpAtPoint:coordinate
                 offset:duration];
    [gesture addTouchPath:path];
    return gesture;
}

@end

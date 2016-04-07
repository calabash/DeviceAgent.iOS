//
//  CBDoubleTapCoordinate.m
//  CBXDriver
//
//  Created by Chris Fuentes on 3/19/16.
//  Copyright © 2016 Calabash. All rights reserved.
//

#import "CBDoubleTap.h"

@implementation CBDoubleTap

+ (NSString *)name { return @"double_tap"; }

- (XCSynthesizedEventRecord *)eventWithCoordinates:(NSArray<CBCoordinate *> *)coordinates {
    XCSynthesizedEventRecord *event = [[XCSynthesizedEventRecord alloc] initWithName:self.class.name
                                                                interfaceOrientation:0];
    
    CGPoint coordinate = coordinates[0].cgpoint;
    
    XCPointerEventPath *path = [[XCPointerEventPath alloc] initForTouchAtPoint:coordinate
                                                                        offset:0];
    
    float duration = [self duration];
    float offset = duration;
    
    [path liftUpAtOffset:offset];
    [event addPointerEventPath:path]; //tap 1
    
    offset += duration;
    
    path = [[XCPointerEventPath alloc] initForTouchAtPoint:coordinate
                                                    offset:offset];
    offset += duration;
    [path liftUpAtOffset:offset];
    [event addPointerEventPath:path]; //tap 2
    
    return event;
}

- (XCTouchGesture *)gestureWithCoordinates:(NSArray<CBCoordinate *> *)coordinates {
    XCTouchGesture *gesture = [[XCTouchGesture alloc] initWithName:self.class.name];
    
    CGPoint coordinate = coordinates[0].cgpoint;
    
    XCTouchPath *path = [[XCTouchPath alloc] initWithTouchDown:coordinate
                                                   orientation:0
                                                        offset:0];
    
    float duration = [self duration];
    float offset = duration;
    
    [path liftUpAtPoint:coordinate
                 offset:offset];
    [gesture addTouchPath:path]; //tap 1
    
    path = [[XCTouchPath alloc] initWithTouchDown:coordinate
                                      orientation:0
                                           offset:offset];
    offset += duration;
    [path liftUpAtPoint:coordinate
                 offset:offset];
    [gesture addTouchPath:path]; //tap 2
    return gesture;
}
@end

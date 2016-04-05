//
//  CBPinchCoordinate.m
//  CBXDriver
//
//  Created by Chris Fuentes on 4/4/16.
//  Copyright © 2016 Calabash. All rights reserved.
//

#import "CBPinchCoordinate.h"

@implementation CBPinchCoordinate
+ (NSString *)name { return @"pinch_coordinate"; }

- (NSArray <NSString *> *)requiredKeys {
    return @[ CB_COORDINATE_KEY ];
}
- (NSArray <NSString *> *)optionalKeys {
    return @[ CB_DURATION_KEY, CB_AMOUNT_KEY, CB_PINCH_DIRECTION_KEY];
}

- (void)validate {
    if (![self.query coordinate]) {
        NSString *msg = @"PinchCoordinate requires a coordinate. Syntax is [ x, y ] or { x : #, y : # }.";
        @throw [CBInvalidArgumentException withFormat:@"[%@] %@ Query: %@", self.class.name, msg, [self.query toJSONString]];
    }
}

- (XCSynthesizedEventRecord *)event {
    XCSynthesizedEventRecord *event = [[XCSynthesizedEventRecord alloc] initWithName:self.class.name
                                                                interfaceOrientation:0];
    
    CGPoint coordinate = [JSONUtils pointFromCoordinateJSON:[self.query coordinate]];
    
    XCPointerEventPath *path = [[XCPointerEventPath alloc] initForTouchAtPoint:coordinate
                                                                        offset:0];
    
    float duration = [self.query.specifiers.allKeys containsObject:CB_DURATION_KEY] ?
    [self.query.specifiers[CB_DURATION_KEY] floatValue] : CB_DEFAULT_DURATION;
    
    
    [path liftUpAtOffset:duration];
    [event addPointerEventPath:path];
    return event;
}

- (XCTouchGesture *)gesture {
    XCTouchGesture *gesture = [[XCTouchGesture alloc] initWithName:self.class.name];
    
    CGPoint center = [JSONUtils pointFromCoordinateJSON:[self.query coordinate]];
    
    float duration = [self.query.specifiers.allKeys containsObject:CB_DURATION_KEY] ?
    [self.query.specifiers[CB_DURATION_KEY] floatValue] : CB_DEFAULT_DURATION;
    
    float amount = [self.query.specifiers.allKeys containsObject:CB_AMOUNT_KEY] ?
    [self.query.specifiers[CB_AMOUNT_KEY] floatValue] : CB_DEFAULT_PINCH_AMOUNT;
    
    NSString *direction = [self.query.specifiers.allKeys containsObject:CB_PINCH_DIRECTION_KEY] ?
    self.query.specifiers[CB_PINCH_DIRECTION_KEY] : CB_DEFAULT_PINCH_DIRECTION;
    
    CGPoint p1 = center,
        p2 = center;
    
    //TODO: let user specify orientation of pinch?
    p1.x -= amount;
    p2.x += amount;
    
    for (NSValue *v in @[ [NSValue valueWithCGPoint:p1], [NSValue valueWithCGPoint:p2]]) {
        if ([direction isEqualToString:CB_PINCH_OUT]) {
            XCTouchPath *path = [[XCTouchPath alloc] initWithTouchDown:center
                                                           orientation:0
                                                                offset:0];
            [path moveToPoint:[v CGPointValue] atOffset:duration];
            [path liftUpAtPoint:[v CGPointValue]
                         offset:duration + CB_GESTURE_EPSILON];
            [gesture addTouchPath:path];
        } else {
            XCTouchPath *path = [[XCTouchPath alloc] initWithTouchDown:[v CGPointValue]
                                                           orientation:0
                                                                offset:0];
            [path moveToPoint:center atOffset:duration];
            [path liftUpAtPoint:center
                         offset:duration + CB_GESTURE_EPSILON];
            [gesture addTouchPath:path];
        }
    }
    
    return gesture;
}
@end

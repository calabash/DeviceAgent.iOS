//
//  CBTap.m
//  CBXDriver
//
//  Created by Chris Fuentes on 3/23/16.
//  Copyright © 2016 Calabash. All rights reserved.
//

#import "CBTap.h"

@implementation CBTap
+ (NSString *)name { return @"tap"; }

- (NSArray <NSString *> *)requiredOptions { return @[]; }
- (NSArray <NSString *> *)requiredSpecifiers { return @[]; }
- (NSArray <NSString *> *)optionalOptions { return @[ CB_DURATION_KEY ]; }
- (NSArray <NSString *> *)optionalSpecifiers { return [CBGesture defaultOptionalSpecifiers]; }


- (XCSynthesizedEventRecord *)eventWithElements:(NSArray<XCUIElement *> *)elements {
    XCUIElement *el = elements[0];
    XCSynthesizedEventRecord *event = [[XCSynthesizedEventRecord alloc] initWithName:self.class.name
                                                                interfaceOrientation:0];
    
    CGRect frame = el.wdFrame;
    //TODO: use visible center
    
    CGPoint center = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
    
    XCPointerEventPath *path = [[XCPointerEventPath alloc] initForTouchAtPoint:center
                                                                        offset:0];
    
    float duration = self.query[CB_DURATION_KEY] ?
        [self.query[CB_DURATION_KEY] floatValue] :
        CB_DEFAULT_DURATION;
    
    [path liftUpAtOffset:duration];
    [event addPointerEventPath:path];
    
    return event;
}

- (XCTouchGesture *)gestureWithElements:(NSArray<XCUIElement *> *)elements {
    XCUIElement *el = elements[0];
    
    CGRect frame = el.wdFrame;
    //TODO: use visible center
    CGPoint center =  CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
    
    XCTouchGesture *gesture = [[XCTouchGesture alloc] initWithName:self.class.name];

    XCTouchPath *path = [[XCTouchPath alloc] initWithTouchDown:center
                                                   orientation:0
                                                        offset:0];
    
    float duration = self.query[CB_DURATION_KEY] ?
        [self.query[CB_DURATION_KEY] floatValue] :
        CB_DEFAULT_DURATION;
    
    [path liftUpAtPoint:center
                 offset:duration];
    [gesture addTouchPath:path];
    return gesture;
}


@end

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

- (NSArray <NSString *> *)requiredKeys {
    return @[];
}

- (NSArray <NSString *> *)optionalKeys {
    return @[ @"duration" ];
}

- (NSArray <NSString *> *)optionalSpecifiers {
    return @[ @"id", @"text", @"text_like", @"property", @"property_like", @"index" ];
}

- (void)validate {
    BOOL contains = NO;
    NSArray *specifiers = [self optionalSpecifiers];
    for (NSString *key in specifiers) {
        if ([self.query.specifiers.allKeys containsObject:key]) {
            contains = YES;
            break;
        }
    }
    if (!contains) {
        @throw [CBInvalidArgumentException withFormat:
                @"[%@] Requires at least one of the following specifiers: %@",
                self.class.name,
                [JSONUtils objToJSONString:specifiers]];
    }
}

- (XCSynthesizedEventRecord *)event {
    NSArray <XCUIElement *> *elements = [self.query execute];
    if (elements.count == 0) {
        [self.warnings addObject:@"No matches found."];
        return nil;
    }
    
    XCUIElement *el = elements[0];
    XCSynthesizedEventRecord *event = [[XCSynthesizedEventRecord alloc] initWithName:self.class.name
                                                                interfaceOrientation:0];
    
    CGRect frame = el.wdFrame;
    //TODO: use visible center
    
    CGPoint center = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
    
    XCPointerEventPath *path = [[XCPointerEventPath alloc] initForTouchAtPoint:center
                                                                        offset:0];
    
    float duration = [self.query.specifiers.allKeys containsObject:CB_DURATION_KEY] ?
    [self.query.specifiers[CB_DURATION_KEY] floatValue] : DB_DEFAULT_DURATION;
    
    [path liftUpAtOffset:duration];
    [event addPointerEventPath:path];
    
    return event;
}

- (XCTouchGesture *)gesture {
    NSArray <XCUIElement *> *elements = [self.query execute];
    if (elements.count == 0) {
        [self.warnings addObject:@"No matches found."];
        return nil;
    }
    XCUIElement *el = elements[0];
    
    CGRect frame = el.wdFrame;
    //TODO: use visible center
    CGPoint center =  CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
    
    XCTouchGesture *gesture = [[XCTouchGesture alloc] initWithName:self.class.name];

    XCTouchPath *path = [[XCTouchPath alloc] initWithTouchDown:center
                                                   orientation:0
                                                        offset:0];
    
    float duration = [self.query.specifiers.allKeys containsObject:CB_DURATION_KEY] ?
    [self.query.specifiers[CB_DURATION_KEY] floatValue] : DB_DEFAULT_DURATION;
    
    [path liftUpAtPoint:center
                 offset:duration];
    [gesture addTouchPath:path];
    return gesture;
}


@end

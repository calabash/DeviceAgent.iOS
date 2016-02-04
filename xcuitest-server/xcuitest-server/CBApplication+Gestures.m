//
//  CBApplication+Gestures.m
//  xcuitest-server
//

#import "CBApplication+Gestures.h"
#import "XCUICoordinate.h"

@implementation CBApplication(Gestures)

+ (XCUICoordinate *)coordinateFor:(float)x :(float)y {
    //Using current application as the element has the effect of
    //using the main window as your coordinate space
    XCUICoordinate *appCoordinate = [[XCUICoordinate alloc] initWithElement:[self currentApplication]
                                                           normalizedOffset:CGVectorMake(0, 0)];
    
    XCUICoordinate *coordinate = [[XCUICoordinate alloc] initWithCoordinate:appCoordinate
                                                               pointsOffset:CGVectorMake(x, y)];
    return coordinate;
}

+ (void)tap:(float)x :(float)y {
    [[self coordinateFor:x :y] tap];
}

+ (void)doubleTap:(float)x :(float)y {
    [[self coordinateFor:x :y] doubleTap];
}

+ (void)press:(float)x :(float)y forDuration:(NSTimeInterval)duration {
    [[self coordinateFor:x :y] pressForDuration:duration];
}

+ (void)press:(float)x1 :(float)y1 forDuration:(NSTimeInterval)duration
   thenDragTo:(float)x2 :(float)y2 {
    XCUICoordinate *start = [self coordinateFor:x1 :y1];
    XCUICoordinate *end = [self coordinateFor:x2 :y2];
    
    [start pressForDuration:duration
       thenDragToCoordinate:end];
}

@end

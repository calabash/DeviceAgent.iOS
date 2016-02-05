//
//  CBApplication+Gestures.m
//  xcuitest-server
//

#import "CBApplication+Gestures.h"
#import "CBApplication+Queries.h"
#import "XCUICoordinate.h"
#import "JSONUtils.h"

@implementation CBApplication(Gestures)

#pragma mark - Non specific API
+ (void)swipeUp {
    [[self currentApplication] swipeUp];
}

+ (void)swipeDown {
    [[self currentApplication] swipeDown];
}

+ (void)swipeLeft {
    [[self currentApplication] swipeLeft];
}

+ (void)swipeRight {
    [[self currentApplication] swipeRight];
}

#pragma mark - Identifier Methods

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

#pragma mark - Marked Methods

+ (BOOL)tapMarked:(NSString *)text {
    return [self gesture:@selector(tap) onMarked:text];
}

+ (BOOL)doubleTapMarked:(NSString *)text {
    return [self gesture:@selector(doubleTap) onMarked:text];
}

+ (BOOL)twoFingerTapMarked:(NSString *)text {
    return [self gesture:@selector(twoFingerTap) onMarked:text];
}

+ (BOOL)swipeUpOnMarked:(NSString *)text {
    return [self gesture:@selector(swipeUp) onMarked:text];
}

+ (BOOL)swipeDownOnMarked:(NSString *)text {
    return [self gesture:@selector(swipeDown) onMarked:text];
}

+ (BOOL)swipeLeftOnMarked:(NSString *)text {
    return [self gesture:@selector(swipeLeft) onMarked:text];
}

+ (BOOL)swipeRightOnMarked:(NSString *)text {
    return [self gesture:@selector(swipeRight) onMarked:text];
}

#pragma mark - Identifier Methods

+ (BOOL)tapIdentifier:(NSString *)identifier {
    return [self gesture:@selector(tap) onIdentifier:identifier];
}

+ (BOOL)doubleTapIdentifier:(NSString *)identifier {
    return [self gesture:@selector(doubleTap) onIdentifier:identifier];
}

+ (BOOL)twoFingerTapIdentifier:(NSString *)identifier {
    return [self gesture:@selector(twoFingerTap) onIdentifier:identifier];
}

+ (BOOL)swipeUpOnIdentifier:(NSString *)identifier {
    return [self gesture:@selector(swipeUp) onIdentifier:identifier];
}

+ (BOOL)swipeDownOnIdentifier:(NSString *)identifier {
    return [self gesture:@selector(swipeDown) onIdentifier:identifier];
}

+ (BOOL)swipeLeftOnIdentifier:(NSString *)identifier {
    return [self gesture:@selector(swipeLeft) onIdentifier:identifier];
}

+ (BOOL)swipeRightOnIdentifier:(NSString *)identifier {
    return [self gesture:@selector(swipeRight) onIdentifier:identifier];
}

#pragma mark - Helper Methods

+ (void)performGesture:(_Nonnull SEL)gesture onElement:(XCUIElement *)el {
    [el performSelector:gesture withObject:nil];
    NSLog(@"Peforming %@ on %@", NSStringFromSelector(gesture), [JSONUtils elementToJSON:el]);
}

+ (BOOL)gesture:(_Nonnull SEL)gesture matchingSelector:(_Nonnull SEL)match valueToMatch:(NSString *)value {
    NSArray <XCUIElement *> *elements = [self performSelector:match withObject:value];
    
    if (elements.count == 0) {
        //TODO: error message?
        return NO;
    } else {
        [self performGesture:gesture onElement:[elements firstObject]];
        return YES;
    }
}

+ (BOOL)gesture:(_Nonnull SEL)gesture onMarked:(NSString *)text {
    return [self gesture:gesture matchingSelector:@selector(elementsMarked:) valueToMatch:text];
}

+ (BOOL)gesture:(_Nonnull SEL)gesture onIdentifier:(NSString *)identifier {
    return [self gesture:gesture matchingSelector:@selector(elementsWithIdentifier:) valueToMatch:identifier];
}
@end

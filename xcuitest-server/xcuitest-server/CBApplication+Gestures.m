//
//  CBApplication+Gestures.m
//  xcuitest-server
//

#import "CBApplication+Gestures.h"
#import "CBApplication+Queries.h"
#import "XCUICoordinate.h"
#import "JSONUtils.h"
#import "CBMacros.h"

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

+ (BOOL)tapMarked:(NSString *)mark {
    return [self gesture:@selector(tap) onMarked:mark];
}

+ (BOOL)doubleTapMarked:(NSString *)mark {
    return [self gesture:@selector(doubleTap) onMarked:mark];
}

+ (BOOL)twoFingerTapMarked:(NSString *)mark {
    return [self gesture:@selector(twoFingerTap) onMarked:mark];
}

+ (BOOL)swipeUpOnMarked:(NSString *)mark {
    return [self gesture:@selector(swipeUp) onMarked:mark];
}

+ (BOOL)swipeDownOnMarked:(NSString *)mark {
    return [self gesture:@selector(swipeDown) onMarked:mark];
}

+ (BOOL)swipeLeftOnMarked:(NSString *)mark {
    return [self gesture:@selector(swipeLeft) onMarked:mark];
}

+ (BOOL)swipeRightOnMarked:(NSString *)mark {
    return [self gesture:@selector(swipeRight) onMarked:mark];
}

+ (BOOL)typeText:(NSString *)text marked:(NSString *)mark {
    XCUIElement *el = [self elementMarked:mark];
    if (el) {
        [el typeText:text];
        return YES;
    }
    return NO;
}

+ (BOOL)rotateDegrees:(CGFloat)degrees velocity:(CGFloat)degreesPerSecond marked:(NSString *)mark {
    XCUIElement *el = [self elementMarked:mark];
    if (el) {
        [el rotate:degreesToRadians(degrees) withVelocity:degreesToRadians(degreesPerSecond)];
        return YES;
    }
    return NO;
}

+ (BOOL)pinchWithScale:(CGFloat)scaleMultiplier
              velocity:(CGFloat)scaleFactorPerSecond
                marked:(NSString *)mark {
    XCUIElement *el = [self elementMarked:mark];
    if (el) {
        [el pinchWithScale:scaleMultiplier velocity:scaleFactorPerSecond];
        return YES;
    }
    return NO;
}

+ (BOOL)tapWithNumberOfTaps:(NSUInteger)numTaps
            numberOfTouches:(NSUInteger)numTouches
                     marked:(NSString *)mark {
    XCUIElement *el = [self elementMarked:mark];
    if (el) {
        [el tapWithNumberOfTaps:numTaps numberOfTouches:numTouches];
        return YES;
    }
    return NO;
}

+ (BOOL)pressForDuration:(NSTimeInterval)duration marked:(NSString *)mark {
    XCUIElement *el = [self elementMarked:mark];
    if (el) {
        [el pressForDuration:duration];
        return YES;
    }
    return NO;
}

+ (BOOL)pressMarked:(NSString *)mark1
        forDuration:(NSTimeInterval)duration thenDragToElementMarked:(NSString *)mark2  {
    XCUIElement *el1 = [self elementMarked:mark1];
    XCUIElement *el2 = [self elementMarked:mark2];
    if (el1 && el2) {
        [el1 pressForDuration:duration thenDragToElement:el2];
        return YES;
    }
    return NO;
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

+ (BOOL)typeText:(NSString *)text identifier:(NSString *)identifier {
    XCUIElement *el = [self elementWithIdentifier:identifier];
    if (el) {
        [el typeText:text];
        return YES;
    }
    return NO;
}

+ (BOOL)rotateDegrees:(CGFloat)degrees velocity:(CGFloat)degreesPerSecond identifier:(NSString *)identifier {
    XCUIElement *el = [self elementWithIdentifier:identifier];
    if (el) {
        [el rotate:degreesToRadians(degrees) withVelocity:degreesToRadians(degreesPerSecond)];
        return YES;
    }
    return NO;
}

+ (BOOL)pinchWithScale:(CGFloat)scaleMultiplier
              velocity:(CGFloat)scaleFactorPerSecond
            identifier:(NSString *)identifier {
    XCUIElement *el = [self elementWithIdentifier:identifier];
    if (el) {
        [el pinchWithScale:scaleMultiplier velocity:scaleFactorPerSecond];
        return YES;
    }
    return NO;
}

//TODO:
//I have no idea what the use case is for this.
+ (BOOL)tapWithNumberOfTaps:(NSUInteger)numTaps
            numberOfTouches:(NSUInteger)numTouches
                 identifier:(NSString *)identifier {
    XCUIElement *el = [self elementWithIdentifier:identifier];
    if (el) {
        [el tapWithNumberOfTaps:numTaps numberOfTouches:numTouches];
        return YES;
    }
    return NO;
}

+ (BOOL)pressForDuration:(NSTimeInterval)duration identifier:(NSString *)identifier {
    XCUIElement *el = [self elementWithIdentifier:identifier];
    if (el) {
        [el pressForDuration:duration];
        return YES;
    }
    return NO;
}

+ (BOOL)pressIdentifier:(NSString *)id1
            forDuration:(NSTimeInterval)duration thenDragToElementWithIdentifier:(NSString *)id2  {
    XCUIElement *el1 = [self elementWithIdentifier:id1];
    XCUIElement *el2 = [self elementWithIdentifier:id2];
    if (el1 && el2) {
        [el1 pressForDuration:duration thenDragToElement:el2];
        return YES;
    }
    return NO;
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

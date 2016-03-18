//
//  CBApplication+Gestures.m
//  xcuitest-server
//

#import "CBElementNotFoundException.h"
#import "CBApplication+Gestures.h"
#import "CBApplication+Queries.h"
#import "XCUICoordinate.h"
#import "XCTouchGesture.h"
#import "XCTouchEvent.h"
#import "Testmanagerd.h"
#import "XCUIElement.h"
#import "XCTouchPath.h"
#import "JSONUtils.h"
#import "CBMacros.h"

@implementation CBApplication(Gestures)

+ (void)performGesture:(CBGesture *)gesture completion:(CompletionBlock)completion {
    
}

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
    XCTouchPath *path = [[XCTouchPath alloc] initWithTouchDown:CGPointMake(x, y) orientation: 0l offset: 0];
    [path liftUpAtPoint:CGPointMake(x, y) offset:0.3];
    [path complete];
    
    XCTouchGesture *gesture = [[XCTouchGesture alloc] initWithName:@"touch"];
    [gesture addTouchPath: path];
    [[Testmanagerd get] _XCT_performTouchGesture:gesture completion:^(NSError *err) {
        if (err) {
            NSLog(@"Unable to tap %f, %f: %@", x, y, err);
        }
    }];
}

+ (void)doubleTap:(float)x :(float)y {
    XCTouchPath *path = [[XCTouchPath alloc] initWithTouchDown:CGPointMake(x, y) orientation: 0l offset: 0];
    [path liftUpAtPoint:CGPointMake(x, y) offset:0.3];
    XCTouchEvent *event = [XCTouchEvent touchEventWithType:0 coordinate:CGPointMake(x, y) offset:0.5];
    [path _addTouchEvent:event];
    [path complete];
    
    XCTouchGesture *gesture = [[XCTouchGesture alloc] initWithName:@"touch"];
    [gesture addTouchPath: path];
    [[Testmanagerd get] _XCT_performTouchGesture:gesture completion:^(NSError *err) {
        if (err) {
            NSLog(@"Unable to doubleTap %f, %f: %@", x, y, err);
        }
    }];
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

+ (XCUIElement *)tapMarked:(NSString *)mark {
    return [self gesture:@selector(tap) onMarked:mark];
}

+ (XCUIElement *)doubleTapMarked:(NSString *)mark {
    return [self gesture:@selector(doubleTap) onMarked:mark];
}

+ (XCUIElement *)twoFingerTapMarked:(NSString *)mark {
    return [self gesture:@selector(twoFingerTap) onMarked:mark];
}

+ (XCUIElement *)swipeUpOnMarked:(NSString *)mark {
    return [self gesture:@selector(swipeUp) onMarked:mark];
}

+ (XCUIElement *)swipeDownOnMarked:(NSString *)mark {
    return [self gesture:@selector(swipeDown) onMarked:mark];
}

+ (XCUIElement *)swipeLeftOnMarked:(NSString *)mark {
    return [self gesture:@selector(swipeLeft) onMarked:mark];
}

+ (XCUIElement *)swipeRightOnMarked:(NSString *)mark {
    return [self gesture:@selector(swipeRight) onMarked:mark];
}

+ (XCUIElement *)typeText:(NSString *)text marked:(NSString *)mark {
    XCUIElement *el = [self elementMarkedOrThrow:mark];
    [el typeText:text];
    return el;
}

+ (XCUIElement *)rotateDegrees:(CGFloat)degrees velocity:(CGFloat)degreesPerSecond marked:(NSString *)mark {
    XCUIElement *el = [self elementMarkedOrThrow:mark];
    [el rotate:degreesToRadians(degrees) withVelocity:degreesToRadians(degreesPerSecond)];
    return el;
}

+ (XCUIElement *)pinchWithScale:(CGFloat)scaleMultiplier
                       velocity:(CGFloat)scaleFactorPerSecond
                         marked:(NSString *)mark {
    XCUIElement *el = [self elementMarkedOrThrow:mark];
    [el pinchWithScale:scaleMultiplier velocity:scaleFactorPerSecond];
    return el;
}

+ (XCUIElement *)tapWithNumberOfTaps:(NSUInteger)numTaps
                     numberOfTouches:(NSUInteger)numTouches
                              marked:(NSString *)mark {
    XCUIElement *el = [self elementMarkedOrThrow:mark];
    [el tapWithNumberOfTaps:numTaps numberOfTouches:numTouches];
    return el;
}

+ (XCUIElement *)pressForDuration:(NSTimeInterval)duration marked:(NSString *)mark {
    XCUIElement *el = [self elementMarkedOrThrow:mark];
    [el pressForDuration:duration];
    return el;
}

+ (XCUIElement *)pressMarked:(NSString *)mark1
                 forDuration:(NSTimeInterval)duration thenDragToElementMarked:(NSString *)mark2  {
    XCUIElement *el1 = [self elementMarkedOrThrow:mark1];
    XCUIElement *el2 = [self elementMarkedOrThrow:mark2];
    [el1 pressForDuration:duration thenDragToElement:el2];
    return el1;
}

#pragma mark - Identifier Methods

+ (XCUIElement *)tapIdentifier:(NSString *)identifier {
    return [self gesture:@selector(tap) onIdentifier:identifier];
}

+ (XCUIElement *)doubleTapIdentifier:(NSString *)identifier {
    return [self gesture:@selector(doubleTap) onIdentifier:identifier];
}

+ (XCUIElement *)twoFingerTapIdentifier:(NSString *)identifier {
    return [self gesture:@selector(twoFingerTap) onIdentifier:identifier];
}

+ (XCUIElement *)swipeUpOnIdentifier:(NSString *)identifier {
    return [self gesture:@selector(swipeUp) onIdentifier:identifier];
}

+ (XCUIElement *)swipeDownOnIdentifier:(NSString *)identifier {
    return [self gesture:@selector(swipeDown) onIdentifier:identifier];
}

+ (XCUIElement *)swipeLeftOnIdentifier:(NSString *)identifier {
    return [self gesture:@selector(swipeLeft) onIdentifier:identifier];
}

+ (XCUIElement *)swipeRightOnIdentifier:(NSString *)identifier {
    return [self gesture:@selector(swipeRight) onIdentifier:identifier];
}

+ (XCUIElement *)typeText:(NSString *)text identifier:(NSString *)identifier {
    XCUIElement *el = [self elementWithIdentifierOrThrow:identifier];
    [el typeText:text];
    return el;
}

+ (XCUIElement *)rotateDegrees:(CGFloat)degrees velocity:(CGFloat)degreesPerSecond identifier:(NSString *)identifier {
    XCUIElement *el = [self elementWithIdentifierOrThrow:identifier];
    [el rotate:degreesToRadians(degrees) withVelocity:degreesToRadians(degreesPerSecond)];
    return el;
}

+ (XCUIElement *)pinchWithScale:(CGFloat)scaleMultiplier
                       velocity:(CGFloat)scaleFactorPerSecond
                     identifier:(NSString *)identifier {
    XCUIElement *el = [self elementWithIdentifierOrThrow:identifier];
    [el pinchWithScale:scaleMultiplier velocity:scaleFactorPerSecond];
    return el;
}

//TODO:
//I have no idea what the use case is for this.
+ (XCUIElement *)tapWithNumberOfTaps:(NSUInteger)numTaps
                     numberOfTouches:(NSUInteger)numTouches
                          identifier:(NSString *)identifier {
    XCUIElement *el = [self elementWithIdentifierOrThrow:identifier];
    [el tapWithNumberOfTaps:numTaps numberOfTouches:numTouches];
    return el;
}

+ (XCUIElement *)pressForDuration:(NSTimeInterval)duration identifier:(NSString *)identifier {
    XCUIElement *el = [self elementWithIdentifierOrThrow:identifier];
    [el pressForDuration:duration];
    return el;
}

+ (XCUIElement *)pressIdentifier:(NSString *)id1
                     forDuration:(NSTimeInterval)duration thenDragToElementWithIdentifier:(NSString *)id2  {
    XCUIElement *el1 = [self elementWithIdentifierOrThrow:id1];
    XCUIElement *el2 = [self elementWithIdentifierOrThrow:id2];
    [el1 pressForDuration:duration thenDragToElement:el2];
    return el1;
}

#pragma mark - Helper Methods

+ (XCUIElement *)elementWithIdentifierOrThrow:(NSString *)identifier {
    XCUIElement *el = [self elementWithIdentifier:identifier];
    if (!el) {
        @throw [CBElementNotFoundException withMessage:[NSString stringWithFormat:@"No element found for id: %@", identifier]];
    }
    [el resolve];
    return el;
}

+ (XCUIElement *)elementMarkedOrThrow:(NSString *)mark {
    XCUIElement *el = [self elementMarked:mark];
    if (!el) {
        @throw [CBElementNotFoundException withMessage:[NSString stringWithFormat:@"No element found with mark: %@", mark]];
    }
    [el resolve];
    return el;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

+ (void)performGesture:(_Nonnull SEL)gesture onElement:(XCUIElement *)el {
    [el performSelector:gesture withObject:nil];
    NSLog(@"Peforming %@ on %@", NSStringFromSelector(gesture), [JSONUtils elementToJSON:el]);
}

+ (XCUIElement *)gesture:(_Nonnull SEL)gesture matchingSelector:(_Nonnull SEL)match valueToMatch:(NSString *)value {
    XCUIElement *element = [self performSelector:match withObject:value];
    if (!element) {
        @throw [CBElementNotFoundException withMessage:[NSString stringWithFormat:@"No element found with value:%@", value]];
    }
    [self performGesture:gesture onElement:element];
    return element;
}
#pragma clang diagnostic pop

+ (XCUIElement *)gesture:(_Nonnull SEL)gesture onMarked:(NSString *)text {
    return [self gesture:gesture matchingSelector:@selector(elementMarked:) valueToMatch:text];
}

+ (XCUIElement *)gesture:(_Nonnull SEL)gesture onIdentifier:(NSString *)identifier {
    return [self gesture:gesture matchingSelector:@selector(elementWithIdentifier:) valueToMatch:identifier];
}
@end

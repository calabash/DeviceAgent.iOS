//
//  CBApplication+Gestures.h
//  xcuitest-server
//

#import <Foundation/Foundation.h>
#import "CBApplication.h"

@interface CBApplication (Gestures)

#pragma mark - Non specific API
+ (void)swipeUp;
+ (void)swipeDown;
+ (void)swipeLeft;
+ (void)swipeRight;

/*
    Coordinates
 */
#pragma mark - Coordinates API

+ (void)tap:(float)x :(float)y;
+ (void)doubleTap:(float)x :(float)y;
+ (void)press:(float)x :(float)y forDuration:(NSTimeInterval)duration;
+ (void)press:(float)x1 :(float)y1 forDuration:(NSTimeInterval)duration thenDragTo:(float)x2 :(float)y2;

/*
    Marked
 */
#pragma mark - Marked API

+ (XCUIElement *)tapMarked:(NSString *)mark;
+ (XCUIElement *)doubleTapMarked:(NSString *)mark;
+ (XCUIElement *)twoFingerTapMarked:(NSString *)mark;
+ (XCUIElement *)swipeUpOnMarked:(NSString *)mark;
+ (XCUIElement *)swipeDownOnMarked:(NSString *)mark;
+ (XCUIElement *)swipeLeftOnMarked:(NSString *)mark;
+ (XCUIElement *)swipeRightOnMarked:(NSString *)mark;

+ (XCUIElement *)typeText:(NSString *)text marked:(NSString *)mark;
+ (XCUIElement *)rotateDegrees:(CGFloat)degrees velocity:(CGFloat)degreesPerSecond marked:(NSString *)mark;
+ (XCUIElement *)pinchWithScale:(CGFloat)scaleMultiplier
              velocity:(CGFloat)scaleFactorPerSecond
                marked:(NSString *)mark;
+ (XCUIElement *)tapWithNumberOfTaps:(NSUInteger)numTaps
            numberOfTouches:(NSUInteger)numTouches
                     marked:(NSString *)mark;
+ (XCUIElement *)pressForDuration:(NSTimeInterval)duration marked:(NSString *)mark;
+ (XCUIElement *)pressMarked:(NSString *)mark1
        forDuration:(NSTimeInterval)duration thenDragToElementMarked:(NSString *)mark2;

/*
    Identifier
 */
#pragma mark - Identifier API

+ (XCUIElement *)tapIdentifier:(NSString *)identifier;
+ (XCUIElement *)doubleTapIdentifier:(NSString *)identifier;
+ (XCUIElement *)twoFingerTapIdentifier:(NSString *)identifier;
+ (XCUIElement *)swipeUpOnIdentifier:(NSString *)identifier;
+ (XCUIElement *)swipeDownOnIdentifier:(NSString *)identifier;
+ (XCUIElement *)swipeLeftOnIdentifier:(NSString *)identifier;
+ (XCUIElement *)swipeRightOnIdentifier:(NSString *)identifier;

+ (XCUIElement *)typeText:(NSString *)text identifier:(NSString *)identifier;
+ (XCUIElement *)rotateDegrees:(CGFloat)degrees velocity:(CGFloat)degreesPerSecond identifier:(NSString *)identifier;
+ (XCUIElement *)pinchWithScale:(CGFloat)scaleMultiplier
              velocity:(CGFloat)scaleFactorPerSecond
            identifier:(NSString *)identifier;
+ (XCUIElement *)tapWithNumberOfTaps:(NSUInteger)numTaps
            numberOfTouches:(NSUInteger)numTouches
                 identifier:(NSString *)identifier;
+ (XCUIElement *)pressForDuration:(NSTimeInterval)duration identifier:(NSString *)identifier;
+ (XCUIElement *)pressIdentifier:(NSString *)id1
            forDuration:(NSTimeInterval)duration thenDragToElementWithIdentifier:(NSString *)id2;




@end

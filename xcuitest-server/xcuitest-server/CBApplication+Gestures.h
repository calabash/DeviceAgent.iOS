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

+ (BOOL)tapMarked:(NSString *)mark;
+ (BOOL)doubleTapMarked:(NSString *)mark;
+ (BOOL)twoFingerTapMarked:(NSString *)mark;
+ (BOOL)swipeUpOnMarked:(NSString *)mark;
+ (BOOL)swipeDownOnMarked:(NSString *)mark;
+ (BOOL)swipeLeftOnMarked:(NSString *)mark;
+ (BOOL)swipeRightOnMarked:(NSString *)mark;

+ (BOOL)typeText:(NSString *)text marked:(NSString *)mark;
+ (BOOL)rotateDegrees:(CGFloat)degrees velocity:(CGFloat)degreesPerSecond marked:(NSString *)mark;
+ (BOOL)pinchWithScale:(CGFloat)scaleMultiplier
              velocity:(CGFloat)scaleFactorPerSecond
                marked:(NSString *)mark;
+ (BOOL)tapWithNumberOfTaps:(NSUInteger)numTaps
            numberOfTouches:(NSUInteger)numTouches
                     marked:(NSString *)mark;
+ (BOOL)pressForDuration:(NSTimeInterval)duration marked:(NSString *)mark;
+ (BOOL)pressMarked:(NSString *)mark1
        forDuration:(NSTimeInterval)duration thenDragToElementMarked:(NSString *)mark2;

/*
    Identifier
 */
#pragma mark - Identifier API

+ (BOOL)tapIdentifier:(NSString *)identifier;
+ (BOOL)doubleTapIdentifier:(NSString *)identifier;
+ (BOOL)twoFingerTapIdentifier:(NSString *)identifier;
+ (BOOL)swipeUpOnIdentifier:(NSString *)identifier;
+ (BOOL)swipeDownOnIdentifier:(NSString *)identifier;
+ (BOOL)swipeLeftOnIdentifier:(NSString *)identifier;
+ (BOOL)swipeRightOnIdentifier:(NSString *)identifier;

+ (BOOL)typeText:(NSString *)text identifier:(NSString *)identifier;
+ (BOOL)rotateDegrees:(CGFloat)degrees velocity:(CGFloat)degreesPerSecond identifier:(NSString *)identifier;
+ (BOOL)pinchWithScale:(CGFloat)scaleMultiplier
              velocity:(CGFloat)scaleFactorPerSecond
            identifier:(NSString *)identifier;
+ (BOOL)tapWithNumberOfTaps:(NSUInteger)numTaps
            numberOfTouches:(NSUInteger)numTouches
                 identifier:(NSString *)identifier;
+ (BOOL)pressForDuration:(NSTimeInterval)duration identifier:(NSString *)identifier;
+ (BOOL)pressIdentifier:(NSString *)id1
            forDuration:(NSTimeInterval)duration thenDragToElementWithIdentifier:(NSString *)id2;




@end

//
//  CBApplication+Gestures.h
//  xcuitest-server
//

#import <Foundation/Foundation.h>
#import "CBApplication.h"

@interface CBApplication (Gestures)

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

+ (BOOL)tapMarked:(NSString *)text;
+ (BOOL)doubleTapMarked:(NSString *)text;
+ (BOOL)twoFingerTapMarked:(NSString *)text;
+ (BOOL)swipeUpOnMarked:(NSString *)text;
+ (BOOL)swipeDownOnMarked:(NSString *)text;
+ (BOOL)swipeLeftOnMarked:(NSString *)text;
+ (BOOL)swipeRightOnMarked:(NSString *)text;

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

@end

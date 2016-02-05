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
+ (void)tap:(float)x :(float)y;
+ (void)doubleTap:(float)x :(float)y;
+ (void)press:(float)x :(float)y forDuration:(NSTimeInterval)duration;
+ (void)press:(float)x1 :(float)y1 forDuration:(NSTimeInterval)duration thenDragTo:(float)x2 :(float)y2;

/*
    Marked
 */

+ (BOOL)tapMarked:(NSString *)text;
+ (BOOL)doubleTapMarked:(NSString *)text;
+ (BOOL)twoFingerTapMarked:(NSString *)text;
+ (BOOL)swipeUpOnMarked:(NSString *)text;
+ (BOOL)swipeDownOnMarked:(NSString *)text;
+ (BOOL)swipeLeftOnMarked:(NSString *)text;
+ (BOOL)swipeRightOnMarked:(NSString *)text;


@end

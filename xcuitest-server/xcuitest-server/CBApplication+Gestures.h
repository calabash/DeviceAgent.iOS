//
//  CBApplication+Gestures.h
//  xcuitest-server
//

#import <Foundation/Foundation.h>
#import "CBApplication.h"

@interface CBApplication (Gestures)
+ (void)tap:(float)x :(float)y;
+ (void)doubleTap:(float)x :(float)y;
+ (void)press:(float)x :(float)y forDuration:(NSTimeInterval)duration;
+ (void)press:(float)x1 :(float)y1 forDuration:(NSTimeInterval)duration thenDragTo:(float)x2 :(float)y2;
@end

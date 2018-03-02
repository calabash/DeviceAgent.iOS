
#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIApplication.h>

@class XCPointerEventPath;

/**
 Wrapper class for `XCTouchPath` and `XCPointerEventPath` which
 share 90% of their interface but are used for different protocol versions of
 testmanagerd.
 */
@interface TouchPath : NSObject
@property (nonatomic, readonly) UIInterfaceOrientation orientation;

/**
 Static initializer. Note that the event **does not** perform any actual touches
 until it is sent to testmanagerd.

 @param firstTouchPoint The first point on the screen you'd like to touch.
 @param orientation This is an undocumented parameter in the XCTest API, but
   presumably is a map from number to device orientations.
 @return A new TouchPath instance.
 */
+ (instancetype)withFirstTouchPoint:(CGPoint)firstTouchPoint
                        orientation:(UIInterfaceOrientation)orientation;

/**
 Static initializer. Note that the event **does not** perform any actual touches
 until it is sent to testmanagerd.

 @param firstTouchPoint The first point on the screen you'd like to touch.
 @param orientation This is an undocumented parameter in the XCTest API, but
   presumably is a map from number to device orientations.
 @param seconds The number of seconds, from now, when the gesture should be
   performed.
 @return A new TouchPath instance.
 */
+ (instancetype)withFirstTouchPoint:(CGPoint)firstTouchPoint
                        orientation:(UIInterfaceOrientation)orientation
                             offset:(float)seconds;

/**
 Define the next point for the touch path.
 @param nextPoint The next point to which to move.
 @param seconds Time (in seconds) after which to perform the move. May use decimals.
 */
- (void)moveToNextPoint:(CGPoint)nextPoint afterSeconds:(CGFloat)seconds;

/**
 Effectively ends the current gesture.

 Note: It is not clear whether it is valid to perform `moveToNextPoint:afterSeconds:`
 after performing `liftUpAfterSeconds:`. The behavior is currently considered
 undefined.

 @param seconds Time (in seconds) after which to lift up the touch at the last
   recorded point.
 */
- (void)liftUpAfterSeconds:(CGFloat)seconds;

/**
 Interface to unwrap the underlying XCPointerEventPath object
 @return The XCPointerEventPath created as a result of the touch points added
 */
- (XCPointerEventPath *)eventPath;

@end

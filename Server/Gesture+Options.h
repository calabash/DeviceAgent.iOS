
#import "Gesture.h"

/**
Extension to Gesture with convenience methods for attempting to get a value or, if
 that value is not present in the Gesture's GestureConfiguration, using a default
 value provided by CBXConstants.h
 
 Note that not all of these are valid options for a given gesture, but the semantics
 should be self-correcting. E.g. `two_finger_tap` should never call `radius` because
 it's nonsensical.
 */

@interface Gesture (Options)

/**
 Number of times a gesture should repeat
 @return `self.gestureConfiguration[CBX_REPETITIONS_KEY] || CBX_DEFAULT_REPETITIONS`
 */
- (int)repetitions;

/**
 Number of fingers to use on a gesture
 @return `self.gestureConfiguration[CBX_NUM_FINGERS_KEY] || CBX_DEFAULT_NUM_FINGERS`
 */
- (int)numFingers;

/**
 Duration of a gesture in seconds
 @return `self.gestureConfiguration[CBX_DURATION_KEY] || CBX_DEFAULT_DURATION`
 */
- (float)duration;

/**
 Duration of a rotation gesture specifically. Separate from `duration` because
 the default is different. 
 
 @return `self.gestureConfiguration[CBX_DURATION_KEY] || CBX_DEFAULT_ROTATE_DURATION`
 */
- (float)rotateDuration;

/**
 Amount (in UI 'points') to pinch
 
 @return `self.gestureConfiguration[CBX_PINCH_AMOUNT_KEY] || CBX_DEFAULT_PINCH_AMOUNT`
 */
- (float)pinchAmount;

/**
 Number of degrees to rotate during a rotation gesture.
 
 @return `self.gestureConfiguration[CBX_DEGREES_KEY] || CBX_DEFAULT_DEGREES`
 */
- (float)degrees;

/**
 Position in degrees ( 0º is 3:00 ) from which to start a rotation
 
 @return `self.gestureConfiguration[CBX_ROTATION_START_KEY] || CBX_DEFAULT_ROTATION_START`
 */
- (float)rotationStart;

/**
 Radius (in UI 'points') of the guiding circle during a rotation
 
 @return `self.gestureConfiguration[CBX_RADIUS_KEY] || CBX_DEFAULT_RADIUS`
 */
- (float)radius;

/**
 Direction in which to pinch ("in" or "out")
 
 @return `self.gestureConfiguration[CBX_PINCH_DIRECTION_KEY] || CBX_DEFAULT_PINCH_DIRECTION`
 */
- (NSString *)pinchDirection;


/**
 Direction in which to rotate ("clockwise" or "counterclockwise")
 
 @return `self.gestureConfiguration[CBX_ROTATION_DIRECTION_KEY] || CBX_DEFAULT_ROTATION_DIRECTION`
 */
- (NSString *)rotateDirection;
@end

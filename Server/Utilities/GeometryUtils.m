
#import "InvalidArgumentException.h"
#import "GeometryUtils.h"
#import "CBXConstants.h"

@implementation GeometryUtils

/*
 #############
 #     x     # => one finger
 #           #
 #     x  x  # => two fingers
 #           #
 #  x  x  x  # => three fingers
 #           #
 #  x  x  x x# => four fingers - fourth finger is either 2-finger widths to the
 #           #                   left of the first finger or at the screen edge
 #x x  x  x x# => five fingers - as above but to the right of first finger
 #           #
 #############
 */
+ (CGPoint)fingerOffsetForFingerIndex:(int)index {
    index = index % CBX_MAX_NUM_FINGERS;
    switch (index) {
        case 0: { return CGPointZero; }
        case 1: { return CGPointMake(CBX_FINGER_WIDTH, 0); }
        case 2: { return CGPointMake(-CBX_FINGER_WIDTH, 0); }
        case 3: { return CGPointMake(2 * CBX_FINGER_WIDTH, 0); }
        case 4: { return CGPointMake(2 * -CBX_FINGER_WIDTH, 0); }
        default:
            @throw [InvalidArgumentException withMessage:@"Invalid finger index"
                                                userInfo:@{@"max finger index" : @(CBX_MAX_NUM_FINGERS - 1)}];
            break;
    }
}

@end

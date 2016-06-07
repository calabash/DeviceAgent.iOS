
#import "InvalidArgumentException.h"
#import "GeometryUtils.h"
#import "CBXConstants.h"

@implementation GeometryUtils
+ (CGPoint)fingerOffsetForFingerIndex:(int)index {
    index = index % CBX_MAX_NUM_FINGERS;
    switch (index) {
        case 0:
            return CGPointZero;
        case 1:
            return CGPointMake(CBX_FINGER_WIDTH_DRAG, 0);
        case 2:
            return CGPointMake(0, CBX_FINGER_WIDTH_DRAG);
        case 3:
            return CGPointMake(-CBX_FINGER_WIDTH_DRAG, 0);
        case 4:
            return CGPointMake(0, -CBX_FINGER_WIDTH_DRAG);
        default:
            @throw [InvalidArgumentException withMessage:@"Invalid finger index"
                                                userInfo:@{@"max finger index" : @(CBX_MAX_NUM_FINGERS - 1)}];
            break;
    }
}

@end

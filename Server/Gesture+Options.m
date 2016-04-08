
#import "Gesture+Options.h"

@implementation Gesture (Options)
- (float)duration {
    return self.gestureConfiguration[CBX_DURATION_KEY] ?
    [self.gestureConfiguration[CBX_DURATION_KEY] floatValue] :
    CBX_DEFAULT_DURATION;
}

- (float)amount {
    return self.gestureConfiguration[CBX_AMOUNT_KEY] ?
    [self.gestureConfiguration[CBX_AMOUNT_KEY] floatValue] :
    CBX_DEFAULT_PINCH_AMOUNT;
}

- (int)repititions {
    return self.gestureConfiguration[CBX_REPITITIONS_KEY] ?
    [self.gestureConfiguration[CBX_REPITITIONS_KEY] intValue] :
    1;
}

- (NSString *)direction {
    return self.gestureConfiguration[CBX_PINCH_DIRECTION_KEY] ?
    self.gestureConfiguration[CBX_PINCH_DIRECTION_KEY] :
    CBX_DEFAULT_PINCH_DIRECTION;
}

@end

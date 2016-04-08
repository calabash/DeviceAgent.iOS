
#import "Gesture+Options.h"

@implementation Gesture (Options)
- (float)duration {
    return self.gestureConfiguration[CB_DURATION_KEY] ?
    [self.gestureConfiguration[CB_DURATION_KEY] floatValue] :
    CB_DEFAULT_DURATION;
}

- (float)amount {
    return self.gestureConfiguration[CB_AMOUNT_KEY] ?
    [self.gestureConfiguration[CB_AMOUNT_KEY] floatValue] :
    CB_DEFAULT_PINCH_AMOUNT;
}

- (int)repititions {
    return self.gestureConfiguration[CB_REPITITIONS_KEY] ?
    [self.gestureConfiguration[CB_REPITITIONS_KEY] intValue] :
    1;
}

- (NSString *)direction {
    return self.gestureConfiguration[CB_PINCH_DIRECTION_KEY] ?
    self.gestureConfiguration[CB_PINCH_DIRECTION_KEY] :
    CB_DEFAULT_PINCH_DIRECTION;
}

@end

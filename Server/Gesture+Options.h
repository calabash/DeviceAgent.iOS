
#import "Gesture.h"

@interface Gesture (Options)

- (int)repetitions;

- (float)duration;
- (float)rotateDuration;
- (float)amount;
- (float)degrees;
- (float)rotationStart;
- (float)radius;

- (NSString *)direction;
- (NSString *)rotateDirection;
@end


#import "Gesture.h"

@interface Gesture (Options)

- (int)repetitions;
- (int)numFingers;

- (float)duration;
- (float)rotateDuration;
- (float)amount;
- (float)degrees;
- (float)rotationStart;
- (float)radius;

- (NSString *)direction;
- (NSString *)rotateDirection;
@end

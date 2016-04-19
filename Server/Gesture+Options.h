
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

- (NSString *)pinchDirection;
- (NSString *)rotateDirection;
@end

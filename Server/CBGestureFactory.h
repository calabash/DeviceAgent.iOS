
#import <Foundation/Foundation.h>
#import "Gesture.h"

@interface CBGestureFactory : NSObject
+ (Gesture *)executeGestureWithJSON:(NSDictionary *)json completion:(CompletionBlock)completion;
@end

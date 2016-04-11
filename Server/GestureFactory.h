
#import <Foundation/Foundation.h>
#import "Gesture.h"

@interface GestureFactory : NSObject
+ (Gesture *)executeGestureWithJSON:(NSDictionary *)json completion:(CompletionBlock)completion;
@end

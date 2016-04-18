
#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface Coordinate : NSObject
- (CGPoint)cgpoint;
+ (instancetype)fromRaw:(CGPoint)raw;
+ (instancetype)withJSON:(id)json; //throws an exception for invalid JSON
@end


#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "XCSynthesizedEventRecord.h"
#import "XCTouchGesture.h"
#import "TouchPath.h"

@interface CBXTouchEvent : NSObject
+ (instancetype)withTouchPath:(TouchPath *)path;
- (void)addTouchPath:(TouchPath *)path;

- (XCTouchGesture *)gesture;
- (XCSynthesizedEventRecord *)event;
@end

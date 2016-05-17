
#import "CBXTouchEvent.h"
@interface CBXTouchEvent ()
@property (nonatomic, strong) XCSynthesizedEventRecord *event;
@property (nonatomic, strong) XCTouchGesture *gesture;
@end

@implementation CBXTouchEvent
+ (instancetype)withTouchPath:(TouchPath *)path {
    //TODO
    return nil;
}

- (void)addTouchPath:(TouchPath *)path {
    //TODO
}

@end

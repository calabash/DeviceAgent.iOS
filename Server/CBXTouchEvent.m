
#import "CBXTouchEvent.h"
@interface CBXTouchEvent ()
@property (nonatomic, strong) XCSynthesizedEventRecord *event;
@property (nonatomic, strong) XCTouchGesture *gesture;
@property (nonatomic) NSInteger orientation;
@end

@implementation CBXTouchEvent
+ (instancetype)withTouchPath:(TouchPath *)path {
    CBXTouchEvent *te = [self new];
    te.orientation = path.orientation;
    te.event = [[XCSynthesizedEventRecord alloc] initWithName:@"CBXTouchEvent_XCSynthesizedEventRecord"
                                         interfaceOrientation:te.orientation];
    [te.event addPointerEventPath:path.eventPath];
    
    te.gesture = [[XCTouchGesture alloc] initWithName:@"CBXTouchEvent_XCTouchGesture"];
    [te.gesture addTouchPath:path.xcTouchPath];
    
    return te;
}

- (void)addTouchPath:(TouchPath *)path {
    NSAssert(path.orientation == self.orientation,
             @"Can not add a TouchPath with a different orientation within the same CBXTouchEvent");
    [self.event addPointerEventPath:path.eventPath];
    [self.gesture addTouchPath:path.xcTouchPath];
}

@end

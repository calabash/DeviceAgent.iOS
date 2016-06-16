
#import "CBXTouchEvent.h"

@interface CBXTouchEvent ()

@property (nonatomic, strong) XCSynthesizedEventRecord *event;
@property (nonatomic, strong) XCTouchGesture *gesture;
@property (nonatomic) UIInterfaceOrientation orientation;

+ (XCSynthesizedEventRecord *)eventRecordWithOrientation:(NSInteger) orientation;
+ (XCTouchGesture *)touchGesture;

@end

@implementation CBXTouchEvent

+ (instancetype)withTouchPath:(TouchPath *)path {
    CBXTouchEvent *te = [self new];
    te.orientation = path.orientation;
    te.event = [CBXTouchEvent eventRecordWithOrientation:te.orientation];
    [te.event addPointerEventPath:path.eventPath];
    
    te.gesture = [CBXTouchEvent touchGesture];
    [te.gesture addTouchPath:path.xcTouchPath];
    
    return te;
}

- (void)addTouchPath:(TouchPath *)path {
    NSAssert(path.orientation == self.orientation,
             @"Can not add a TouchPath with a different orientation within the same CBXTouchEvent");
    [self.event addPointerEventPath:path.eventPath];
    [self.gesture addTouchPath:path.xcTouchPath];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"#<%@ orientation: %@\ngesture: %@\nevent: %@",
            NSStringFromClass([CBXTouchEvent class]),
            @(self.orientation),
            self.gesture,
            self.event];
}

+ (XCSynthesizedEventRecord *)eventRecordWithOrientation:(NSInteger) orientation {
    return [[XCSynthesizedEventRecord alloc]
            initWithName:@"CBXTouchEvent_XCSynthesizedEventRecord"
            interfaceOrientation:orientation];
}

+ (XCTouchGesture *)touchGesture {
    return [[XCTouchGesture alloc] initWithName:@"CBXTouchEvent_XCTouchGesture"];
}

@end

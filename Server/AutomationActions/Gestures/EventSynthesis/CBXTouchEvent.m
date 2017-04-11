
#import "CBXTouchEvent.h"

@interface CBXTouchEvent ()

@property (nonatomic, strong) XCSynthesizedEventRecord *event;
//@property (nonatomic, strong) XCTouchGesture *gesture;
@property (nonatomic) UIInterfaceOrientation orientation;

+ (XCSynthesizedEventRecord *)eventRecordWithOrientation:(UIInterfaceOrientation)orientation;

@end

@implementation CBXTouchEvent

- (id)init {
    if (self = [super init]) {
        _orientation = -1;
    }
    return self;
}

+ (instancetype)withTouchPath:(TouchPath *)path {
    CBXTouchEvent *te = [self new];
    te.orientation = path.orientation;
    te.event = [CBXTouchEvent eventRecordWithOrientation:te.orientation];
    [te.event addPointerEventPath:path.eventPath];
    
    return te;
}

- (void)addTouchPath:(TouchPath *)path {
    //If orientation is set, it will be >= 0
    if (self.orientation >= 0) {
        NSAssert(path.orientation == self.orientation,
             @"Can not add a TouchPath with a different orientation within the same CBXTouchEvent");
    } else {
        self.orientation = path.orientation;
    }
    self.event = self.event ?: [CBXTouchEvent eventRecordWithOrientation:self.orientation];
    [self.event addPointerEventPath:path.eventPath];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"#<%@ orientation: %@\ngesture: %@",
            NSStringFromClass([CBXTouchEvent class]),
            @(self.orientation),
            self.event];
}

+ (XCSynthesizedEventRecord *)eventRecordWithOrientation:(UIInterfaceOrientation)orientation {
    return [[XCSynthesizedEventRecord alloc]
            initWithName:@"CBXTouchEvent_XCSynthesizedEventRecord"
            interfaceOrientation:orientation];
}

@end

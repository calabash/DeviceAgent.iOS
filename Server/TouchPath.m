
#import "TouchPath.h"

@interface TouchPath ()
@property (nonatomic, strong) XCTouchPath *xcTouchPath;
@property (nonatomic, strong) XCPointerEventPath *eventPath;
@property (nonatomic) CGPoint lastPoint;
@end

@implementation TouchPath

- (instancetype)initWithOrientation:(NSInteger)orientation {
    if (self = [super init]) {
        _orientation = orientation;
    }
    return self;
}


+ (instancetype)withFirstTouchPoint:(CGPoint)firstTouchPoint orientation:(NSInteger)orientation {
    TouchPath *tp = [[TouchPath alloc] initWithOrientation:orientation];
    
    tp.lastPoint = firstTouchPoint;
    
    tp.xcTouchPath = [[XCTouchPath alloc] initWithTouchDown:firstTouchPoint
                                                orientation:orientation
                                                     offset:0];
    
    tp.eventPath = [[XCPointerEventPath alloc] initForTouchAtPoint:firstTouchPoint
                                                            offset:0];
    return tp;
}

- (void)moveToNextPoint:(CGPoint)nextPoint afterSeconds:(CGFloat)seconds {
    [self.xcTouchPath moveToPoint:nextPoint atOffset:seconds];
    [self.eventPath moveToPoint:nextPoint atOffset:seconds];
    self.lastPoint = nextPoint;
}

- (void)liftUpAfterSeconds:(CGFloat)seconds {
    [self.xcTouchPath liftUpAtPoint:_lastPoint offset:seconds];
    [self.eventPath liftUpAtOffset:seconds];
}

@end

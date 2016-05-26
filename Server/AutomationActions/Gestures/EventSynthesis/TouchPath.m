
#import "TouchPath.h"

@interface TouchPath ()
@property (nonatomic, strong) XCTouchPath *xcTouchPath;
@property (nonatomic, strong) XCPointerEventPath *eventPath;
@property (nonatomic) CGPoint lastPoint;

+ (XCTouchPath *)touchPathForFirstTouchPoint:(CGPoint)point
                                 orientation:(NSInteger)orientation
                                      offset:(float)offset;
+ (XCPointerEventPath *)eventPathForFirstTouchPoint:(CGPoint)point
                                             offset:(float)offset;

@end

@implementation TouchPath

- (instancetype)initWithOrientation:(NSInteger)orientation {
    if (self = [super init]) {
        _orientation = orientation;
    }
    return self;
}

+ (instancetype)withFirstTouchPoint:(CGPoint)firstTouchPoint
                        orientation:(NSInteger)orientation
                             offset:(float)seconds {
    TouchPath *tp = [[TouchPath alloc] initWithOrientation:orientation];
    
    tp.lastPoint = firstTouchPoint;
    
    tp.xcTouchPath = [TouchPath touchPathForFirstTouchPoint:firstTouchPoint
                                                orientation:orientation
                                                     offset:seconds];

    tp.eventPath = [TouchPath eventPathForFirstTouchPoint:firstTouchPoint
                                                   offset:seconds];
    return tp;
}

- (void)moveToNextPoint:(CGPoint)nextPoint afterSeconds:(CGFloat)seconds {
    NSAssert((self.xcTouchPath && self.eventPath),
             @"Expected xcTouchPath and eventPath to be non-nil");
    [self.xcTouchPath moveToPoint:nextPoint atOffset:seconds];
    [self.eventPath moveToPoint:nextPoint atOffset:seconds];
    self.lastPoint = nextPoint;
}

- (void)liftUpAfterSeconds:(CGFloat)seconds {
    NSAssert((self.xcTouchPath && self.eventPath),
             @"Expected xcTouchPath and eventPath to be non-nil");
    // No good way to assert that lastPoint has been set; it will default to
    // CGPointZero if not assigned.
    [self.xcTouchPath liftUpAtPoint:self.lastPoint offset:seconds];
    [self.eventPath liftUpAtOffset:seconds];
}

+ (XCTouchPath *)touchPathForFirstTouchPoint:(CGPoint)point
                                 orientation:(NSInteger)orientation
                                     offset:(float)seconds {
    return [[XCTouchPath alloc] initWithTouchDown:point
                                      orientation:orientation
                                           offset:seconds];
}

+ (XCPointerEventPath *)eventPathForFirstTouchPoint:(CGPoint)point
                                            offset:(float)seconds {
    return [[XCPointerEventPath alloc] initForTouchAtPoint:point
                                                    offset:seconds];
}

@end

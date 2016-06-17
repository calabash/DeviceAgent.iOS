
#import "TouchPath.h"

@interface TouchPath ()
@property (nonatomic, strong) XCTouchPath *xcTouchPath;
@property (nonatomic, strong) XCPointerEventPath *eventPath;
@property (nonatomic) CGPoint lastPoint;

- (instancetype)initWithFirstTouchPoint:(CGPoint)firstTouchPoint
                            orientation:(UIInterfaceOrientation)orientation
                                 offset:(float)seconds;

+ (XCTouchPath *)touchPathForFirstTouchPoint:(CGPoint)point
                                 orientation:(UIInterfaceOrientation)orientation
                                      offset:(float)offset;

+ (XCPointerEventPath *)eventPathForFirstTouchPoint:(CGPoint)point
                                             offset:(float)offset;

@end

@implementation TouchPath

// private
- (instancetype)initWithFirstTouchPoint:(CGPoint)firstTouchPoint
                            orientation:(UIInterfaceOrientation)orientation
                                 offset:(float)seconds {
    self = [super init];
    if (self) {
        _orientation = orientation;
        _lastPoint = firstTouchPoint;

        _xcTouchPath = [TouchPath touchPathForFirstTouchPoint:firstTouchPoint
                                                  orientation:orientation
                                                       offset:seconds];

        _eventPath = [TouchPath eventPathForFirstTouchPoint:firstTouchPoint
                                                     offset:seconds];
    }

    return self;
}

// public
+ (instancetype)withFirstTouchPoint:(CGPoint)firstTouchPoint
                        orientation:(UIInterfaceOrientation)orientation {
    return [[TouchPath alloc] initWithFirstTouchPoint:firstTouchPoint
                                          orientation:orientation
                                               offset:0.0];
}

// public
+ (instancetype)withFirstTouchPoint:(CGPoint)firstTouchPoint
                        orientation:(UIInterfaceOrientation)orientation
                             offset:(float)seconds {
    return [[TouchPath alloc] initWithFirstTouchPoint:firstTouchPoint
                                          orientation:orientation
                                               offset:seconds];
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
                                 orientation:(UIInterfaceOrientation)orientation
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


#import "TouchPath.h"
#import "XCPointerEventPath.h"

@interface TouchPath ()
@property (nonatomic, strong) XCPointerEventPath *eventPath;
@property (nonatomic) CGPoint lastPoint;

- (instancetype)initWithFirstTouchPoint:(CGPoint)firstTouchPoint
                            orientation:(UIInterfaceOrientation)orientation
                                 offset:(float)seconds;

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
    NSAssert((self.eventPath),
             @"Expected xcTouchPath and eventPath to be non-nil");
    [self.eventPath moveToPoint:nextPoint atOffset:seconds];
    self.lastPoint = nextPoint;
}

- (void)liftUpAfterSeconds:(CGFloat)seconds {
    NSAssert((self.eventPath),
             @"Expected xcTouchPath and eventPath to be non-nil");
    // No good way to assert that lastPoint has been set; it will default to
    // CGPointZero if not assigned.
    [self.eventPath liftUpAtOffset:seconds];
}

+ (XCPointerEventPath *)eventPathForFirstTouchPoint:(CGPoint)point
                                             offset:(float)seconds {
    return [[XCPointerEventPath alloc] initForTouchAtPoint:point
                                                    offset:seconds];
}

@end

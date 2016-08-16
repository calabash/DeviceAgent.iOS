
// required if we import XCPointerEvent
#ifndef CDUnknownBlockType
typedef void (^CDUnknownBlockType)(void);
#endif

#import <XCTest/XCTest.h>
#import "TouchPath.h"
#import "XCPointerEventPath.h"
#import "XCPointerEvent.h"

@interface TouchPath ()

- (XCPointerEventPath *)eventPath;
- (CGPoint) lastPoint;

- (instancetype)initWithFirstTouchPoint:(CGPoint)firstTouchPoint
                            orientation:(long long)orientation
                                 offset:(float)seconds;
+ (XCPointerEventPath *)eventPathForFirstTouchPoint:(CGPoint)point
                                             offset:(float)seconds;

@end

@interface TouchPathTests : XCTestCase

@end

@implementation TouchPathTests

- (void)expectTouchPath:(TouchPath *)touchPath
              withPoint:(CGPoint)point
            orientation:(long long)orientation
                 offset:(float)seconds {
    expect(touchPath.orientation).to.equal(orientation);
    expect(touchPath.lastPoint).to.equal(point);
    expect(touchPath.eventPath).to.beAKindOf([XCPointerEventPath class]);

    XCPointerEventPath *eventPath = touchPath.eventPath;
    expect(eventPath.pointerEvents.count).to.equal(1);
    expect([eventPath.pointerEvents[0] coordinate]).to.equal(point);
    expect([eventPath.pointerEvents[0] offset]).to.equal(seconds);
}

- (void)testInitWithFirstTouchPointOrientationAndOffset {
    CGPoint point = CGPointMake(44, 64);
    UIInterfaceOrientation orientation = 1;
    float seconds = 15.0;

    TouchPath *touchPath = [[TouchPath alloc]
                            initWithFirstTouchPoint:point
                            orientation:orientation
                            offset:seconds];

    [self expectTouchPath:touchPath
                withPoint:point
              orientation:orientation
                   offset:seconds];
}

- (void)testWithFirstTouchPointOrientation {
    CGPoint point = CGPointMake(30, 90);
    UIInterfaceOrientation orientation = 1;
    float seconds = 0.0;

    TouchPath *touchPath = [TouchPath withFirstTouchPoint:point
                                              orientation:orientation];

    [self expectTouchPath:touchPath
                withPoint:point
              orientation:orientation
                   offset:seconds];
}

- (void)testWithFirstTouchPointOrientationOffset {
    CGPoint point = CGPointMake(30, 90);
    UIInterfaceOrientation orientation = 1;
    float seconds = 15.0;

    TouchPath *touchPath = [TouchPath withFirstTouchPoint:point
                                              orientation:orientation
                                                   offset:seconds];

    [self expectTouchPath:touchPath
                withPoint:point
              orientation:orientation
                   offset:seconds];
}

- (void)testMoveToNextPointTouchAndEventPathNotDefined {
    TouchPath *tp = [TouchPath new];
    expect(^{
        [tp moveToNextPoint:CGPointZero afterSeconds:0];
    }).to.raise(@"NSInternalInconsistencyException");
}

- (void)testMoveToNextPointAfterSeconds {
    CGPoint firstPoint = CGPointMake(44, 64);
    CGPoint nextPoint = CGPointMake(64, 44);
    UIInterfaceOrientation orientation = 1;
    CGFloat seconds = 20;

    TouchPath *tp = [TouchPath withFirstTouchPoint:firstPoint
                                       orientation:orientation
                                            offset:0.0];


    id eventPath = OCMPartialMock(tp.eventPath);
    OCMExpect([eventPath moveToPoint:nextPoint
                            atOffset:seconds]).andForwardToRealObject();

    [tp moveToNextPoint:nextPoint afterSeconds:seconds];
    expect(tp.lastPoint).to.equal(nextPoint);

    XCPointerEventPath *ep = tp.eventPath;
    expect(ep.pointerEvents.count).to.equal(2);
    expect([ep.pointerEvents[1] coordinate]).to.equal(nextPoint);
    
    OCMVerifyAll(eventPath);
}

- (void)testLiftUpAfterSecondsTouchAndEventPathNotDefined {
    TouchPath *tp = [TouchPath new];
    expect(^{
        [tp liftUpAfterSeconds:20];
    }).to.raise(@"NSInternalInconsistencyException");
}

- (void)testLiftUpAfterSeconds{
    CGPoint point = CGPointMake(44, 64);
    CGFloat seconds = 20;

    TouchPath *tp = [TouchPath withFirstTouchPoint:point
                                       orientation:0
                                            offset:0.0];

    id eventPath = OCMPartialMock(tp.eventPath);
    OCMExpect([eventPath liftUpAtOffset:seconds]).andForwardToRealObject();

    [tp liftUpAfterSeconds:seconds];

    OCMVerifyAll(eventPath);
}

@end

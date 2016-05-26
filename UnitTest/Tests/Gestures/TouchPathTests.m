
// required if we import XCPointerEvent
#ifndef CDUnknownBlockType
typedef void (^CDUnknownBlockType)(void);
#endif

#import <XCTest/XCTest.h>
#import "TouchPath.h"
#import "XCTouchPath.h"
#import "XCTouchEvent.h"
#import "XCPointerEventPath.h"
#import "XCPointerEvent.h"

@interface TouchPath ()

- (XCTouchPath *)xcTouchPath;
- (XCPointerEventPath *)eventPath;
- (CGPoint) lastPoint;
- (instancetype)initWithOrientation:(NSInteger)orientation;
+ (XCTouchPath *)touchPathForFirstTouchPoint:(CGPoint)point
                                 orientation:(NSInteger)orientation
                                      offset:(float)seconds;
+ (XCPointerEventPath *)eventPathForFirstTouchPoint:(CGPoint)point
                                             offset:(float)seconds;

@end

@interface TouchPathTests : XCTestCase

@end

@implementation TouchPathTests

- (void)testInitWithOrientation {
    TouchPath *tp = [[TouchPath alloc] initWithOrientation:1];
    expect(tp).notTo.equal(nil);
    expect(tp.orientation).to.equal(1);
}

- (void)testWithFirstTouchPoint {
    CGPoint point = CGPointMake(44, 64);
    NSInteger orientation = 1;
    float seconds = 0.0;

    TouchPath *inner = [TouchPath new];

    id classMock = OCMClassMock([TouchPath class]);
    OCMStub([classMock initWithOrientation:orientation]).andReturn(inner);

    OCMExpect([classMock
               touchPathForFirstTouchPoint:point
               orientation:orientation
               offset:seconds]).andForwardToRealObject();

    OCMExpect([classMock eventPathForFirstTouchPoint:point
                                              offset:seconds]).andForwardToRealObject();

    TouchPath *tp = [TouchPath withFirstTouchPoint:point
                                       orientation:orientation
                                            offset:0.0];

    expect(tp.orientation).to.equal(orientation);
    expect(tp.lastPoint).to.equal(point);
    expect(tp.xcTouchPath).to.beAKindOf([XCTouchPath class]);
    expect(tp.eventPath).to.beAKindOf([XCPointerEventPath class]);


    XCTouchPath *xcTouchPath = tp.xcTouchPath;
    expect(xcTouchPath.touchEvents.count).to.equal(1);
    expect([xcTouchPath.touchEvents[0] coordinate]).to.equal(point);
    expect(xcTouchPath.interfaceOrientation).to.equal(orientation);

    XCPointerEventPath *eventPath = tp.eventPath;
    expect(eventPath.pointerEvents.count).to.equal(1);
    expect([eventPath.pointerEvents[0] coordinate]).to.equal(point);

    OCMVerifyAll(classMock);
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
    NSInteger orientation = 1;
    CGFloat seconds = 20;

    TouchPath *tp = [TouchPath withFirstTouchPoint:firstPoint
                                       orientation:orientation
                                            offset:0.0];

    id xcTouchPath = OCMPartialMock(tp.xcTouchPath);
    OCMExpect([xcTouchPath moveToPoint:nextPoint
                              atOffset:seconds]).andForwardToRealObject();

    id eventPath = OCMPartialMock(tp.eventPath);
    OCMExpect([eventPath moveToPoint:nextPoint
                            atOffset:seconds]).andForwardToRealObject();

    [tp moveToNextPoint:nextPoint afterSeconds:seconds];
    expect(tp.lastPoint).to.equal(nextPoint);

    XCTouchPath *xctp = tp.xcTouchPath;
    expect(xctp.touchEvents.count).to.equal(2);
    expect([xctp.touchEvents[1] coordinate]).to.equal(nextPoint);
    expect(xctp.interfaceOrientation).to.equal(orientation);

    XCPointerEventPath *ep = tp.eventPath;
    expect(ep.pointerEvents.count).to.equal(2);
    expect([ep.pointerEvents[1] coordinate]).to.equal(nextPoint);

    OCMVerifyAll(xcTouchPath);
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

    id xcTouchPath = OCMPartialMock(tp.xcTouchPath);
    OCMExpect([xcTouchPath liftUpAtPoint:point
                              offset:seconds]).andForwardToRealObject();

    id eventPath = OCMPartialMock(tp.eventPath);
    OCMExpect([eventPath liftUpAtOffset:seconds]).andForwardToRealObject();

    [tp liftUpAfterSeconds:seconds];

    OCMVerifyAll(xcTouchPath);
    OCMVerifyAll(eventPath);
}

@end

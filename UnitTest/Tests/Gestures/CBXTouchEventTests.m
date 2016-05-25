
#import <XCTest/XCTest.h>

#import "CBXTouchEvent.h"
#import "TouchPath.h"
#import "XCSynthesizedEventRecord.h"
#import "XCTouchGesture.h"

@interface CBXTouchEvent ()

@property (nonatomic, strong) XCSynthesizedEventRecord *event;
@property (nonatomic, strong) XCTouchGesture *gesture;
@property (nonatomic) NSInteger orientation;

+ (XCSynthesizedEventRecord *)eventRecordWithOrientation:(NSInteger) orientation;
+ (XCTouchGesture *)touchGesture;

@end

@interface CBXTouchEventTests : XCTestCase

@property(nonatomic, strong) TouchPath *touchPath;

@end

@implementation CBXTouchEventTests


- (void)setUp {
    [super setUp];

    CGPoint point = CGPointMake(20, 46);
    self.touchPath = [TouchPath withFirstTouchPoint:point orientation:1];
}

- (void)testWithTouchPath {
    NSInteger orientation = self.touchPath.orientation;

    id classMock = OCMClassMock([CBXTouchEvent class]);
    OCMExpect([classMock
               eventRecordWithOrientation:orientation]).andForwardToRealObject();

    OCMExpect([classMock touchGesture]).andForwardToRealObject();

    CBXTouchEvent *event = [CBXTouchEvent withTouchPath:self.touchPath];
    expect(event.orientation).to.equal(orientation);

    OCMVerifyAll(classMock);
}

- (void)testAddTouchPathOrientationInvalid {
    CGPoint point = CGPointMake(54, 47);
    NSInteger nextOrientation = self.touchPath.orientation;
    TouchPath *nextPath = [TouchPath withFirstTouchPoint:point
                                             orientation:nextOrientation + 1];

    CBXTouchEvent *event = [CBXTouchEvent withTouchPath:self.touchPath];
    expect(^{
        [event addTouchPath:nextPath];
    }).to.raise(@"NSInternalInconsistencyException");
}

- (void)testAddTouchPath {
    CBXTouchEvent *event = [CBXTouchEvent withTouchPath:self.touchPath];
    TouchPath *nextPath = [TouchPath withFirstTouchPoint:CGPointMake(311, 420)
                                             orientation:self.touchPath.orientation];

    XCSynthesizedEventRecord *eventRecord = event.event;
    id recordMock = OCMPartialMock(eventRecord);
    OCMStub([recordMock
             addPointerEventPath:nextPath.eventPath]).andForwardToRealObject();

    XCTouchGesture *gesture = event.gesture;
    id gestureMock = OCMPartialMock(gesture);
    OCMStub([gestureMock
             addTouchPath:nextPath.xcTouchPath]).andForwardToRealObject();

    [event addTouchPath:nextPath];

    OCMVerifyAll(recordMock);
    OCMVerifyAll(gestureMock);
}

@end

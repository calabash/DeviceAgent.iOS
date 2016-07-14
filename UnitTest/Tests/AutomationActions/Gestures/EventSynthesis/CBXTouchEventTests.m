
#import <XCTest/XCTest.h>

#import "CBXTouchEvent.h"
#import "TouchPath.h"
#import "XCSynthesizedEventRecord.h"

@interface CBXTouchEvent ()

@property (nonatomic, strong) XCSynthesizedEventRecord *event;
@property (nonatomic) long long orientation;

+ (XCSynthesizedEventRecord *)eventRecordWithOrientation:(long long) orientation;

@end

@interface CBXTouchEventTests : XCTestCase

@property(nonatomic, strong) TouchPath *touchPath;

@end

@implementation CBXTouchEventTests


- (void)setUp {
    [super setUp];

    CGPoint point = CGPointMake(20, 46);
    self.touchPath = [TouchPath withFirstTouchPoint:point
                                        orientation:1
                                             offset:0.0];
}

- (void)testWithTouchPath {
    long long orientation = self.touchPath.orientation;

    id classMock = OCMClassMock([CBXTouchEvent class]);
    OCMExpect([classMock
               eventRecordWithOrientation:orientation]).andForwardToRealObject();

    CBXTouchEvent *event = [CBXTouchEvent withTouchPath:self.touchPath];
    expect(event.orientation).to.equal(orientation);

    OCMVerifyAll(classMock);
}

- (void)testAddTouchPathOrientationInvalid {
    CGPoint point = CGPointMake(54, 47);
    long long nextOrientation = self.touchPath.orientation;
    TouchPath *nextPath = [TouchPath withFirstTouchPoint:point
                                             orientation:nextOrientation + 1
                                                  offset:1.0];

    CBXTouchEvent *event = [CBXTouchEvent withTouchPath:self.touchPath];
    expect(^{
        [event addTouchPath:nextPath];
    }).to.raise(@"NSInternalInconsistencyException");
}

- (void)testAddTouchPath {
    CBXTouchEvent *event = [CBXTouchEvent withTouchPath:self.touchPath];
    TouchPath *nextPath = [TouchPath withFirstTouchPoint:CGPointMake(311, 420)
                                             orientation:self.touchPath.orientation
                                                  offset:0.5];

    XCSynthesizedEventRecord *eventRecord = event.event;
    id recordMock = OCMPartialMock(eventRecord);
    OCMStub([recordMock
             addPointerEventPath:nextPath.eventPath]).andForwardToRealObject();

    [event addTouchPath:nextPath];

    OCMVerifyAll(recordMock);
}

@end

#import <XCTest/XCTest.h>
#import "JSONUtils.h"
#import "XCUICoordinate.h"
#import "XCUIElement.h"
#import "CBXConstants.h"

@interface XCUICoordinate (CBXTEST)

- (id)initForTesting;

@end

@implementation XCUICoordinate (CBXTEST)

- (id)initForTesting {
    self = [super init];
    if (self) {

    }
    return self;
}

@end

@interface JSONUtils (CBXTEST)

+ (NSDictionary *)elementHitPointToJSON:(XCUIElement *)element;
+ (BOOL)elementHitable:(XCUIElement *)element;

@end

@interface JSONUtilsTest : XCTestCase

@end

@implementation JSONUtilsTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testElementHitable {
    XCUIElement *element = [XCUIElement new];
    id mockElement = OCMPartialMock(element);
    OCMExpect([mockElement isHittable]).andReturn(YES);

    expect([JSONUtils elementHitable:mockElement]).to.equal(YES);

    OCMVerify(mockElement);
}

// Not possible to test with mocks because FB overrides
// forwardInvocationForRealObject: in XCUIElement(WebDriverAttributesForwarding)
- (void)testElementHitableCatchesExceptions {
  // Has integration test coverage.
}

- (void)testElementHitPointToJSON_NoHitpoint {
    XCUIElement *element = [XCUIElement new];
    id mockElement = OCMPartialMock(element);
    OCMExpect([mockElement hitPointCoordinate]).andReturn(nil);

    NSDictionary *actual;
    actual = [JSONUtils elementHitPointToJSON:element];

    expect(actual).to.beAKindOf([NSDictionary class]);
    expect(actual.count).to.equal(2);
    expect(actual[@"x"]).to.equal(-1);
    expect(actual[@"y"]).to.equal(-1);

    OCMVerify(mockElement);
}

- (void)testElementHitPointToJSON_HasHitpoint {
    CGPoint point = CGPointMake(10, 20);
    XCUICoordinate *coordinate = [[XCUICoordinate alloc] initForTesting];
    id mockCoordinate = OCMPartialMock(coordinate);
    OCMExpect([mockCoordinate screenPoint]).andReturn(point);

    XCUIElement *element = [XCUIElement new];
    id mockElement = OCMPartialMock(element);
    OCMExpect([mockElement hitPointCoordinate]).andReturn(mockCoordinate);

    NSDictionary *actual;
    actual = [JSONUtils elementHitPointToJSON:element];

    expect(actual.count).to.equal(2);
    expect(actual[@"x"]).to.equal(10);
    expect(actual[@"y"]).to.equal(20);


    OCMVerify(mockCoordinate);
    OCMVerify(mockElement);
}

// Not possible to test with mocks because FB overrides
// forwardInvocationForRealObject: in XCUIElement(WebDriverAttributesForwarding)
- (void)testElementHitPointToJSON_RaisesExceptionCallingHitPointCoordinate {
  // Has integration test coverage.
}

// Not possible to test with mocks because FB overrides
// forwardInvocationForRealObject: in XCUIElement(WebDriverAttributesForwarding)
- (void)testElementHitPointToJSON_RaisesExceptionCallingScreenPoint {
  // Has integration test coverage.
}

@end

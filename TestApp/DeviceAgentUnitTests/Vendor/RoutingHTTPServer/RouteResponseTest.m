
#import "CBXServerUnitTestUmbrellaHeader.h"
#import "RouteResponse.h"
#import "HTTPConnection.h"

@interface RouteResponseTest : XCTestCase

@end

@implementation RouteResponseTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testJSONHeader {
    HTTPConnection *connection = [HTTPConnection new];
    RouteResponse *response = [[RouteResponse alloc]
                               initWithConnection:connection];

    id mockResponse = OCMPartialMock(response);
    OCMExpect([mockResponse respondWithData:[OCMArg isNotNil]]);

    NSDictionary *json = @{@"a" : @"b"};
    [mockResponse respondWithJSON:json];

    NSDictionary *headers = [mockResponse headers];

    expect(headers[@"Content-Type"]).equal(@"application/json; charset=utf-8");

    OCMVerifyAll(mockResponse);
}

@end

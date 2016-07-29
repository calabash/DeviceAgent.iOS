#import <XCTest/XCTest.h>
#import "CBXCUITestServer.h"
#import "RoutingHTTPServer.h"

@interface CBXCUITestServer (CBXTEST)

- (RoutingHTTPServer *)server;
+ (CBXCUITestServer *)sharedServer;
- (id)init_private;

@end

@interface CBXUITestServerTest : XCTestCase

@end

@implementation CBXUITestServerTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testInitThrowsException {
    expect(^{
        id server __unused = [[CBXCUITestServer alloc] init];
    }).to.raise(@"SingletonException");
}

- (void)testInitPrivateSetsServerAndRegistersRoutes {
    CBXCUITestServer *server = [[CBXCUITestServer alloc] init_private];

    expect(server.server).notTo.beNil;
    expect([[server.server routes] count]).notTo.equal(0);
}

@end

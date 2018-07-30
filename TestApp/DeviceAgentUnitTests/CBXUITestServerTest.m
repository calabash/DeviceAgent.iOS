
#import "CBXServerUnitTestUmbrellaHeader.h"
#import "CBXCUITestServer.h"
#import "RoutingHTTPServer.h"

@interface CBXCUITestServer (CBXTEST)

- (RoutingHTTPServer *)server;
+ (CBXCUITestServer *)sharedServer;
- (id)init_private;
- (BOOL)isFinishedTesting;
- (void)setIsFinishedTesting:(BOOL)flag;

@end

@interface CBXUITestServerTest : XCTestCase

@property(nonatomic, strong) CBXCUITestServer *testServer;

@end

@implementation CBXUITestServerTest

- (void)setUp {
    [super setUp];
    self.testServer = [[CBXCUITestServer alloc] init_private];
}

- (void)tearDown {
    [super tearDown];
    self.testServer = nil;
}

- (void)testInitThrowsException {
    expect(^{
        id server __unused = [[CBXCUITestServer alloc] init];
    }).to.raise(@"SingletonException");
}

- (void)testInitPrivateSetsServerAndRegistersRoutes {
    expect(self.testServer.server).notTo.beNil;
    expect([[self.testServer.server routes] count]).notTo.equal(0);
    expect(self.testServer.isFinishedTesting).to.equal(NO);
}

@end


#import "CBXServerUnitTestUmbrellaHeader.h"
#import "CBXCUITestServer.h"
#import "CBXConstants.h"
#import <OCMock/OCMock.h>
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

-(void)testInitSetsDefaultPort {
    expect(self.testServer.server.port).equal(CBX_DEFAULT_SERVER_PORT);
}

-(void)testPassingPortFromEnvironment {
    id processInfo = [NSProcessInfo processInfo];
    id processInfoPartialMock = OCMPartialMock(processInfo);
    NSMutableDictionary *mockedEnv = [[[NSProcessInfo processInfo] environment] mutableCopy];
    mockedEnv[@"CbxServerPort"] = @"41799";
    OCMStub([processInfoPartialMock environment]).andReturn([mockedEnv copy]);
    
    expect([[NSProcessInfo processInfo] environment][@"CbxServerPort"]).equal(@"41799");
    
    CBXCUITestServer *customServer = [[CBXCUITestServer alloc] init_private];
    expect(customServer.server.port).equal(41799);
}

@end

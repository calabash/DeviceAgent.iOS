//
//  CalabashXCUITestServer.m
//  xcuitest-server

#import "RoutingHTTPServer.h"
#import "RoutingConnection.h"
#import "CBXCUITestServer.h"
#import "UIDevice+Wifi_IP.h"

@interface CBXCUITestServer ()
@property (atomic, strong) RoutingHTTPServer *server;
@end

@implementation CBXCUITestServer

static NSUInteger const DefaultStartingPort = 8100;
static NSUInteger const DefaultPortRange = 100;
static NSString *const CBWebServerErrorDomain = @"sh.calaba.xcuitest-server";
static CBXCUITestServer *sharedServer;

+ (void)load {
    static dispatch_once_t oncet;
    dispatch_once(&oncet, ^{
        sharedServer = [self new];
        sharedServer.server = [[RoutingHTTPServer alloc] init];
        [sharedServer.server setRouteQueue:dispatch_get_main_queue()];
        [sharedServer.server setDefaultHeader:@"Server" value:@"WebDriverAgent/1.0"];
        [sharedServer.server setConnectionClass:[RoutingConnection self]];
        [sharedServer registerServerKeyRouteHandlers];
    });
}

+ (void)start {
    NSLog(@"CalabashXCUITestServer built at %s %s", __DATE__, __TIME__);
    [sharedServer start];
    [[NSRunLoop mainRunLoop] run];
}

- (void)start {
    NSRange serverPortRange = [self bindingPortRange];
    NSError *error;
    BOOL serverStarted = NO;
    
    for (NSInteger index = 0; index < serverPortRange.length; index++) {
        NSInteger port = serverPortRange.location + index;
        [self.server setPort:port];
        
        serverStarted = [self attemptToStartServer:self.server onPort:port withError:&error];
        if (serverStarted) {
            break;
        }
        
        NSLog(@"Failed to start web server on port %ld with error %@", (long)port, [error description]);
    }
    
    if (!serverStarted) {
        NSLog(@"Last attempt to start web server failed with error %@", [error description]);
        abort();
    }
    
    NSLog(@"WebDriverAgent started on http://%@:%hu", [UIDevice currentDevice].wifiIPAddress, [self.server port]);
}

- (BOOL)attemptToStartServer:(RoutingHTTPServer *)server onPort:(NSInteger)port withError:(NSError **)error
{
    server.port = port;
    NSError *innerError = nil;
    BOOL started = [server start:&innerError];
    if (!started) {
        if (!error) {
            return NO;
        }
        
        NSString *description = @"Unknown Error when Starting server";
        if ([innerError.domain isEqualToString:NSPOSIXErrorDomain] && innerError.code == EADDRINUSE) {
            description = [NSString stringWithFormat:@"Unable to start web server on port %ld", (long)port];
        }
        
        *error = [NSError errorWithDomain:CBWebServerErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey : description, NSUnderlyingErrorKey : innerError}];
        return NO;
    }
    return YES;
}

- (void)registerServerKeyRouteHandlers
{
    [self.server get:@"/health" withBlock:^(RouteRequest *request, RouteResponse *response) {
        [response respondWithString:@"Calabash is ready and waiting."];
    }];
}

- (NSRange)bindingPortRange
{
    // Existence of PORT_OFFSET in the environment implies the port range is managed by the launching process.
    if (NSProcessInfo.processInfo.environment[@"PORT_OFFSET"]) {
        return NSMakeRange(DefaultStartingPort + [NSProcessInfo.processInfo.environment[@"PORT_OFFSET"] integerValue] , 1);
    }
    
    return NSMakeRange(DefaultStartingPort, DefaultPortRange);
}

@end

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
    
    /*
     * TODO: This approach will avoid us needing to crash the server when
     * there's a port conflict. However, we need to consider how we will
     * get the port over to calabash client / embedded server in the first place...
     */
    for (NSInteger index = 0; index < serverPortRange.length; index++) {
        
        [self.server setPort:serverPortRange.location + index];
        serverStarted = [self attemptToStartWithError:&error];
        if (serverStarted) {
            break;
        }
        
        NSLog(@"Failed to start web server on port %ld with error %@", (long)self.server.port, [error description]);
    }
    
    if (!serverStarted) {
        NSLog(@"Last attempt to start web server failed with error %@", [error description]);
        abort();
    }
    
    NSLog(@"WebDriverAgent started on http://%@:%hu", [UIDevice currentDevice].wifiIPAddress, [self.server port]);
}

- (BOOL)attemptToStartWithError:(NSError **)error {
    NSError *innerError = nil;
    BOOL started = [self.server start:&innerError];
    if (!started) {
        if (!error) {
            return NO;
        }
        
        NSString *description = @"Unknown Error when Starting server";
        if ([innerError.domain isEqualToString:NSPOSIXErrorDomain] && innerError.code == EADDRINUSE) {
            description = [NSString stringWithFormat:@"Unable to start web server on port %ld", (long)self.server.port];
        }
        
        *error = [NSError errorWithDomain:CBWebServerErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey : description, NSUnderlyingErrorKey : innerError}];
        return NO;
    }
    return YES;
}

- (void)registerServerKeyRouteHandlers {
    /*
     * TODO: If there are few enough routes, we could just add them all here.
    */
    [self.server get:@"/health" withBlock:^(RouteRequest *request, RouteResponse *response) {
        [response respondWithString:@"Calabash is ready and waiting."];
    }];
}

- (NSRange)bindingPortRange {
    return NSMakeRange(DefaultStartingPort, DefaultPortRange);
}

@end

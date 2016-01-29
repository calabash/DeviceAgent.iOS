//
//  CalabashXCUITestServer.m
//  xcuitest-server

#import "RoutingHTTPServer.h"
#import "RoutingConnection.h"
#import "CBXCUITestServer.h"
#import "UIDevice+Wifi_IP.h"
#import "CBConstants.h"

@interface CBXCUITestServer ()
@property (atomic, strong) RoutingHTTPServer *server;
@end

@implementation CBXCUITestServer

static CBXCUITestServer *sharedServer;

+ (void)load {
    static dispatch_once_t oncet;
    dispatch_once(&oncet, ^{
        sharedServer = [self new];
        sharedServer.server = [[RoutingHTTPServer alloc] init];
        [sharedServer.server setRouteQueue:dispatch_get_main_queue()];
        [sharedServer.server setDefaultHeader:@"Server" value:@"CalabashXCUITestServer/1.0"];
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
    NSError *error;
    BOOL serverStarted = NO;
        
    [self.server setPort:DEFAULT_SERVER_PORT];
    serverStarted = [self attemptToStartWithError:&error];
    
    if (!serverStarted) {
        NSLog(@"Attempt to start web server failed with error %@", [error description]);
        abort();
    }
    
    NSLog(@"CalabashXCUITestServer started on http://%@:%hu", [UIDevice currentDevice].wifiIPAddress, [self.server port]);
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


@end

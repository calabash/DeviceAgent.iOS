//
//  CalabashXCUITestServer.m
//  xcuitest-server

#import "RoutingHTTPServer.h"
#import "RoutingConnection.h"
#import "CBXCUITestServer.h"
#import "UIDevice+Wifi_IP.h"
#import "UndefinedRoutes.h"
#import <objc/runtime.h>
#import "CBXProtocols.h"
#import "CBXConstants.h"

@interface CBXCUITestServer ()
@property (atomic, strong) RoutingHTTPServer *server;
@property (atomic, strong) NSRunLoop *runLoop;
@end

@implementation CBXCUITestServer

static CBXCUITestServer *sharedServer;
static NSString *serverName = @"CalabashXCUITestServer";

+ (void)load {
    static dispatch_once_t oncet;
    dispatch_once(&oncet, ^{
        sharedServer = [self new];
        sharedServer.server = [[RoutingHTTPServer alloc] init];
        [sharedServer.server setRouteQueue:dispatch_get_main_queue()];
        [sharedServer.server setDefaultHeader:@"CalabusDriver"
                                        value:@"CalabashXCUITestServer/1.0"];
        [sharedServer.server setConnectionClass:[RoutingConnection self]];
        [sharedServer.server setType:@"_calabus._tcp."];

        NSString *uuid = [[NSProcessInfo processInfo] globallyUniqueString];
        NSString *token = [uuid componentsSeparatedByString:@"-"][0];
        NSString *serverName = [NSString stringWithFormat:@"CalabusDriver-%@", token];
        [sharedServer.server setName:serverName];

        NSDictionary *capabilities =
        @{
          @"name" : [[UIDevice currentDevice] name]
          };

        [sharedServer.server setTXTRecordDictionary:capabilities];
        [sharedServer registerRoutes];
    });
}

+ (void)start {
    NSLog(@"%@ built at %s %s", serverName, __DATE__, __TIME__);
    [sharedServer start];
}

- (void)start {
    NSError *error;
    BOOL serverStarted = NO;
        
    [self.server setPort:CBX_DEFAULT_SERVER_PORT];
    serverStarted = [self attemptToStartWithError:&error];
    
    if (!serverStarted) {
        NSLog(@"Attempt to start web server failed with error %@", [error description]);
        abort();
    }

    NSLog(@"%@ started on http://%@:%hu",
          serverName,
          [UIDevice currentDevice].wifiIPAddress,
          [self.server port]);

    self.runLoop = [NSRunLoop mainRunLoop];
    while ([self.server isRunning] && [self.runLoop runMode:NSDefaultRunLoopMode
                                                 beforeDate:[NSDate distantFuture]]) {
        ;
    }
}

+ (void)stop {
    [sharedServer stop];
}

- (void)stop {
    dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW,
                                         CBX_SERVER_SHUTDOWN_DELAY * NSEC_PER_SEC);
    dispatch_after(when, dispatch_get_main_queue(), ^{
        [self.server stop:NO];
        if ([self.server isRunning]) {
            NSLog(@"DeviceAgent has retired.");
        } else {
            NSLog(@"DeviceAgent is still running.");
        }
    });
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
        
        *error = [NSError errorWithDomain:CBXWebServerErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey : description, NSUnderlyingErrorKey : innerError}];
        return NO;
    }
    return YES;
}

/*
 *  Use objc runtime to get all classes inheriting implementing CBRoute.
 *  call [Class addRoutesToServer:self.server] on all resulting classes.
 */
- (void)registerRoutes {
    unsigned int outCount;
    Class *classes = objc_copyClassList(&outCount);
    for (int i = 0; i < outCount; i++) {
        Class c = classes[i];
        if (class_conformsToProtocol(c, @protocol(CBRouteProvider))) {
            NSArray <CBXRoute *> *routes = [c performSelector:@selector(getRoutes)];
            for (CBXRoute *route in routes) {
                if ([route shouldAutoregister]) {
                    [self.server addRoute:route];
                }
            }
        }
    }
    free(classes);
    for (CBXRoute *route in [UndefinedRoutes getRoutes]) {
        [self.server addRoute:route];
    }
}

@end

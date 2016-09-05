#import "RoutingHTTPServer.h"
#import "RoutingConnection.h"
#import "CBXCUITestServer.h"
#import "UIDevice+Wifi_IP.h"
#import "UndefinedRoutes.h"
#import <objc/runtime.h>
#import "CBXProtocols.h"
#import "CBXConstants.h"
#import "SpringBoard.h"
#import "Application+Queries.h"
#import "SpringBoardAlerts.h"
#import "SpringBoardAlert.h"

// Alerts are animated on and off. The animation is ~0.4 seconds.
static NSTimeInterval const SpringBoardAlertHandlerSleep = 0.4;

@interface CBXCUITestServer ()
@property (atomic, strong) RoutingHTTPServer *server;
@property (atomic, assign) BOOL isFinishedTesting;

+ (CBXCUITestServer *)sharedServer;
- (id)init_private;
- (void)handleSpringBoardAlert;

@end

@implementation CBXCUITestServer

static NSString *serverName = @"CalabashXCUITestServer";

- (id)init {
    @throw [NSException exceptionWithName:@"SingletonException"
                                   reason:@"This is a singleton class. init is not available."
                                 userInfo:nil];
}

- (instancetype)init_private {
    self = [super init];
    if (self) {
        _isFinishedTesting = NO;
        _server = [[RoutingHTTPServer alloc] init];
        [_server setRouteQueue:dispatch_get_main_queue()];
        [_server setDefaultHeader:@"CalabusDriver"
                                        value:@"CalabashXCUITestServer/1.0"];
        [_server setConnectionClass:[RoutingConnection self]];
        [_server setType:@"_calabus._tcp."];

        NSString *uuid = [[NSProcessInfo processInfo] globallyUniqueString];
        NSString *token = [uuid componentsSeparatedByString:@"-"][0];
        NSString *serverName = [NSString stringWithFormat:@"CalabusDriver-%@", token];
        [_server setName:serverName];

        NSDictionary *capabilities =
        @{
          @"name" : [[UIDevice currentDevice] name]
          };

        [_server setTXTRecordDictionary:capabilities];
        [self registerRoutes];
    }
    return self;
}

+ (CBXCUITestServer *)sharedServer {
    static CBXCUITestServer *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[CBXCUITestServer alloc] init_private];
    });
    return shared;
}

+ (void)start {
    NSLog(@"%@ built at %s %s", serverName, __DATE__, __TIME__);
    [[CBXCUITestServer sharedServer] start];
}

- (void)start {
    NSError *error;
    BOOL serverStarted = NO;

    [self.server setPort:CBX_DEFAULT_SERVER_PORT];
    NSLog(@"Attempting to start the DeviceAgent server");
    serverStarted = [self attemptToStartWithError:&error];

    if (!serverStarted) {
        NSLog(@"Attempt to start web server failed with error %@", [error description]);
        abort();
    }

    NSLog(@"%@ started on http://%@:%hu",
          serverName,
          [UIDevice currentDevice].wifiIPAddress,
          [self.server port]);

    NSTimeInterval interval = 0.1;
    while ([self.server isRunning] && !self.isFinishedTesting) {

        // If we are worried about alloc'ing NSDate objects, it might be
        // possible to replace with:
        // CFRunLoopRunInMode(kCFRunLoopDefaultMode, timeout_, false);
        NSDate *until = [[NSDate date] dateByAddingTimeInterval:interval];
        [[NSRunLoop mainRunLoop] runUntilDate:until];

        [self handleSpringBoardAlert];
    }
}

- (void)handleSpringBoardAlert {
    XCUIElementQuery *query = [[SpringBoard application]
                               descendantsMatchingType:XCUIElementTypeAlert];
    NSArray <XCUIElement *> *elements = [query allElementsBoundByIndex];
    if ([elements count] != 0) {
        XCUIElement *alert = elements[0];

        // Alerts are animated on.  Interacting with the alert before it is
        // fully animated can cause crashes and touch events that do perform
        // no action.
        //
        // It is not clear yet if the sleep is value is good.  It works, but
        // maybe it is not necessary, can be shorter, or needs to be longer.
        //
        // It is not clear yet what the effect of waiting for quiescence is.
        [[SpringBoard application] _waitForQuiescence];
        NSDate *until = [[NSDate date] dateByAddingTimeInterval:SpringBoardAlertHandlerSleep];
        [[NSRunLoop mainRunLoop] runUntilDate:until];

        if (alert.exists) {
            NSString *title = alert.label;

            SpringBoardAlert *springBoardAlert;
            springBoardAlert = [[SpringBoardAlerts shared] alertMatchingTitle:title];

            // The alert is on the list of alerts to auto dismiss
            if (springBoardAlert) {

                XCUIElement *button = nil;
                NSString *mark = springBoardAlert.defaultDismissButtonMark;
                button = alert.buttons[mark];

                // The default button does not exist.  It probably changed
                // after an iOS update.
                if (!button.exists) {
                    button = nil;
                }

                // Use the default button.
                if (!button) {
                    query = [alert descendantsMatchingType:XCUIElementTypeButton];
                    NSArray<XCUIElement *> *buttons = [query allElementsBoundByIndex];

                    if (springBoardAlert.shouldAccept) {
                        button = buttons.lastObject;
                    } else {
                        button = buttons.firstObject;
                    }
                }

                if (button && button.exists) {
                    [button tap];

                    // Alerts are animated off.
                    // It is not clear yet if we need to sleep or wait for
                    // quiescence.
                    [[SpringBoard application] _waitForQuiescence];
                    until = [[NSDate date] dateByAddingTimeInterval:SpringBoardAlertHandlerSleep];
                    [[NSRunLoop mainRunLoop] runUntilDate:until];
                }
            }
        }
    }
}

+ (void)stop {
    [[CBXCUITestServer sharedServer] stop];
}

- (void)stop {
    dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW,
                                         CBX_SERVER_SHUTDOWN_DELAY * NSEC_PER_SEC);
    dispatch_after(when, dispatch_get_main_queue(), ^{
        [self.server stop:NO];
        if ([self.server isRunning]) {
            NSLog(@"DeviceAgent server has retired.");
        } else {
            NSLog(@"DeviceAgent server is still running.");
        }
        self.isFinishedTesting = YES;
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

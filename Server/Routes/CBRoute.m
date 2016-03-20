//
//  CBRoute.m
//  xcuitest-server
//

#import "CBShutdownServerException.h"
#import "CBRoute.h"

@implementation CBRoute

+ (RequestHandler)handleRequestAndExceptions:(RequestHandler)block {
    return ^(RouteRequest *request, NSDictionary *body, RouteResponse *response) {
        @try {
            block(request, body, response);
        } @catch (NSException *e) {
            if ([e isKindOfClass:[CBException class]]) {
                if ([e isKindOfClass:[CBShutdownServerException class]]) {
                    //User wants to kill the server.
                    //Throw the exception back up to the calling XCTestCase
                    @throw e;
                } else {
                    [response setStatusCode:((CBException *)e).HTTPErrorStatusCode];
                    [response respondWithJSON:@{ @"error" : [e reason] }];
                }
            } else {
                NSLog(@"%@", e.callStackSymbols);
                [response setStatusCode:500];
                [response respondWithJSON:@{ @"error" : [e reason] }];
            }
        }
    };
}

+ (instancetype)http:(NSString *)verb path:(NSString *)path withBlock:(RequestHandler)block {
    CBRoute *r = [self routeWithPath:path block:[self handleRequestAndExceptions:block]];
    r.shouldAutoregister = YES;
    r.HTTPVerb = verb;
    r.path = path;
    return r;
}

+ (instancetype)get:(NSString *)path withBlock:(RequestHandler)block {
    return [self http:@"GET" path:path withBlock:block];
}
+ (instancetype)post:(NSString *)path withBlock:(RequestHandler)block {
    return [self http:@"POST" path:path withBlock:block];
}
+ (instancetype)put:(NSString *)path withBlock:(RequestHandler)block {
    return [self http:@"PUT" path:path withBlock:block];
}
+ (instancetype)delete:(NSString *)path withBlock:(RequestHandler)block {
    return [self http:@"DELETE" path:path withBlock:block];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ %@", self.HTTPVerb, self.path];
}
@end

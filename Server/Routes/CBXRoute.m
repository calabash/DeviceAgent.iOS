
#import "CBXConstants.h"
#import "CBXException.h"
#import "CBXRoute.h"

@implementation CBXRoute

+ (RequestHandler)handleRequestAndExceptions:(RequestHandler)block {
    return ^(RouteRequest *request, NSDictionary *body, RouteResponse *response) {
        @try {
            block(request, body, response);
        } @catch (NSException *e) {
            NSMutableDictionary *dict = [([e userInfo] ?: @{}) mutableCopy];
            dict[CBX_ERROR_KEY] = [e reason];
            
            @try {
                if ([e isKindOfClass:[CBXException class]]) {
                    [response setStatusCode:((CBXException *)e).HTTPErrorStatusCode];
                    [response respondWithJSON:dict];
                } else {
                    DDLogDebug(@"%@", e.callStackSymbols);
                    [response setStatusCode:500];
                    [response respondWithJSON:dict];
                }
            } @catch (NSException *innerException) {
                [response setStatusCode:500];
                [response respondWithJSON:@{@"error" : @"Internal exception occurred. See DeviceAgent log",
                                            @"inner exception" : innerException.debugDescription ?: @""}];
            }
        }
    };
}

+ (instancetype)http:(NSString *)verb path:(NSString *)path withBlock:(RequestHandler)block {
    CBXRoute *r = [self routeWithPath:path block:[self handleRequestAndExceptions:block]];
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

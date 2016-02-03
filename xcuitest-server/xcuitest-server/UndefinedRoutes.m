//
//  UndefinedRoutes.m
//  xcuitest-server
//

#import "UndefinedRoutes.h"
#import "CBMacros.h"

@interface CBRoute (DontAutoregister)
- (instancetype)dontAutoregister;
@end

@implementation CBRoute (DontAutoregister)
- (instancetype)dontAutoregister {
    self.shouldAutoregister = NO;
    return self;
}
@end


@implementation UndefinedRoutes
+ (NSArray <CBRoute *> *)getRoutes {
    
    RequestHandler unhandledBlock = ^(RouteRequest *request, RouteResponse *response) {
        //TODO is 404 correct? "Not Found"
        [response setStatusCode:404];
        [response respondWithString:[NSString stringWithFormat:@"Unhandled endpoint: %@\nParams: %@\nBody: %@", request.url, request.params, DATA_TO_JSON(request.body)]];
    };
    return @[
             [CBRoute get:@"/*" withBlock:unhandledBlock].dontAutoregister,
             [CBRoute post:@"/*" withBlock:unhandledBlock].dontAutoregister,
             [CBRoute put:@"/*" withBlock:unhandledBlock].dontAutoregister,
             [CBRoute delete:@"/*" withBlock:unhandledBlock].dontAutoregister,
             ];
}
@end

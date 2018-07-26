
#import "UndefinedRoutes.h"
#import "CBXMacros.h"
#import "CBXRoute.h"

@interface CBXRoute (DontAutoregister)
- (instancetype)dontAutoregister;
@end

@implementation CBXRoute (DontAutoregister)
- (instancetype)dontAutoregister {
    self.shouldAutoregister = NO;
    return self;
}
@end


@implementation UndefinedRoutes
+ (NSArray <CBXRoute *> *)getRoutes {
    
    RequestHandler unhandledBlock = ^(RouteRequest *request, NSDictionary *body, RouteResponse *response) {
        //TODO is 404 correct? "Not Found"
        [response setStatusCode:404];
        [response respondWithJSON: @{
                                     @"error" : @"unhandled endpoint",
                                     @"requestURL" : [request.url.baseURL absoluteString] ?: @"?",
                                     @"requestEndpoint" : [request.url relativePath] ?: @"?",
                                     @"requestMethod" : request.method ?: @"",
                                     @"requestParameters" : request.params ?: @[],
                                     @"requestBody" : body ?: @{}
         }];
    };
    return @[
             [CBXRoute get:@"/*" withBlock:unhandledBlock].dontAutoregister,
             [CBXRoute post:@"/*" withBlock:unhandledBlock].dontAutoregister,
             [CBXRoute put:@"/*" withBlock:unhandledBlock].dontAutoregister,
             [CBXRoute delete:@"/*" withBlock:unhandledBlock].dontAutoregister,
             ];
}
@end

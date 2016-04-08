//
//  UndefinedRoutes.m
//  xcuitest-server
//

#import "UndefinedRoutes.h"
#import "CBMacros.h"

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
                                     @"message" : @{ @"unhandled endpoint" : request.url ?: @"" },
                                     @"method" : request.method ?: @"",
                                     @"parameters" : request.params ?: @[],
                                     @"body" : body ?: @{}
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

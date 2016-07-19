//
//  GestureRotues.m
//  xcuitest-server
//

#import "GestureFactory.h"
#import "GestureRoutes.h"
#import "CBXConstants.h"
#import "Application.h"
#import "JSONUtils.h"
#import "CBXMacros.h"

@implementation GestureRoutes
+ (NSArray<CBXRoute *> *)getRoutes {
    return @[
             [CBXRoute post:endpoint(@"/gesture", 1.0) withBlock:^(RouteRequest *request, NSDictionary *body, RouteResponse *response) {
                 [GestureFactory executeGestureWithJSON:body
                                               completion:^(NSError *e) {
                       if (e) {
                           [response respondWithJSON:@{ @"error" : e.localizedDescription }]; //should never execute
                       } else {
                           [response respondWithJSON:@{ @"status" : @"success" }];
                       }
                 }];
             }],
             [CBXRoute post:endpoint(@"/gesture/:test_id", 1.0) withBlock:^(RouteRequest *request, NSDictionary *body, RouteResponse *response) {
                 NSNumber *identifier = @([request.params[CBX_TEST_ID_KEY] integerValue]);
                 XCUIElement *el = [Application cachedElementOrThrow:identifier];
                 
                 NSMutableDictionary *b = [body mutableCopy];
                 b[@"specifiers"] = [(body[@"specifiers"] ?: @{}) mutableCopy];
                 
                 //Center point
                 NSDictionary *coordinate = @{@"x" : @(CGRectGetMidX(el.frame)),
                                              @"y" : @(CGRectGetMidY(el.frame)) };
                 
                 b[@"specifiers"][@"coordinate"] = coordinate;
                 
                 [GestureFactory executeGestureWithJSON:b
                                             completion:^(NSError *e) {
                                                 if (e) {
                                                     [response respondWithJSON:@{ @"error" : e.localizedDescription }]; //should never execute
                                                 } else {
                                                     [response respondWithJSON:@{ @"status" : @"success" }];
                                                 }
                                             }];
             }]
             ];
}


@end

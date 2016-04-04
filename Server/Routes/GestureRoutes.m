//
//  GestureRotues.m
//  xcuitest-server
//

#import "CBGestureFactory.h"
#import "GestureRoutes.h"
#import "CBConstants.h"
#import "JSONUtils.h"
#import "CBMacros.h"

@implementation GestureRoutes
+ (NSArray<CBRoute *> *)getRoutes {
    return @[
             [CBRoute post:@"/1.0/gesture" withBlock:^(RouteRequest *request, NSDictionary *body, RouteResponse *response) {
                 [CBGestureFactory executeGestureWithJSON:body
                                               completion:^(NSError *e, NSArray <NSString *> *warnings) {
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                     if (e) {
                         [response respondWithJSON:@{ @"error" : e.localizedDescription,
                                                      @"warnings" : warnings ?: @[] }];
                     } else {
                         if (warnings.count) {
                             [response respondWithJSON:@{ @"status" : @"success", @"warnings" : warnings }];
                         } else {
                             [response respondWithJSON:@{ @"status" : @"success" }];
                         }
                     }
                                                       });
                 }];
             }]
             ];
}


@end

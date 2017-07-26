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
#import "SpringBoard.h"

@implementation GestureRoutes
+ (NSArray<CBXRoute *> *)getRoutes {
    return @[
             [CBXRoute post:endpoint(@"/gesture", 1.0) withBlock:^(RouteRequest *request, NSDictionary *body, RouteResponse *response) {

                 // SpringBoard alerts block gestures.
                 [[SpringBoard application] handleAlertsOrThrow];

                 [GestureFactory executeGestureWithJSON:body completion:^(NSError *e) {
                     if (e) {
                         [response respondWithJSON:@{ @"error" : e.localizedDescription }];
                     } else {
                         [response respondWithJSON:@{ @"status" : @"success" }];
                     }
                 }];
             }],

             [CBXRoute post:endpoint(@"/dismiss-springboard-alerts", 1.0) withBlock:^(RouteRequest *request,
                                                                                      NSDictionary *body,
                                                                                      RouteResponse *response) {
                 [[SpringBoard application] handleAlertsOrThrow];
                 [response respondWithJSON:@{ @"status" : @"no alerts" }];
             }],

             [CBXRoute post:endpoint(@"/dismiss-springboard-alert", 1.0) withBlock:^(RouteRequest *request,
                                                                                     NSDictionary *body,
                                                                                     RouteResponse *response) {
                 NSString *buttonTitle = body[@"button_title"];

                 if (!buttonTitle) {
                     @throw [InvalidArgumentException
                             withMessage:@"Request body is missing required key: 'button_title'"
                             userInfo:@{@"received_body" : body}];
                 }

                 SpringBoardDismissAlertResult result;
                 result = [[SpringBoard application]
                           dismissAlertByTappingButtonWithTitle:buttonTitle];

                 NSDictionary *responseBody;
                 NSString *message = @"";
                 switch (result) {
                     case SpringBoardDismissAlertNoAlert: {
                         responseBody =
                         @{
                           @"error": @"There is no SpringBoard alert."
                           };
                         break;
                     }

                     case SpringBoardDismissAlertNoMatchingButton: {
                         message = [NSString stringWithFormat:@"There was no SpringBoard "
                                    "alert button matching '%@'", buttonTitle];
                         responseBody =
                         @{
                           @"error" : message
                           };
                         break;
                     }

                     case SpringBoardDismissAlertDismissTouchFailed: {
                         message = [NSString stringWithFormat:@"Failed to touch SpringBoard "
                                    "alert button with title '%@'", buttonTitle];
                         responseBody =
                         @{
                           @"error" : message
                           };
                         break;
                     }

                     case SpringBoardDismissAlertDismissedAlert: {
                         responseBody = @{ @"status" : @"success" };
                         break;
                     }
                 }

                 [response respondWithJSON:responseBody];
             }]
             ];
}


@end

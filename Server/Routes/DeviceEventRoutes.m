
#import "XCTest/XCUIApplication.h"
#import "DeviceEventRoutes.h"
#import "XCDeviceEvent.h"
#import "Testmanagerd.h"
#import "CBXConstants.h"
#import "CBXMacros.h"
#import "ThreadUtils.h"
#import "Application.h"
#import "XCTest/XCUIApplication.h"
#import "XCTest/XCUIDevice.h"
#import "CBXException.h"

/*
    TODO:

    Study the internals of
        http://www.opensource.apple.com/source/IOHIDFamily/IOHIDFamily-421.6/IOHIDFamily/IOHIDUsageTables.h
    and
        http://www.opensource.apple.com/source/IOHIDFamily/IOHIDFamily-421.6/IOHIDFamily/AppleHIDUsageTables.h

    These two tables seem to define what values are possible for XCDeviceEvent page and usage. However,
    the meanings are pretty non-obvious...
 */

#define HOME_BUTTON_PAGE 0x0C //not entirely accurate description
#define PRESS 0x40 //not entirely accurate description, but I don't have a better one

@implementation DeviceEventRoutes
+ (NSArray <CBXRoute *> *)getRoutes {
    return @[
             [CBXRoute post:endpoint(@"/home", 1.0) withBlock:^(RouteRequest *request, NSDictionary *data, RouteResponse *response) {
                 int page = HOME_BUTTON_PAGE;
                 int usage = PRESS;
                 int duration = 1;

                 id event = [NSClassFromString(@"XCDeviceEvent") deviceEventWithPage:page usage:usage duration:duration];

                 [[Testmanagerd get] _XCT_performDeviceEvent:event completion:^(NSError *e) {
                     if (e) {
                         DDLogDebug(@"%@", e);
                     }
                 }];
             }],
             [CBXRoute post:endpoint(@"/siri", 1.0) withBlock:^(RouteRequest *request, NSDictionary *data, RouteResponse *response) {
                 int page = HOME_BUTTON_PAGE;
                 int usage = PRESS;
                 int duration = 5;
                 id event = [NSClassFromString(@"XCDeviceEvent") deviceEventWithPage:page usage:usage duration:duration];

                 [[Testmanagerd get] _XCT_performDeviceEvent:event completion:^(NSError *e) {
                     if (e) {
                         DDLogDebug(@"%@", e);
                     }
                 }];
             }],
             [CBXRoute post:endpoint(@"/volume", 1.0) withBlock:^(RouteRequest *request, NSDictionary *body, RouteResponse *response) {
                 NSString *volumeDirection = [body[CBX_VOLUME_KEY] lowercaseString];
                 int page = 0xC; //12
                 int direction;
                 if ([volumeDirection isEqualToString:@"up"]) {
                     direction = 0xE9;
                 } else if ([volumeDirection isEqualToString:@"down"]) {
                     direction = 0XEA;
                 } else {
                     @throw [CBXException withMessage:@"Invalid volume direction. Please specify 'up' or 'down'"
                                             userInfo:@{@"direction" : volumeDirection ?: @""}];
                 }

                 id event = [NSClassFromString(@"XCDeviceEvent") deviceEventWithPage:page
                                                                               usage:direction
                                                                            duration:0.2];
                 [[Testmanagerd get] _XCT_performDeviceEvent:event completion:^(NSError *e) {
                     if (e) {
                         DDLogDebug(@"%@", e);
                     }
                 }];
                 [response respondWithJSON:@{@"status" : @"success", @"volumeDirection" : volumeDirection}];

             }],
             [CBXRoute post:endpoint(@"/rotate_home_button_to", 1.0) withBlock:^(RouteRequest *request, NSDictionary *data, RouteResponse *response) {
                 [XCUIDevice sharedDevice].orientation = (UIDeviceOrientation)[data[@"orientation"] longLongValue];
                 [response respondWithJSON:@{
                                             @"status" : @"success",
                                             @"orientation" : @([XCUIDevice sharedDevice].orientation)
                                             }];
             }]
             ];
}
@end

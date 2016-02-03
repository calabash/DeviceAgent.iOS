//
//  GestureRotues.m
//  xcuitest-server
//
//  Created by Chris Fuentes on 2/1/16.
//  Copyright © 2016 calabash. All rights reserved.
//

#import "CBApplication+Gestures.h"
#import "GestureRotues.h"
#import "CBConstants.h"
#import "CBMacros.h"

@implementation GestureRotues
+ (NSArray<CBRoute *> *)getRoutes {
    return @[
             [CBRoute post:@"/tap/coordinates" withBlock:^(RouteRequest *request, RouteResponse *response) {
                 NSDictionary *arguments = DATA_TO_JSON(request.body);
                 float x = [arguments[CB_X_KEY] floatValue],
                    y = [arguments[CB_Y_KEY] floatValue];
                 [CBApplication tap:x :y];
                 [response respondWithString:@"OK"];
             }]
             ];
}
@end

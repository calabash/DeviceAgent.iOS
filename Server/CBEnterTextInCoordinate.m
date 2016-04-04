//
//  CBEnterTextInCoordinates.m
//  CBXDriver
//
//  Created by Chris Fuentes on 4/4/16.
//  Copyright © 2016 Calabash. All rights reserved.
//

#import "CBEnterTextInCoordinate.h"
#import "CBTapCoordinate.h"
#import "JSONUtils.h"

@implementation CBEnterTextInCoordinate
+ (NSString *)name { return @"enter_text_in_coordinate"; }

- (NSArray <NSString *> *)requiredKeys {
    return @[@"coordinate"];
}

- (void)validate {
    NSDictionary *coordDict = self.query.coordinate;
    [JSONUtils pointFromCoordinateJSON:coordDict]; //performs validation
}

+ (CBGesture *)executeWithJSON:(NSDictionary *)json completion:(CompletionBlock)completion {
    NSMutableDictionary *j = [json mutableCopy];
    NSString *string = j[CB_STRING_KEY];
    [j removeObjectForKey:CB_STRING_KEY];
    
    CBTapCoordinate *tap = [CBTapCoordinate withJSON:j];
    [tap execute:^(NSError *e, NSArray<NSString *> *warnings) {
        if (e) {
            NSMutableArray *w = [warnings mutableCopy];
            [w addObject:@"Tap failed, unable to send string"];
            completion(e, w);
        } else {
            [[Testmanagerd get] _XCT_sendString:string completion:^(NSError *e) {
                if (e) @throw [CBException withMessage:@"Error performing gesture"];
            }];
            completion(e, warnings ?: @[]);
        }
    }];
    
    return tap;
}
@end

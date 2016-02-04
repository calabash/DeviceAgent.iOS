//
//  JSONUtils.m
//  xcuitest-server
//
//  Created by Chris Fuentes on 2/3/16.
//  Copyright © 2016 calabash. All rights reserved.
//

#import "JSONUtils.h"

@implementation JSONUtils
+ (NSMutableDictionary *)snapshotToJSON:(XCElementSnapshot *)snapshot {
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    json[@"type"] = @(snapshot.elementType); //TODO: stringify
    json[@"title"] = snapshot.title ?: @"";
    json[@"label"] = snapshot.label ?: @"";
    json[@"value"] = snapshot.value ?: @"";
    json[@"rect"] = [self rectToJSON:snapshot.frame];
    json[@"isEnabled"] = @(snapshot.isEnabled);
    
    //TODO: visible
    return json;
}

+ (NSDictionary *)rectToJSON:(CGRect)rect {
    return @{
             @"x" : @(rect.origin.x),
             @"y" : @(rect.origin.y),
             @"height" : @(rect.size.height),
             @"width" : @(rect.size.width)
             };
}
@end

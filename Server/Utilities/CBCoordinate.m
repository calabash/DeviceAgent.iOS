//
//  CBCoordinate.m
//  CBXDriver
//
//  Created by Chris Fuentes on 4/6/16.
//  Copyright © 2016 Calabash. All rights reserved.
//

#import "CBCoordinate.h"
#import "JSONUtils.h"

@interface CBCoordinate()
@property (nonatomic, strong) id json;
@end

@implementation CBCoordinate
- (CGPoint)cgpoint {
    return [JSONUtils pointFromCoordinateJSON:self.json];
}

+ (instancetype)fromRaw:(CGPoint)raw {
    return [self withJSON:@[ @(raw.x), @(raw.y) ]];
}

+ (instancetype)withJSON:(id)json {
    CBCoordinate *coord = [self new];
    [JSONUtils validatePointJSON:json];
    coord.json = json;
    return coord;
}
@end

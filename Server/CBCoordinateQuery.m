//
//  CBCoordinateQuery.m
//  CBXDriver
//
//  Created by Chris Fuentes on 4/6/16.
//  Copyright © 2016 Calabash. All rights reserved.
//

#import "CoordinateQueryConfiguration.h"
#import "CBCoordinateQuery.h"
#import "CBCoordinate.h"

@implementation CBCoordinateQuery

- (CBCoordinate *)coordinate {
    if (!self.queryConfiguration.isCoordinateQuery) {
        @throw [CBException withFormat:@"Error invoking '%@' on a non-coordinate query configuration",
                NSStringFromSelector(_cmd)];
    }
    return [self.queryConfiguration asCoordinateQueryConfiguration].coordinate;
}

- (NSArray<CBCoordinate *> *)coordinates {
    if (!self.queryConfiguration.isCoordinateQuery) {
        @throw [CBException withFormat:@"Error invoking '%@' on a non-coordinate query configuration",
                NSStringFromSelector(_cmd)];
    }
    return [self.queryConfiguration asCoordinateQueryConfiguration].coordinates;
}
@end

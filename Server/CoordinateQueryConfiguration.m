//
//  CoordinateQueryConfiguration.m
//  CBXDriver
//
//  Created by Chris Fuentes on 4/5/16.
//  Copyright © 2016 Calabash. All rights reserved.
//

#import "CoordinateQueryConfiguration.h"

@implementation CoordinateQueryConfiguration

- (id)init {
    if (self = [super init]) {
        self.isCoordinateQuery = YES;
    }
    return self;
}
@end

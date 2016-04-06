//
//  CBCoordinateQuery.h
//  CBXDriver
//
//  Created by Chris Fuentes on 4/6/16.
//  Copyright © 2016 Calabash. All rights reserved.
//

#import "CBCoordinate.h"
#import "CBQuery.h"

@interface CBCoordinateQuery : CBQuery
- (CBCoordinate *)coordinate;
- (NSArray<CBCoordinate *> *)coordinates;
@end

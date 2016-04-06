//
//  CoordinateQueryConfiguration.h
//  CBXDriver
//
//  Created by Chris Fuentes on 4/5/16.
//  Copyright © 2016 Calabash. All rights reserved.
//

#import "QueryConfiguration.h"
#import "CBCoordinate.h"

@interface CoordinateQueryConfiguration : QueryConfiguration
@property (nonatomic, strong) CBCoordinate * coordinate;
@property (nonatomic, strong) NSArray <CBCoordinate *> *coordinates;
@end

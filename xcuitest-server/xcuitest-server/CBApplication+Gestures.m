//
//  CBApplication+Gestures.m
//  xcuitest-server
//
//  Created by Chris Fuentes on 2/2/16.
//  Copyright © 2016 calabash. All rights reserved.
//

#import "CBApplication+Gestures.h"
#import "XCUICoordinate.h"

@implementation CBApplication(Gestures)

+ (void)tap:(float)x :(float)y {
    XCUICoordinate *appCoordinate = [[XCUICoordinate alloc] initWithElement:[self currentApplication]
                                                           normalizedOffset:CGVectorMake(0, 0)];
    
    XCUICoordinate *tapCoordinate = [[XCUICoordinate alloc] initWithCoordinate:appCoordinate
                                                                  pointsOffset:CGVectorMake(x, y)];
    [tapCoordinate tap];
}

@end

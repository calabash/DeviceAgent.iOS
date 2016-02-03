//
//  CBApplication+Gestures.m
//  xcuitest-server
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

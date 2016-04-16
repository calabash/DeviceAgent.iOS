//
//  CoordinateQueryTests.m
//  CBXDriver
//
//  Created by Chris Fuentes on 4/15/16.
//  Copyright © 2016 Calabash. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CoordinateQueryConfiguration.h"
#import "CoordinateQuery.h"

@interface CoordinateQueryTests : XCTestCase
@property (nonatomic, strong) CoordinateQueryConfiguration *coordinateConfig;
@property (nonatomic, strong) CoordinateQueryConfiguration *coordinatesConfig;
@end

@implementation CoordinateQueryTests

- (void)setUp {
    [super setUp];
    
    id json = @{@"coordinates" : @[@[@1, @2]]};
    _coordinatesConfig = [CoordinateQueryConfiguration withJSON:json validator:nil];
    
    json = @{@"coordinate" : @[@2, @2]};
    _coordinateConfig = [CoordinateQueryConfiguration withJSON:json validator:nil];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testValidCoordinateConfig {
    for (CoordinateQueryConfiguration *config in @[_coordinateConfig, _coordinatesConfig]) {
        CoordinateQuery *query = [CoordinateQuery withQueryConfiguration:config];
        expect(query.isCoordinateQuery).to.beTruthy;
        expect(query.coordinate).to.equal(config.coordinate);
        expect(query.coordinates).to.equal(config.coordinates);
    }
}

- (void)testInvalidCoordinateConfig {
    QueryConfiguration *config = [QueryConfiguration withJSON:@{} validator:nil];
    XCTAssertThrows([CoordinateQuery withQueryConfiguration:config],
                    @"Can not create CoordinateQuery with non-coordinate config");
    
}

@end

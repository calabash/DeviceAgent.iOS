
#import "QueryConfigurationFactory.h"
#import <XCTest/XCTest.h>

@interface QueryConfigurationFactoryTests : XCTestCase

@end

@implementation QueryConfigurationFactoryTests

- (void)testQueryConfiguration {
    QueryConfiguration *config = [QueryConfigurationFactory configWithJSON:@{}
                                                                 validator:nil];
    XCTAssertFalse(config.isCoordinateQuery, @"Non coordinate config was treated as coordinate config");
    XCTAssertFalse([config isKindOfClass:[CoordinateQueryConfiguration class]],
                   @"Non coordinate config returned as an instance of CoordinateQueryConfiguration");
}

- (void)testCoordinateQueryConfiguration {
    QueryConfiguration *config = [QueryConfigurationFactory configWithJSON:@{@"coordinate" : @[@(5), @(5)]}
                                                                 validator:nil];
    XCTAssertTrue(config.isCoordinateQuery, @"Non coordinate config was treated as coordinate config");
    XCTAssertTrue([config isKindOfClass:[CoordinateQueryConfiguration class]],
                   @"Non coordinate config returned as an instance of CoordinateQueryConfiguration");
}

@end


#import "QueryConfigurationFactory.h"
#import "QueryFactory.h"
#import <XCTest/XCTest.h>

@interface QueryFactoryTests : XCTestCase

@end

@implementation QueryFactoryTests

- (void)testQuery{
    QueryConfiguration *config = [QueryConfigurationFactory configWithJSON:@{}
                                                                 validator:nil];
    Query *query = [QueryFactory queryWithQueryConfiguration:config];
    XCTAssertFalse(query.isCoordinateQuery, @"Non coordinate config was treated as CoordinateQuery");
    XCTAssertFalse([query isKindOfClass:[CoordinateQuery class]],
                   @"Non coordinate config returned as an instance of CoordinateQuery");
}

- (void)testCoordinateQuery {
    QueryConfiguration *config = [QueryConfigurationFactory configWithJSON:@{@"coordinate" : @[@(5), @(5)]}
                                                                 validator:nil];
    Query *query = [QueryFactory queryWithQueryConfiguration:config];
    XCTAssertTrue(query.isCoordinateQuery, @"Non coordinate config was treated as CoordinateQuery");
    XCTAssertTrue([query isKindOfClass:[CoordinateQuery class]],
                   @"Non coordinate config returned as an instance of CoordinateQuery");
}

@end

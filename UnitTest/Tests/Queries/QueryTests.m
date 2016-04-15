
#import "Query.h"
#import "CoordinateQueryConfiguration.h"
#import <XCTest/XCTest.h>

@interface QueryTests : XCTestCase
@property (nonatomic, strong) QueryConfiguration *validQueryConfig;
@property (nonatomic, strong) CoordinateQueryConfiguration *validCoordinateQueryConfig;
@end

@implementation QueryTests

- (void)setUp {
    [super setUp];
    
    id json = @{@"id" : @"banana", @"text" : @"foozebawl"};
    _validQueryConfig = [QueryConfiguration withJSON:json validator:nil];
    
    json = @{@"coordinate" : @[ @2, @2 ]};
    _validCoordinateQueryConfig = [CoordinateQueryConfiguration withJSON:json validator:nil];
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testIsCoordinateCarriedFromConfig {
    Query *query = [Query withQueryConfiguration:_validQueryConfig];
    XCTAssertFalse(query.isCoordinateQuery,
                   @"Query given %@ thinks it is a coordinate query",
                   _validQueryConfig.raw);
    
    query = [Query withQueryConfiguration:_validCoordinateQueryConfig];
    XCTAssertTrue(query.isCoordinateQuery,
                  @"Query given %@ does not think it's a coordinate query",
                  _validCoordinateQueryConfig.raw);
}


@end

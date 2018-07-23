
#import "CBXServerUnitTestUmbrellaHeader.h"
#import "QueryConfiguration.h"
#import "QueryConfigurationFactory.h"
#import "CoordinateQueryConfiguration.h"

@interface QueryConfigurationTests : XCTestCase

@end

@implementation QueryConfigurationTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testIsNotCoordinateQuery {
    id json = @{};
    QueryConfiguration *config = [QueryConfiguration withJSON:json validator:nil];
    
    XCTAssertFalse(config.isCoordinateQuery,
                   @"QueryConfiguration given %@ thinks it's a coordinate query",
                   json);
}

- (void)testIsCoordinateQuery {
    id json = @{@"coordinate" : @[@1, @2]};
    QueryConfiguration *config = [CoordinateQueryConfiguration withJSON:json validator:nil];
    XCTAssertTrue(config.isCoordinateQuery,
                   @"QueryConfiguration given %@ thinks it's not a coordinate query",
                   json);
}

- (void)testAsCoordinateQuery {
    id json = @{@"coordinate" : @[@1, @2]};
    QueryConfiguration *config = [QueryConfiguration withJSON:json validator:nil];
    id coordinateConfig = [config asCoordinateQueryConfiguration];
    XCTAssertTrue([coordinateConfig isKindOfClass:[CoordinateQueryConfiguration class]],
                  @"asCoordinateQueryConfiguration did not return a CoordinateQueryConfiguration");
    
    json = @{};
    config = [QueryConfiguration withJSON:json validator:nil];
    XCTAssertThrows([config asCoordinateQueryConfiguration],
                    @"Non-coordinate query config was converted to coordinate query config: %@",
                    json);
}

- (void)testSelectorCreation {
    id json = @{@"id" : @"orangutans", @"index" : @0, @"text_like" : @"breakfast cereals" };
    QueryConfiguration *config = [QueryConfiguration withJSON:json validator:nil];
    
    XCTAssertNotNil(config.selectors, @"No selectors generated for json: %@", json);
    XCTAssertEqual(config.selectors.count,
                   [json count],
                   @"Not enough selectors generated for %@: %@",
                   json,
                   config.selectors);
}


@end

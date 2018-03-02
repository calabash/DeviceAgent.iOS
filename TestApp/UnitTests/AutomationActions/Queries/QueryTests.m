
#import <XCTest/XCTest.h>
#import "QueryConfigurationFactory.h"
#import "CoordinateQueryConfiguration.h"
#import "QueryFactory.h"
#import "JSONUtils.h"


@interface QueryTests : XCTestCase
@property (nonatomic, strong) QueryConfiguration *validQueryConfig;
@property (nonatomic, strong) QueryConfiguration *emptyQueryConfig;
@property (nonatomic, strong) CoordinateQueryConfiguration *validCoordinateQueryConfig;
@end

@implementation QueryTests

- (void)setUp {
    [super setUp];
    
    id json = @{@"id" : @"banana", @"text" : @"Rumplestiltskin"};
    _validQueryConfig = [QueryConfiguration withJSON:json validator:nil];
    
    json = @{@"coordinate" : @[ @2, @2 ]};
    _validCoordinateQueryConfig = (CoordinateQueryConfiguration *)
        [QueryConfigurationFactory configWithJSON:json validator:nil];
    
    _emptyQueryConfig = [QueryConfigurationFactory configWithJSON:@{} validator:nil];
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testIsCoordinateCarriedFromConfig {
    Query *query = [QueryFactory queryWithQueryConfiguration:_validQueryConfig];
    XCTAssertFalse(query.isCoordinateQuery,
                   @"Query given %@ thinks it is a coordinate query",
                   _validQueryConfig.raw);
    
    query = [QueryFactory queryWithQueryConfiguration:_validCoordinateQueryConfig];
    XCTAssertTrue(query.isCoordinateQuery,
                  @"Query given %@ does not think it's a coordinate query",
                  _validCoordinateQueryConfig.raw);
}

- (void)testExecuteWithNoSpecifiers {

    Query *query = [QueryFactory queryWithQueryConfiguration:_emptyQueryConfig];
    expect(^{
        [query execute];
    }).to.raise(@"CBXException");
}

- (void)testToJSONString {
    Query *query = [QueryFactory queryWithQueryConfiguration:_validQueryConfig];
    expect([query toJSONString]).to.equal([JSONUtils objToJSONString:_validQueryConfig.raw]);
}

@end


#import "Query.h"
#import "CoordinateQueryConfiguration.h"
#import "Application.h"
#import "JSONUtils.h"
#import <XCTest/XCTest.h>

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
    _validCoordinateQueryConfig = [CoordinateQueryConfiguration withJSON:json validator:nil];
    
    _emptyQueryConfig = [QueryConfiguration withJSON:@{} validator:nil];
    
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

- (void)testExecuteWithNoSpecifiers {
    Query *query = [Query withQueryConfiguration:_emptyQueryConfig];
    id XCUIElementQueryMock = OCMClassMock([XCUIElementQuery class]);
    OCMStub([XCUIElementQueryMock allElementsBoundByIndex]).andReturn(@[[XCUIElement new]]);

    expect([query execute]).to.equal(nil);
}

- (void)testExecuteWithSpecifiers {
    
    id results = @[];
    
    Query *query = [Query withQueryConfiguration:_validQueryConfig];
    
    OCMStub([OCMClassMock([Application class]) currentApplication])
    .andReturn([[XCUIApplication alloc] initPrivateWithPath:nil
                                                   bundleID:@"com.apple.banana"]);

    
    expect([query execute]).to.equal(results);
    //TODO: Pair with Moody
//    id mock = OCMPartialMock([XCUIElementQuery new]);
//    OCMStub([mock allElementsBoundByIndex]).andReturn(@"banana");
//    id selectorMock = OCMPartialMock([QuerySelectorId new]);
//    OCMStub([selectorMock applyToQuery:[OCMArg any]]).andReturn(mock);
//    OCMVerify([mock allElementsBoundByIndex]);
}

- (void)testToJSONString {
    Query *query = [Query withQueryConfiguration:_validQueryConfig];
    expect([query toJSONString]).to.equal([JSONUtils objToJSONString:_validQueryConfig.raw]);
}


@end

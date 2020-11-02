#import <XCTest/XCTest.h>
#import "QueryConfiguration.h"
#import "QueryFactory.h"
#import "QuerySpecifier.h"
#import "Application.h"
#import "CBXConstants.h"
#import "XCTest+CBXAdditions.h"
#import "CBXServerUnitTestUmbrellaHeader.h"

@interface QuerySpecifierTests : XCTestCase
@end

@implementation QuerySpecifierTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testQuerySpecifierByDescendantTypeThrowsExceptionForInvalidMainKeyCase {
    id invalidJson = @{@"descendantElement": @{@"parent_type" : @"Keyboard",
                                               @"descendant_type" : @"Button"}};

    expect(^{
        [QueryConfiguration withJSON:invalidJson validator:nil];
    }).to.raise(@"InvalidArgumentException");
}

- (void)testQuerySpecifierByDescendantTypeThrowsExceptionForInvalidParentKeyCase {
    // [Set Up] Stage 0: prepare query with invalid config
    id invalidJson = @{@"descendant_element": @{@"parent_typeeeee" : @"Keyboard",
                                                @"descendant_type" : @"Button"}};
    QueryConfiguration *queryConfig = [QueryConfiguration withJSON:invalidJson validator:nil];

    Query *query = [QueryFactory queryWithQueryConfiguration:queryConfig];
    
    // [Preconditions] Stage 1: prepare mock objects for app and query
    id appMock = OCMClassMock([Application class]);
    id uiAppMock = OCMClassMock([XCUIApplication class]);

    id queryMock = OCMClassMock([XCUIElementQuery class]);
    
    // [Preconditions] Stage 1: mock methods called in [query execute]
    OCMStub([uiAppMock cbxQueryForDescendantsOfAnyType]).andReturn(queryMock);
    OCMStub([appMock currentApplication]).andReturn(uiAppMock);
    
    // [Check] Stage 2: throw Exception in case parent type key is malformed
    expect(^{
        [query execute];
    }).to.raise(@"NSInternalInconsistencyException");
}

- (void)testQuerySpecifierByDescendantTypeThrowsExceptionForInvalidDescendantKeyCase {
    // [Set Up] Stage 0: prepare query with invalid config
    id invalidJson = @{@"descendant_element": @{@"parent_type" : @"Keyboard",
                                                @"descendantType" : @"Button"}};
    QueryConfiguration *queryConfig = [QueryConfiguration withJSON:invalidJson validator:nil];

    Query *query = [QueryFactory queryWithQueryConfiguration:queryConfig];
    
    // [Preconditions] Stage 1: prepare mock objects for app and query
    id appMock = OCMClassMock([Application class]);
    id uiAppMock = OCMClassMock([XCUIApplication class]);

    id queryMock = OCMClassMock([XCUIElementQuery class]);
    
    // [Preconditions] Stage 1: mock methods called in [query execute]
    OCMStub([uiAppMock cbxQueryForDescendantsOfAnyType]).andReturn(queryMock);
    OCMStub([appMock currentApplication]).andReturn(uiAppMock);
    
    // [Check] Stage 2: throw Exception in case descendant type key is malformed
    expect(^{
        [query execute];
    }).to.raise(@"NSInternalInconsistencyException");
}

- (void)testQuerySpecifierByDescendantTypeThrowsExceptionForInvalidMissingKeyCase {
    // [Set Up] Stage 0: prepare query with invalid config
    id invalidJson = @{@"descendant_element": @{@"parent_type" : @"Keyboard" }};
    QueryConfiguration *queryConfig = [QueryConfiguration withJSON:invalidJson validator:nil];

    Query *query = [QueryFactory queryWithQueryConfiguration:queryConfig];
    
    // [Preconditions] Stage 1: prepare mock objects for app and query
    id appMock = OCMClassMock([Application class]);
    id uiAppMock = OCMClassMock([XCUIApplication class]);

    id queryMock = OCMClassMock([XCUIElementQuery class]);
    
    // [Preconditions] Stage 1: mock methods called in [query execute]
    OCMStub([uiAppMock cbxQueryForDescendantsOfAnyType]).andReturn(queryMock);
    OCMStub([appMock currentApplication]).andReturn(uiAppMock);
    
    // [Check] Stage 2: throw Exception in case missed descendant_type key
    expect(^{
        [query execute];
    }).to.raise(@"NSInternalInconsistencyException");
}

- (void)testQuerySpecifierByDescendantTypeThrowsExceptionForInvalidParentTypeValueCase {
    // [Set Up] Stage 0: prepare query with invalid config
    id invalidJson = @{@"descendant_element": @{@"parent_type" : @"UIKeyboard",
                                                @"descendant_type" : @"Button"}};
    QueryConfiguration *queryConfig = [QueryConfiguration withJSON:invalidJson validator:nil];

    Query *query = [QueryFactory queryWithQueryConfiguration:queryConfig];
    
    // [Preconditions] Stage 1: prepare mock objects for app and query
    id appMock = OCMClassMock([Application class]);
    id uiAppMock = OCMClassMock([XCUIApplication class]);

    id queryMock = OCMClassMock([XCUIElementQuery class]);
    
    // [Preconditions] Stage 1: mock methods called in [query execute]
    OCMStub([uiAppMock cbxQueryForDescendantsOfAnyType]).andReturn(queryMock);
    OCMStub([appMock currentApplication]).andReturn(uiAppMock);
    
    // [Check] Stage 2: throw Exception in case UIElement type value is invalid
    expect(^{
        [query execute];
    }).to.raise(@"CBXException");
}

- (void)testQuerySpecifierByDescendantTypeReturnsArrayOfElementsForValidCase {
    // [Set Up] Stage 0: prepare query with valid config
    id validJson = @{@"descendant_element": @{@"parent_type" : @"Keyboard",
                                              @"descendant_type" : @"Button"}};
    QueryConfiguration *queryConfig = [QueryConfiguration withJSON:validJson validator:nil];

    Query *query = [QueryFactory queryWithQueryConfiguration:queryConfig];
    
    // [Preconditions] Stage 1: prepare mock objects for app and query
    // (we want mock interactions with real app object and
    // check specific implementation of applyInternal for QuerySpecifierByDescendantType)
    id appMock = OCMClassMock([Application class]);
    id uiAppMock = OCMClassMock([XCUIApplication class]);
    id element = OCMClassMock([XCUIElement class]);
    id arrayOfElements = [NSArray arrayWithObject:element];

    id queryMock = OCMClassMock([XCUIElementQuery class]);
    id contextQueryMock = OCMClassMock([XCUIElementQuery class]);
    id resultQueryMock = OCMClassMock([XCUIElementQuery class]);
    
    // [Preconditions] Stage 1: mock methods called in [query execute]
    OCMStub([uiAppMock cbxQueryForDescendantsOfAnyType]).andReturn(queryMock);
    OCMStub([appMock currentApplication]).andReturn(uiAppMock);
    
    // [Expectations] Stage 2: set up expectations for [specifier applyInternal:query]
    // where specifier is QuerySpecifierByDescendantType
    XCUIElementType keyboard = XCUIElementTypeKeyboard;
    XCUIElementType button = XCUIElementTypeButton;
    OCMExpect([queryMock matchingType:keyboard identifier:nil]).andReturn(contextQueryMock);
    OCMExpect([contextQueryMock descendantsMatchingType:button]).andReturn(resultQueryMock);
    // [Expectations] Stage 2: set up expectations for [query execute]
    OCMExpect([resultQueryMock allElementsBoundByIndex]).andReturn(arrayOfElements);
    
    // [Test Step] Stage 3: perform test step
    [query execute];
    
    // [Check] Stage 4: verify [specifier applyInternal:query]
    OCMVerifyAll(queryMock);
    OCMVerifyAll(contextQueryMock);
    // [Check] Stage 4: verify [query execute]
    OCMVerifyAll(resultQueryMock);
}

@end

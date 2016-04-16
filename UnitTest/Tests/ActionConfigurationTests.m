
#import <XCTest/XCTest.h>
#import "ActionConfiguration.h"

@interface ActionConfigurationTests : XCTestCase
@end

@implementation ActionConfigurationTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInstantiationDoesntMutateJson {
    id json = @{};
    ActionConfiguration *config = [ActionConfiguration withJSON:json
                                                      validator:nil];
    XCTAssertEqual(config.raw, json);
}

- (void)testInstantiationValidatesInput {
    id json = @{ @"baz" : @YES };
    JSONKeyValidator *validator = [JSONKeyValidator withRequiredKeys:@[@"foo"]
                                                        optionalKeys:@[@"bar"]];
    XCTAssertThrows([ActionConfiguration withJSON:json validator:validator],
                    @"ActionConfiguration should validate json during instantiation");
}

- (void)testHasAllProvidedKeys {
    id json = @{@"foo" : @1,
                @"bar" : @2,
                @"baz" : @"Dr. Connors"};
    ActionConfiguration *config = [ActionConfiguration withJSON:json validator:nil];
    for (NSString *key in @[@"foo", @"bar", @"baz"]) {
        XCTAssertTrue([config has:key],
                      @"Config was given %@ but reports %@ is absent.",
                      json,
                      key);
    }
}

- (void)testHasNoNonProvidedKeys {
    id json = @{@"foo" : @1,
                @"bar" : @2,
                @"baz" : @"Dr. Connors"};
    ActionConfiguration *config = [ActionConfiguration withJSON:json validator:nil];
    for (NSString *key in @[@"Existential Meaning", @"A splitting headache", @"a 30 year fixed mortgage"]) {
        BOOL has = [config has:key];
        XCTAssertFalse(has,
                       @"Config was given %@ and reports it has '%@'",
                       json,
                       key);
    }
}

- (void)testDoesntMutateJsonValues {
    id json = @{@"foo" : @1,
                @"bar" : @2,
                @"baz" : @"Dr. Connors"};
    ActionConfiguration *config = [ActionConfiguration withJSON:json validator:nil];
    for (NSString *key in json) {
        XCTAssertEqual(config[key],
                       json[key],
                       @"ActionConfiguration mutated %@ into %@",
                       config[key],
                       json[key]);
    }
}

@end

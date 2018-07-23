
#import "CBXServerUnitTestUmbrellaHeader.h"
#import "CoordinateQueryConfiguration.h"

@interface CoordinateQueryConfigurationTests : XCTestCase

@end

@implementation CoordinateQueryConfigurationTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCoordinate {
    id json = @{@"coordinate" : @[@1, @2]};
    CoordinateQueryConfiguration *config = [CoordinateQueryConfiguration withJSON:json validator:nil];
    XCTAssertNotNil(config.coordinate,
                    @"CoordinateQueryConfig was given %@ but reports coordinate is nil",
                    json);
}

- (void)testCoordinates {
    id json = @{@"coordinates" : @[@[@1, @2]]};
    CoordinateQueryConfiguration *config = [CoordinateQueryConfiguration withJSON:json validator:nil];
    XCTAssertNotNil(config.coordinates,
                    @"CoordinateQueryConfig was given %@ but reports coordinates is nil",
                    json);
}

- (void)testCoordinatesAreValidatedDuringInstantiation {
    id json = @{@"coordinate" : @"banana"};
    XCTAssertThrows([CoordinateQueryConfiguration withJSON:json validator:nil],
                    @"CoordinateQueryConfig accepted %@ as valid coordinate json",
                    json);
    
    json = @{@"coordinates" : @[@"banana"]};
    XCTAssertThrows([CoordinateQueryConfiguration withJSON:json validator:nil],
                    @"CoordinateQueryConfig accepted %@ as valid coordinates json",
                    json);
}

@end

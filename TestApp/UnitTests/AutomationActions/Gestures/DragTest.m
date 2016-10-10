
#import <XCTest/XCTest.h>
#import "Drag.h"
#import "Coordinate.h"

@interface Drag (XCTEST)

+ (CGPoint)pointByApplyingHaltDistanceToCoordinate:(Coordinate *)coordinate
                                previousCoordinate:(Coordinate *)previousCoordinate;

@end

@interface DragTest : XCTestCase

@end

@implementation DragTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testHaltPoint {
    Coordinate *current, *previous;
    CGPoint actual, expected;

    current = [Coordinate fromRaw:CGPointMake(20, 20)];
    previous = [Coordinate fromRaw:CGPointMake(10, 20)];
    expected = CGPointMake(22, 20);
    actual = [Drag pointByApplyingHaltDistanceToCoordinate:current
                                        previousCoordinate:previous];
    expect(actual.x).to.equal(expected.x);
    expect(actual.y).to.equal(expected.y);

    current = [Coordinate fromRaw:CGPointMake(10, 20)];
    previous = [Coordinate fromRaw:CGPointMake(20, 20)];
    expected = CGPointMake(8, 20);
    actual = [Drag pointByApplyingHaltDistanceToCoordinate:current
                                        previousCoordinate:previous];
    expect(actual.x).to.equal(expected.x);
    expect(actual.y).to.equal(expected.y);

    current = [Coordinate fromRaw:CGPointMake(10, 20)];
    previous = [Coordinate fromRaw:CGPointMake(10, 10)];
    expected = CGPointMake(10, 22);
    actual = [Drag pointByApplyingHaltDistanceToCoordinate:current
                                        previousCoordinate:previous];
    expect(actual.x).to.equal(expected.x);
    expect(actual.y).to.equal(expected.y);

    current = [Coordinate fromRaw:CGPointMake(10, 10)];
    previous = [Coordinate fromRaw:CGPointMake(10, 20)];
    expected = CGPointMake(10, 8);
    actual = [Drag pointByApplyingHaltDistanceToCoordinate:current
                                        previousCoordinate:previous];
    expect(actual.x).to.equal(expected.x);
    expect(actual.y).to.equal(expected.y);

    // No offset is applied if x or y are the same.
    // We cannot know the direction of the drag.
    current = [Coordinate fromRaw:CGPointMake(10, 10)];
    previous = [Coordinate fromRaw:CGPointMake(10, 10)];
    expected = CGPointMake(10, 10);
    actual = [Drag pointByApplyingHaltDistanceToCoordinate:current
                                        previousCoordinate:previous];
    expect(actual.x).to.equal(expected.x);
    expect(actual.y).to.equal(expected.y);
}

@end

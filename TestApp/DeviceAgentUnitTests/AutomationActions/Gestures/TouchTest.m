
#import "CBXServerUnitTestUmbrellaHeader.h"
#import "Touch.h"
#import "Coordinate.h"
#import "GestureFactory.h"
#import "CBXConstants.h"

@interface Touch (CBXTESTS)

+ (NSArray <Coordinate *> *)fingerCoordinatesWithCenter:(CGPoint)point
                                                fingers:(NSUInteger)fingers;
@end

@interface TouchTest : XCTestCase

@end

@implementation TouchTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testInvalidCoordinatesKey {
   id  json = @{
                @"gesture" : @"touch",
                @"specifiers" : @{
                        @"coordinates" :  @[ @[ @50, @50 ], @[ @40, @40]],
                        },
                };
    expect(^{
        [GestureFactory executeGestureWithJSON:json completion:^(NSError *e) {
            XCTAssertNil(e, @"Error executing gesture with json: %@, %@", e, json);
        }];
    }).to.raise(@"InvalidArgumentException");
}

- (void)testInvalidNumberOfFingers {
   id  json = @{
                @"gesture" : @"touch",
                @"specifiers" : @{
                        @"coordinate" :  @[ @50, @50 ],
                        },
                @"options" : @{
                        @"num_fingers" : @5
                        }
                };
    expect(^{
        [GestureFactory executeGestureWithJSON:json completion:^(NSError *e) {
            XCTAssertNil(e, @"Error executing gesture with json: %@, %@", e, json);
        }];
    }).to.raise(@"InvalidArgumentException");
}

- (void)testOneFingerTouchCoordinates {
    CGPoint point = CGPointMake(0,0);
    NSArray *actual = [Touch fingerCoordinatesWithCenter:point
                                                 fingers:1];
    expect(actual.count).to.equal(1);
    Coordinate *coordinate = actual[0];
    expect(coordinate.cgpoint.x).to.equal(point.x);
    expect(coordinate.cgpoint.y).to.equal(point.y);
}

- (void)testTwoFingerTouchCoordinates {
    CGPoint point = CGPointMake(0,0);
    NSArray *actual = [Touch fingerCoordinatesWithCenter:point
                                                 fingers:2];
    expect(actual.count).to.equal(2);
    Coordinate *coordinate;
    coordinate = actual[0];
    expect(coordinate.cgpoint.x).to.equal(point.x - (CBX_FINGER_WIDTH/2.0));
    expect(coordinate.cgpoint.y).to.equal(point.y);

    coordinate = actual[1];
    expect(coordinate.cgpoint.x).to.equal(point.x + (CBX_FINGER_WIDTH/2.0));
    expect(coordinate.cgpoint.y).to.equal(point.y);
}

- (void)testThreeFingerTouchCoordinates {
    CGPoint point = CGPointMake(0,0);
    NSArray *actual = [Touch fingerCoordinatesWithCenter:point
                                                 fingers:3];
    expect(actual.count).to.equal(3);
    Coordinate *coordinate;
    coordinate = actual[0];
    expect(coordinate.cgpoint.x).to.equal(point.x - CBX_FINGER_WIDTH);
    expect(coordinate.cgpoint.y).to.equal(point.y);

    coordinate = actual[1];
    expect(coordinate.cgpoint.x).to.equal(point.x);
    expect(coordinate.cgpoint.y).to.equal(point.y);

    coordinate = actual[2];
    expect(coordinate.cgpoint.x).to.equal(point.x + CBX_FINGER_WIDTH);
    expect(coordinate.cgpoint.y).to.equal(point.y);
}

- (void)testFourFingerTouchCoordinates {
    CGPoint point = CGPointMake(0,0);
    NSArray *actual = [Touch fingerCoordinatesWithCenter:point
                                                 fingers:4];
    expect(actual.count).to.equal(4);
    Coordinate *coordinate;
    coordinate = actual[0];
    expect(coordinate.cgpoint.x).to.equal(point.x - (CBX_FINGER_WIDTH +
                                                     (CBX_FINGER_WIDTH/2.0)));
    expect(coordinate.cgpoint.y).to.equal(point.y);

    coordinate = actual[1];
    expect(coordinate.cgpoint.x).to.equal(point.x - (CBX_FINGER_WIDTH/2.0));
    expect(coordinate.cgpoint.y).to.equal(point.y);

    coordinate = actual[2];
    expect(coordinate.cgpoint.x).to.equal(point.x + (CBX_FINGER_WIDTH/2.0));
    expect(coordinate.cgpoint.y).to.equal(point.y);

    coordinate = actual[3];
    expect(coordinate.cgpoint.x).to.equal(point.x + (CBX_FINGER_WIDTH +
                                                     (CBX_FINGER_WIDTH/2.0)));
    expect(coordinate.cgpoint.y).to.equal(point.y);
}

- (void)testTooManyFingersPassedToTouchCoordinates {
    CGPoint point = CGPointMake(0,0);
    expect(^{
        [Touch fingerCoordinatesWithCenter:point
                                   fingers:5];
    }).to.raise(@"InvalidArgumentException");
}

@end

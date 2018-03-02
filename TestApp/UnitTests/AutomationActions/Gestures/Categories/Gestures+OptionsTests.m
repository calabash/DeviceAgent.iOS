
#import <XCTest/XCTest.h>
#import "QueryConfiguration.h"
#import "GestureConfiguration.h"
#import "JSONKeyValidator.h"
#import "CBXConstants.h"
#import "QueryConfigurationFactory.h"
#import "Gesture+Options.h"
#import "QueryFactory.h"
#import "EnterTextIn.h"
#import "EnterText.h"
#import "DoubleTap.h"
#import "Rotate.h"
#import "Touch.h"
#import "Pinch.h"
#import "Drag.h"

@interface Gestures_OptionsTests : XCTestCase
@property (nonatomic, strong) GestureConfiguration *emptyConfig;
@property (nonatomic, strong) Gesture *empty;
@end

@implementation Gestures_OptionsTests

- (void)setUp {
    [super setUp];
    _emptyConfig = [GestureConfiguration withJSON:@{ } validator:nil];
    _empty = [Gesture withGestureConfiguration:_emptyConfig query:nil];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#define EPSILON 0.01
- (void)testGestureWithJSON:(id)json gestureClass:(Class<Gesture>)gestureClass {
    XCTAssertEqual([gestureClass name], json[@"gesture"], @"You wrote your test wrong!");

    GestureConfiguration *config = [GestureConfiguration withJSON:json[@"options"]
                                                        validator:[gestureClass validator]];
    
    QueryConfiguration *queryConfig = [QueryConfigurationFactory configWithJSON:json[@"specifiers"]
                                                                      validator:[Query validator]];
    
    Query *query = [QueryFactory queryWithQueryConfiguration:queryConfig];
    Gesture *g = [gestureClass executeWithGestureConfiguration:config
                                                         query:query
                                                    completion:^(NSError *e){}];
    
    XCTAssertEqualWithAccuracy([g pinchAmount],
                               [config has:CBX_PINCH_AMOUNT_KEY] ?
                               [config[CBX_PINCH_AMOUNT_KEY] floatValue] :
                               [_empty pinchAmount],
                               EPSILON);
    
    XCTAssertEqualWithAccuracy([g degrees],
                               [config has:CBX_DEGREES_KEY] ?
                               [config[CBX_DEGREES_KEY] floatValue] :
                               [_empty degrees],
                               EPSILON);
    
    XCTAssertEqualWithAccuracy([g duration],
                               [config has:CBX_DURATION_KEY] ?
                               [config[CBX_DURATION_KEY] floatValue] :
                               CBX_DEFAULT_DURATION,
                               EPSILON);
    
    XCTAssertEqualWithAccuracy([g repetitions],
                               [config has:CBX_REPETITIONS_KEY] ?
                               [config[CBX_REPETITIONS_KEY] intValue] :
                               [_empty repetitions],
                               EPSILON);
    
    XCTAssertEqualWithAccuracy([g rotationStart],
                               [config has:CBX_ROTATION_START_KEY] ?
                               [config[CBX_ROTATION_START_KEY] floatValue] :
                               [_empty rotationStart],
                               EPSILON);
    
    XCTAssertEqualWithAccuracy([g rotateDuration],
                               [config has:CBX_DURATION_KEY] ?
                               [config[CBX_DURATION_KEY] floatValue] :
                               [_empty rotateDuration],
                               EPSILON);
    
    XCTAssertEqualWithAccuracy([g radius],
                               [config has:CBX_RADIUS_KEY] ?
                               [config[CBX_RADIUS_KEY] floatValue] :
                               [_empty radius],
                               EPSILON);
    
    XCTAssertEqual([g rotateDirection],
                   [config has:CBX_ROTATION_DIRECTION_KEY] ?
                   config[CBX_ROTATION_DIRECTION_KEY] :
                   [_empty rotateDirection]);
    
    XCTAssertEqual([g pinchDirection],
                   [config has:CBX_PINCH_DIRECTION_KEY] ?
                   config[CBX_PINCH_DIRECTION_KEY] :
                   [_empty pinchDirection]);
    
}

- (void)testDoubleTap {
    id json = @{
                @"gesture" : @"double_tap",
                @"specifiers" : @{
                        @"coordinate" :  @[ @50, @50 ]
                        },
                @"options" : @{
                        @"duration" : @0.1
                        }
                };
    [self testGestureWithJSON:json gestureClass:[DoubleTap class]];
}

- (void)testTouch {
    id json = @{
                @"gesture" : @"touch",
                @"specifiers" : @{
                        @"coordinate" :  @[ @50, @50 ]
                        },
                @"options" : @{
                        @"duration" : @(CBX_DEFAULT_DURATION)
                        }
                };
    [self testGestureWithJSON:json gestureClass:[Touch class]];
}

- (void)testDrag {
    id json = @{
                @"gesture" : @"drag",
                @"specifiers" : @{
                        @"coordinates" :  @[ @[@50, @50], @[@60, @60], @[@70, @70] ]
                        },
                @"options" : @{
                        @"duration" : @0.1,
                        @"num_fingers" : @1
                        }
                };
    [self testGestureWithJSON:json gestureClass:[Drag class]];
}

- (void)testPinch {
    id json = @{
                @"gesture" : @"pinch",
                @"specifiers" : @{
                        @"coordinate" :  @[ @50, @50 ]
                        },
                @"options" : @{
                        @"duration" : @0.1,
                        @"pinch_direction" : @"out",
                        @"amount" : @100
                        }
                };
    [self testGestureWithJSON:json gestureClass:[Pinch class]];
}

- (void)testRotate {
    id json = @{
                @"gesture" : @"rotate",
                @"specifiers" : @{
                        @"coordinate" :  @[ @50, @50 ]
                        },
                @"options" : @{
                        @"duration" : @0.1,
                        @"rotation_direction" : @"clockwise",
                        @"degrees" : @180,
                        @"rotation_start" : @90,
                        @"radius" : @90
                        }
                };
    [self testGestureWithJSON:json gestureClass:[Rotate class]];
}

@end

//
//  GestureFactoryTests.m
//  DeviceAgent
//
//  Created by Алан Максвелл on 19.10.2021.
//  Copyright © 2021 Calabash. All rights reserved.
//
#import "CBXServerUnitTestUmbrellaHeader.h"
#import "GestureFactory.h"
#import "EnterText.h"
#import "DoubleTap.h"
#import "Rotate.h"
#import "Touch.h"
#import "Pinch.h"
#import "Drag.h"

#import "CBXOrientation.h"

#import <XCTest/XCTest.h>


@interface GestureFactoryTests : XCTestCase
@property (nonatomic, strong) NSArray <NSDictionary *> *validJSON;
@property (nonatomic, strong) NSArray <NSDictionary *> *invalidJSON;
@end

@implementation GestureFactoryTests

- (void)assertJSON:(id)json hasAllRequired:(NSArray *)required andOptional:(NSArray *)optional {
    NSMutableArray *all = [NSMutableArray array];
    [all addObjectsFromArray:required];
    [all addObjectsFromArray:optional];
    
    for (id thing in all) {
        XCTAssert([[json allKeys] containsObject:thing], @"JSON didn't contain object: %@", thing);
    }
}

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _validJSON = @[
                   @{
                       @"gesture" : @"touch",
                       @"specifiers" : @{ @"coordinate" : @[ @50, @50 ] }
                     },
                   @{
                       @"gesture" : @"enter_text",
                       @"specifiers" : @{},
                       @"options" : @{ @"string" : @"banana" }
                       },
                   @{
                       @"gesture" : @"double_tap",
                       @"specifiers" : @{ @"coordinate" : @[ @50, @50 ] },
                       },
                   @{
                       @"gesture" : @"drag",
                       @"specifiers" : @{ @"coordinates" : @[ @[@50, @50], @[ @60, @60 ]] },
                       },
                   @{
                       @"gesture" : @"pinch",
                       @"specifiers" : @{ @"coordinate" : @[ @50, @50 ] },
                       },
                   @{
                       @"gesture" : @"rotate",
                       @"specifiers" : @{ @"coordinate" : @[ @50, @50 ] },
                       }
                   ];
    
    _invalidJSON = @[
                    @{
                        @"gesture" : @"touch",
                        },
                    @{
                        @"gesture" : @"enter_text",
                        @"specifiers" : @{ @"banana" : @"yeah" },
                        @"options" : @{ @"string" : @"banana" }
                        },
                    @{
                        @"gesture" : @"double_tap"
                        },
                    @{
                        @"gesture" : @"drag",
                        @"specifiers" : @{ @"coordinate" : @[ @[@50, @50], @[ @60, @60 ]] },
                        },
                    @{
                        @"gesture" : @"pinch"
                        },
                    @{
                        @"gesture" : @"rotate"
                        },
                    @{
                        @"banana" : @"man"
                        }
                    ];
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;

    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];

    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    
}

- (void)testTouch {
    id json = @{
                @"gesture" : @"touch",
                @"specifiers" : @{
                        @"coordinate" :  @[ @50, @50 ]
                        },
                @"options" : @{
                        @"duration" : @0.2,
                        @"repetitions" : @2,
                        @"num_fingers" : @1
                        }
                };
    
//    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: UIDeviceOrientationLandscapeLeft] forKey:@"orientation"];
    //Failed to set device orientation: Not authorized for performing UI testing actions.
    [XCUIDevice sharedDevice].orientation = UIDeviceOrientationPortrait;
    
    //Not authorized for performing UI testing actions
    [self expectGestureWithJSON:json gestureClass:[Touch class]];

    [XCUIDevice sharedDevice].orientation = UIDeviceOrientationPortrait;
//    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: UIDeviceOrientationLandscapeLeft] forKey:@"orientation"];

    [self expectGestureWithJSON:json gestureClass:[Touch class]];
}

- (void)expectGestureWithJSON:(id)json gestureClass:(Class<Gesture>)gestureClass {
    XCTAssertEqual([gestureClass name], json[@"gesture"], @"You wrote your test wrong!");
    [self assertJSON:json[@"options"]
      hasAllRequired:[gestureClass requiredKeys]
         andOptional:[gestureClass optionalKeys]];
    
    [GestureFactory executeGestureWithJSON:json completion:^(NSError *e) {
        XCTAssertNil(e, @"Error executing gesture with json: %@, %@", e, json);
    }];
}


- (void)tearDown {
    [super tearDown];
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

@end

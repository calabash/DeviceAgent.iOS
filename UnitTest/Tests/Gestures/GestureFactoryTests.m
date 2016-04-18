
#import <XCTest/XCTest.h>
#import "GestureFactory.h"
#import "EnterText.h"

@interface GestureFactoryTests : XCTestCase
@property (nonatomic, strong) NSArray <NSDictionary *> *validJSON;
@property (nonatomic, strong) NSArray <NSDictionary *> *invalidJSON;
@end

@implementation GestureFactoryTests

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
                       @"gesture" : @"enter_text_in",
                       @"specifiers" : @{ @"coordinate" : @[ @50, @50 ] },
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
                        @"gesture" : @"enter_text_in",
                        @"specifiers" : @{ @"coordinates" : @[ @50, @50 ] },
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
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testValidJSON {
    dispatch_queue_t queue = dispatch_get_current_queue();
    NSMutableArray *complete = [NSMutableArray array];
    for (NSDictionary *json in _validJSON) {
        [GestureFactory executeGestureWithJSON:json completion:^(NSError *e) {
            XCTAssert(queue == dispatch_get_current_queue(),
                      @"Completion block run on a different queue for %@!",
                      json[@"gesture"]);
            [complete addObject:json];
        }];
    }
    XCTAssertEqual(complete.count, _validJSON.count, @"Not all of the valid gestures were completed.");
}

- (void)testInvalidJSON {
    dispatch_queue_t queue = dispatch_get_current_queue();
    NSMutableArray *complete = [NSMutableArray array];
    for (NSDictionary *json in _invalidJSON) {
        
        XCTAssertThrows([GestureFactory executeGestureWithJSON:json completion:^(NSError *e) {
            XCTAssert(queue == dispatch_get_current_queue(),
                      @"Completion block run on a different queue for %@!",
                      json[@"gesture"]);
            [complete addObject:json];
        }]);
    }
}

- (void)assertJSON:(id)json hasAllRequired:(NSArray *)required andOptional:(NSArray *)optional {
    NSMutableArray *all = [NSMutableArray array];
    [all addObjectsFromArray:required];
    [all addObjectsFromArray:optional];
    
    for (id thing in all) {
        XCTAssert([json containsObject:thing], @"JSON didn't containt object: %@", thing);
    }
}

- (void)testEnterText {
    id json = @{
                @"gesture" : @"enter_text",
                @"options" : @{
                            @"string"  : @"banana"
                        }
                };
    [self assertJSON:json
      hasAllRequired:[EnterText requiredKeys]
         andOptional:[EnterText optionalKeys]];
    
    [GestureFactory executeGestureWithJSON:json completion:^(NSError *e) {
        XCTAssertNil(e, @"Error executing gesture with json: %@, %@", e, json);
    }];
}

@end

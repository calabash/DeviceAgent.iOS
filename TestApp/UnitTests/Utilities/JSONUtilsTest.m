#import <XCTest/XCTest.h>
#import "JSONUtils.h"
#import "XCUICoordinate.h"
#import "XCUIElement.h"
#import "CBXConstants.h"

@interface XCUICoordinate (CBXTEST)

- (id)initForTesting;

@end

@implementation XCUICoordinate (CBXTEST)

- (id)initForTesting {
    self = [super init];
    if (self) {

    }
    return self;
}

@end

@interface JSONUtils (CBXTEST)

+ (NSDictionary *)elementHitPointToJSON:(XCUIElement *)element;
+ (BOOL)elementHitable:(XCUIElement *)element;

@end

@interface JSONUtilsTest : XCTestCase

@end

@implementation JSONUtilsTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

@end

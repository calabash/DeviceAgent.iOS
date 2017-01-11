#import <XCTest/XCTest.h>
#import "EnterText.h"

@interface EnterText (CBXTest)

+ (NSArray<NSString *> *)arrayOfStringsByChunkingString:(NSString *)string
                                                 length:(NSUInteger)chunkLength;

@end

@interface EnterTextTest : XCTestCase

@end

@implementation EnterTextTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testArrayOfStringsByChunking {
    NSUInteger chunkLength = 3;
    NSString *string;
    NSArray *actual, *expected;

    string = @"abcdefghi";

    actual = [EnterText arrayOfStringsByChunkingString:string
                                                length:chunkLength];
    expected = @[@"abc", @"def", @"ghi"];

    expect(actual.count).to.equal(3);
    expect(expected.count).to.equal(3);
    expect(actual).to.beSupersetOf(expected);

    chunkLength = 2;

    actual = [EnterText arrayOfStringsByChunkingString:string
                                                length:chunkLength];
    expected = @[@"ab", @"cd", @"ef", @"gh", @"i"];

    expect(actual.count).to.equal(5);
    expect(expected.count).to.equal(5);
    expect(actual).to.beSupersetOf(expected);
}

@end

#import <XCTest/XCTest.h>
#import "JSONUtils.h"

@interface JSONUtils (CBXTEST)

+ (NSNumber *)normalizeFloat:(CGFloat)cgFloat;

@end

@interface JSONUtilsTest : XCTestCase

@end

@implementation JSONUtilsTest

@end

SpecBegin(JSONUtilsTest)

describe(@"normalizeFloat:", ^{
    it(@"returns a rounded NSInteger if finite", ^{
        CGFloat value = 44.445888;
        NSNumber *number = [JSONUtils normalizeFloat:value];
        expect([number integerValue]).to.equal(44);
    });

    it(@"returns INT32_MAX if infinite and INFINITY", ^{
        CGFloat value = INFINITY;
        NSNumber *number = [JSONUtils normalizeFloat:value];
        expect(number).to.equal(@(INT32_MAX));
    });

    it(@"returns INT32_MIN if infinite and -INFINITY", ^{
        CGFloat value = -INFINITY;
        NSNumber *number = [JSONUtils normalizeFloat:value];
        expect(number).to.equal(@(INT32_MIN));
    });

    it(@"returns INT32_MAX if it is float max", ^{
        CGFloat value = CGFLOAT_MAX;
        NSNumber *number = [JSONUtils normalizeFloat:value];
        expect(number).to.equal(@(INT32_MAX));
    });

    it(@"returns INT32_MIN if it is float min", ^{
        CGFloat value = CGFLOAT_MIN;
        NSNumber *number = [JSONUtils normalizeFloat:value];
        expect(number).to.equal(@(INT32_MIN));
    });
});

SpecEnd

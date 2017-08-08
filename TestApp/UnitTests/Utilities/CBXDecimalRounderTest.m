
#import "CBXDecimalRounder.h"

@interface CBXDecimalRounderTest : XCTestCase

@end

@implementation CBXDecimalRounderTest

@end

SpecBegin(CBXDecimalRounder)

describe(@"CBXDecimalRounder", ^{

    __block CBXDecimalRounder *rounder;
    __block CGFloat toRound;
    __block CGFloat rounded;

    before(^{
        rounder = [CBXDecimalRounder new];
    });

    it(@"#round:", ^{
        toRound = 44.445888;
        rounded = [rounder round:toRound];
        expect(rounded).to.beCloseToWithin(44.45, 0.001);

        toRound = 44.444888;
        rounded = [rounder round:toRound];
        expect(rounded).to.beCloseToWithin(44.44, 0.001);
    });

    it(@"#round:withScale:", ^{
        toRound = 44.445888;
        rounded = [rounder round:toRound withScale:1];
        expect(rounded).to.beCloseToWithin(44.4, 0.01);

        rounded = [rounder round:toRound withScale:3];
        expect(rounded).to.beCloseToWithin(44.446, 0.0001);

        rounded = [rounder round:toRound withScale:4];
        expect(rounded).to.beCloseToWithin(44.4459, 0.00001);
    });

    it(@"#integerByRounding:", ^{
        toRound = 44.44588;
        NSInteger actual = [rounder integerByRounding:toRound];
        expect(actual).to.equal(44);

        toRound = 44.5;
        actual = [rounder integerByRounding:toRound];
        expect(actual).to.equal(45);
    });
});
SpecEnd

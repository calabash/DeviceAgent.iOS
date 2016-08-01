#import "CBXiOSVersionInlines.h"

@interface CBXiOSVersionInlinesTest : XCTestCase

@end

@implementation CBXiOSVersionInlinesTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

// Do inlining and dispatch_once help performance?  Yes.

// 0.133 seconds
//- (void)testPerformanceNotInlined {
//  // This is an example of a performance test case.
//  [self measureBlock:^{
//    for (NSInteger i = 0; i < 100000; i++) {
//      [[UIDevice currentDevice] systemVersion];
//    }
//  }];
//}

// 0.005 seconds
//- (void)testPerformanceInlined {
//  // This is an example of a performance test case.
//  [self measureBlock:^{
//    for (NSInteger i = 0; i < 100000; i++) {
//      lp_sys_version();
//    }
//  }];
//}

@end

SpecBegin(CBXiOSVersionInlines)

describe(@"CBXiOSVersionInlines", ^{
    it(@"iOS version", ^{
        expect(cbx_sys_version()).notTo.equal(nil);
    });

    it(@"==", ^{
        expect(cbx_ios_version_eql(@"some version")).to.equal(NO);
        expect(cbx_ios_version_eql([[UIDevice currentDevice] systemVersion])).to.equal(YES);
    });

    it(@">", ^{
        expect(cbx_ios_version_gt(@"1.0")).to.equal(YES);
        expect(cbx_ios_version_gt(@"100.0")).to.equal(NO);
    });

    it(@">=", ^{
        expect(cbx_ios_version_gte(@"1.0")).to.equal(YES);
        expect(cbx_ios_version_gte(@"100.0")).to.equal(NO);
    });

    it(@"<", ^{
        expect(cbx_ios_version_lt(@"100.0")).to.equal(YES);
        expect(cbx_ios_version_lt(@"1.0")).to.equal(NO);
    });

    it(@"<=", ^{
        expect(cbx_ios_version_lte(@"100.0")).to.equal(YES);
        expect(cbx_ios_version_lte(@"1.0")).to.equal(NO);
    });
});

SpecEnd

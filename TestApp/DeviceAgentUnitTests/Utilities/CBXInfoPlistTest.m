
#import "CBXServerUnitTestUmbrellaHeader.h"
#import "CBXInfoPlist.h"

@interface CBXInfoPlist (CBXTEST)

- (NSDictionary *)infoDictionary;
- (NSString *)stringForKey:(NSString *) key;

@end

@interface CBXInfoPlistTest : XCTestCase

@end

@implementation CBXInfoPlistTest

- (void) setUp {
    [super setUp];
}

- (void) tearDown {
    [super tearDown];
}

@end

SpecBegin(CBXInfoPlist)

describe(@"CBXInfoPlist", ^{
    __block CBXInfoPlist *infoPlist;

    beforeEach(^{
        infoPlist = [CBXInfoPlist new];
    });

    it(@"#infoDictionary", ^{
        id mainBundleMock = [OCMockObject partialMockForObject:[NSBundle mainBundle]];
        [[[mainBundleMock expect] andReturn:@{@"key" : @"value"}] infoDictionary];
        NSDictionary *actual = [infoPlist infoDictionary];
        expect(actual[@"key"]).to.equal(@"value");
        [mainBundleMock verify];
        [mainBundleMock stopMocking];
    });

    describe(@"#stringForKey:", ^{

        it(@"returns the value of the key from the Info.plist", ^{
            id mockInfoPlist = OCMPartialMock(infoPlist);
            NSDictionary *dictionary = @{@"key" : @"value"};
            OCMExpect([mockInfoPlist infoDictionary]).andReturn(dictionary);

            expect([infoPlist stringForKey:@"key"]).to.equal(@"value");

            OCMVerify(mockInfoPlist);
        });

        it(@"returns an empty string if the key is missing in the Info.plist", ^{
            id mockInfoPlist = OCMPartialMock(infoPlist);
            NSDictionary *dictionary = @{};
            OCMExpect([mockInfoPlist infoDictionary]).andReturn(dictionary);

            expect([infoPlist stringForKey:@"key"]).to.equal(@"");

            OCMVerify(mockInfoPlist);
        });
    });

    describe(@"Accessing Info.plist Keys", ^{
        __block id infoMock;
        __block NSDictionary *mockedPlist;

        beforeEach(^{
            infoMock = [OCMockObject partialMockForObject:infoPlist];
        });

        afterEach(^{
            [infoMock verify];
            [infoMock stopMocking];
        });

        describe(@"CFBundleName", ^{
            it(@"value exists", ^{
                mockedPlist = @{@"CFBundleName" : @"foo"};
                [[[infoMock expect] andReturn:mockedPlist] infoDictionary];
                expect([infoMock bundleName]).to.equal(@"foo");
            });

            it(@"value does not exist", ^{
                [[[infoMock expect] andReturn:@{}] infoDictionary];
                expect([infoMock bundleName]).to.beEmpty();
            });
        });

        describe(@"CFBundleIdentifier", ^{
            it(@"value exists", ^{
                mockedPlist = @{@"CFBundleIdentifier" : @"foo"};
                [[[infoMock expect] andReturn:mockedPlist] infoDictionary];
                expect([infoMock bundleIdentifier]).to.equal(@"foo");
            });

            it(@"value does not exist", ^{
                [[[infoMock expect] andReturn:@{}] infoDictionary];
                expect([infoMock bundleIdentifier]).to.beEmpty();
            });
        });

        describe(@"CFBundleVersion", ^{
            it(@"value exists", ^{
                mockedPlist = @{@"CFBundleVersion" : @"foo"};
                [[[infoMock expect] andReturn:mockedPlist] infoDictionary];
                expect([infoMock bundleVersion]).to.equal(@"foo");
            });

            it(@"value does not exist", ^{
                [[[infoMock expect] andReturn:@{}] infoDictionary];
                expect([infoMock bundleVersion]).to.beEmpty();
            });
        });

        describe(@"CFBundleShortVersionString", ^{
            it(@"value exists", ^{
                mockedPlist = @{@"CFBundleShortVersionString" : @"foo"};
                [[[infoMock expect] andReturn:mockedPlist] infoDictionary];
                expect([infoMock bundleShortVersion]).to.equal(@"foo");
            });

            it(@"value does not exist", ^{
                [[[infoMock expect] andReturn:@{}] infoDictionary];
                expect([infoMock bundleShortVersion]).to.beEmpty();
            });
        });

        describe(@"DTPlatformVersion", ^{
            it(@"value exists", ^{
                mockedPlist = @{@"DTPlatformVersion" : @"foo"};
                [[[infoMock expect] andReturn:mockedPlist] infoDictionary];
                expect([infoMock platformVersion]).to.equal(@"foo");
            });

            it(@"value does not exist", ^{
                [[[infoMock expect] andReturn:@{}] infoDictionary];
                expect([infoMock platformVersion]).to.beEmpty();
            });
        });

        describe(@"DTXcode", ^{
            it(@"value exists", ^{
                mockedPlist = @{@"DTXcode" : @"foo"};
                [[[infoMock expect] andReturn:mockedPlist] infoDictionary];
                expect([infoMock xcodeVersion]).to.equal(@"foo");
            });

            it(@"value does not exist", ^{
                [[[infoMock expect] andReturn:@{}] infoDictionary];
                expect([infoMock xcodeVersion]).to.beEmpty();
            });
        });

        describe(@"MinimumOSVersion", ^{
            it(@"value exists", ^{
                mockedPlist = @{@"MinimumOSVersion" : @"foo"};
                [[[infoMock expect] andReturn:mockedPlist] infoDictionary];
                expect([infoMock minimumOSVersion]).to.equal(@"foo");
            });

            it(@"value does not exist", ^{
                [[[infoMock expect] andReturn:@{}] infoDictionary];
                expect([infoMock minimumOSVersion]).to.beEmpty();
            });
        });

    });

    describe(@"versionInfo", ^{
        it(@"returns CFBundleVersion, CBBundleShortVersionString, and other information", ^{
            id mockPlist = OCMPartialMock(infoPlist);
            OCMExpect([mockPlist bundleVersion]).andReturn(@"5555");
            OCMExpect([mockPlist bundleShortVersion]).andReturn(@"1.0.0");
            OCMExpect([mockPlist bundleName]).andReturn(@"CBX");
            OCMExpect([mockPlist bundleIdentifier]).andReturn(@"com.example.CBX");
            OCMExpect([mockPlist platformVersion]).andReturn(@"10.3");
            OCMExpect([mockPlist xcodeVersion]).andReturn(@"8.3");
            OCMExpect([mockPlist minimumOSVersion]).andReturn(@"9.1");

            NSDictionary *expected =
            @{
              @"bundle_version" : @"5555",
              @"bundle_short_version" : @"1.0.0",
              @"bundle_name" : @"CBX",
              @"bundle_identifier" : @"com.example.CBX",
              @"platform_version" : @"10.3",
              @"xcode_version" : @"8.3",
              @"minimum_os_version" : @"9.1"
              };

            expect([mockPlist versionInfo]).to.equal(expected);
            OCMVerify(mockPlist);
        });
    });
});

SpecEnd


#import "CBXServerUnitTestUmbrellaHeader.h"
#import "Application.h"
#import "CBXDevice.h"

@interface Application (CBXTEST)

+ (NSDictionary *)launchEnvironmentWithEnvArg:(NSDictionary *)environmentArg;
+ (BOOL)iOSVersionIsBetween103And14;
+ (BOOL)iOSVersionIsAtLeast14;

@end

@interface ApplicationTest : XCTestCase

@end

@implementation ApplicationTest

- (void)testiOSVersionIsAtLeast103_933 {
    id deviceMock = OCMPartialMock([CBXDevice sharedDevice]);

    OCMExpect([deviceMock iOSVersion]).andReturn(@"9.3.3");
    expect([Application iOSVersionIsBetween103And14]).to.equal(NO);
    OCMVerifyAll(deviceMock);
}

- (void)testiOSVersionIsAtLeast103_100 {
    id deviceMock = OCMPartialMock([CBXDevice sharedDevice]);

    OCMExpect([deviceMock iOSVersion]).andReturn(@"10.0");
    expect([Application iOSVersionIsBetween103And14]).to.equal(NO);
    OCMVerifyAll(deviceMock);
}

- (void)testiOSVersionIsAtLeast103_102 {
    id deviceMock = OCMPartialMock([CBXDevice sharedDevice]);

    OCMExpect([deviceMock iOSVersion]).andReturn(@"10.2");
    expect([Application iOSVersionIsBetween103And14]).to.equal(NO);
    OCMVerifyAll(deviceMock);
}

- (void)testiOSVersionIsAtLeast103_103 {
    id deviceMock = OCMPartialMock([CBXDevice sharedDevice]);

    OCMExpect([deviceMock iOSVersion]).andReturn(@"10.3");
    expect([Application iOSVersionIsBetween103And14]).to.equal(YES);
    OCMVerifyAll(deviceMock);
}

- (void)testiOSVersionIsAtLeast103_104 {
    id deviceMock = OCMPartialMock([CBXDevice sharedDevice]);

    OCMExpect([deviceMock iOSVersion]).andReturn(@"10.4");
    expect([Application iOSVersionIsBetween103And14]).to.equal(YES);
    OCMVerifyAll(deviceMock);
}

- (void)testiOSVersionIsAtLeast103_110 {
    id deviceMock = OCMPartialMock([CBXDevice sharedDevice]);

    OCMExpect([deviceMock iOSVersion]).andReturn(@"11.0");
    expect([Application iOSVersionIsBetween103And14]).to.equal(YES);
    OCMVerifyAll(deviceMock);
}

- (void)testiOSVersionIsAtLeast103_140 {
    id deviceMock = OCMPartialMock([CBXDevice sharedDevice]);

    OCMExpect([deviceMock iOSVersion]).andReturn(@"14.0");
    expect([Application iOSVersionIsBetween103And14]).to.equal(NO);
    OCMVerifyAll(deviceMock);
}

- (void)testiOSVersionIsAtLeast14_110 {
    id deviceMock = OCMPartialMock([CBXDevice sharedDevice]);

    OCMExpect([deviceMock iOSVersion]).andReturn(@"11.0");
    expect([Application iOSVersionIsAtLeast14]).to.equal(NO);
    OCMVerifyAll(deviceMock);
}

- (void)testiOSVersionIsAtLeast14_140 {
    id deviceMock = OCMPartialMock([CBXDevice sharedDevice]);

    OCMExpect([deviceMock iOSVersion]).andReturn(@"14.0");
    expect([Application iOSVersionIsAtLeast14]).to.equal(YES);
    OCMVerifyAll(deviceMock);
}

- (void)testiOSVersionIsAtLeast14_141 {
    id deviceMock = OCMPartialMock([CBXDevice sharedDevice]);

    OCMExpect([deviceMock iOSVersion]).andReturn(@"14.1");
    expect([Application iOSVersionIsAtLeast14]).to.equal(YES);
    OCMVerifyAll(deviceMock);
}

@end

SpecBegin(ApplicationTest)

describe(@"launchEnvironmentWithEnvArg:", ^{
    __block NSDictionary *actual;
    __block NSDictionary *expected;
    __block id AppMock;
    __block NSString *key = @"DYLD_INSERT_LIBRARIES";
    __block NSString *bootstrap = @"/Developer/usr/lib/libXCTTargetBootstrapInject.dylib";

    describe(@"iOS < 10.3", ^{
        beforeEach(^{
            AppMock = OCMClassMock([Application class]);
            OCMExpect([AppMock iOSVersionIsBetween103And14]).andReturn(NO);
        });

        it(@"returns an empty dictionary when arg is nil", ^{
            actual = [Application launchEnvironmentWithEnvArg:nil];

            expect(actual.count).to.equal(0);
        });

        it(@"returns arg when the arg in not nil", ^{
            expected = @{@"a" : @(1)};
            actual = [Application launchEnvironmentWithEnvArg:expected];

            expect(actual).to.beIdenticalTo(expected);
        });
    });

    describe(@"iOS >= 10.3 && iOS < 14.0", ^{
        beforeEach(^{
            AppMock = OCMClassMock([Application class]);
            OCMExpect([AppMock iOSVersionIsBetween103And14]).andReturn(YES);
        });

        it(@"returns dict w/ DYLD_INSERT_LIBS key/value pair when env arg is nil", ^{
            actual = [Application launchEnvironmentWithEnvArg:nil];

            expect(actual.count).to.equal(1);
            expect(actual[key]).to.equal(bootstrap);
        });

        it(@"returns dict w/ DYLD_INSERT_LIBS key/value pair when env arg is empty", ^{
            actual = [Application launchEnvironmentWithEnvArg:@{}];

            expect(actual.count).to.equal(1);
            expect(actual[key]).to.equal(bootstrap);
        });

        it(@"returns dict w/ DYLD_INSERT_LIBS key/value pair when env arg does "
           "not already contain pair", ^{
            actual = [Application launchEnvironmentWithEnvArg:@{@"a" : @(1)}];

            expect(actual.count).to.equal(2);
            expect(actual[key]).to.equal(bootstrap);
            expect(actual[@"a"]).to.equal(@(1));
        });

        it(@"returns dict w/ DYLD_INSERT_LIBS value appended with bootstrap dylib", ^{
            NSDictionary *arg = @{
                                  key : @"@executable_path/libBrassicas.dylib",
                                  @"a" : @(1)
                                  };
            actual = [Application launchEnvironmentWithEnvArg:arg];

            expect(actual.count).to.equal(2);
            expect(actual[@"a"]).to.equal(@(1));
            NSString *value = [NSString stringWithFormat:@"%@:%@",
                               arg[key], bootstrap];
            expect(actual[key]).to.equal(value);
        });

        it(@"returns env arg if DYLD_INSERT_LIBS value already contains bootstrap dylib", ^{
            NSString *otherLib = @"@executable_path/libBrassicas.dylib";
            NSString *value = [otherLib stringByAppendingString:bootstrap];
            NSDictionary *arg = @{key : value, @"a" : @(1) };

            actual = [Application launchEnvironmentWithEnvArg:arg];
            expect(actual.count).to.equal(2);
            expect(actual[@"a"]).to.equal(@(1));
            expect(actual[key]).to.equal(value);
        });
    });
    
    describe(@"iOS >= 14.0", ^{
        beforeEach(^{
            AppMock = OCMClassMock([Application class]);
            OCMExpect([AppMock iOSVersionIsAtLeast14]).andReturn(YES);
        });

        it(@"returns dict w/ DYLD_INSERT_LIBS key/value pair when env arg does "
           "not already contain pair", ^{
            actual = [Application launchEnvironmentWithEnvArg:@{@"a" : @(1)}];

            expect(actual.count).to.equal(1);
            expect(actual[@"a"]).to.equal(@(1));
        });

        it(@"returns dict w/ DYLD_INSERT_LIBS value appended with bootstrap dylib", ^{
            NSDictionary *arg = @{
                                  key : @"@executable_path/libBrassicas.dylib",
                                  @"a" : @(1)
                                  };
            actual = [Application launchEnvironmentWithEnvArg:arg];

            expect(actual.count).to.equal(2);
            expect(actual[@"a"]).to.equal(@(1));
            NSString *value = [NSString stringWithFormat:@"%@:%@",
                               arg[key], bootstrap];
            expect(actual[key]).to.equal(value);
        });

        it(@"returns env arg if DYLD_INSERT_LIBS value already contains bootstrap dylib", ^{
            NSString *otherLib = @"@executable_path/libBrassicas.dylib";
            NSString *value = [otherLib stringByAppendingString:bootstrap];
            NSDictionary *arg = @{key : value, @"a" : @(1) };

            actual = [Application launchEnvironmentWithEnvArg:arg];
            expect(actual.count).to.equal(2);
            expect(actual[@"a"]).to.equal(@(1));
            expect(actual[key]).to.equal(value);
        });
    });

    afterEach(^{
        OCMVerifyAll(AppMock);
        [AppMock stopMocking];
    });
});

SpecEnd

#import <XCTest/XCTest.h>
#import "CBLSApplicationWorkspace.h"

@interface CBLSApplicationWorkspaceTest : XCTestCase

@end

@implementation CBLSApplicationWorkspaceTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testApplicationIsInstalled {
    NSString *bundleIdentifier;

    bundleIdentifier = @"com.apple.Preferences";
    expect([CBLSApplicationWorkspace applicationIsInstalled:bundleIdentifier]).to.equal(YES);

    bundleIdentifier = @"com.example.MyApp";
    expect([CBLSApplicationWorkspace applicationIsInstalled:bundleIdentifier]).to.equal(NO);
}

@end


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <objc/runtime.h>

#import "xctest.h"

extern BOOL _XCTestMain (XCTestConfiguration* config);


@interface Runner : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@end

@implementation Runner

XCTestConfiguration *sub_bd48() {
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"CBX" ofType:@"xctest"];
    NSBundle *testBundle = [NSBundle bundleWithPath:bundlePath];
    NSLog(@"Found test bundle: %@", bundlePath);
    XCTestConfiguration* config = [[XCTestConfiguration alloc] init];
    
    config.testBundleURL = testBundle.bundleURL;
    config.testsMustRunOnMainThread = YES;
    config.reportResultsToIDE = YES;
    config.reportActivities = YES;
    config.testsToRun = [NSSet setWithObject:@"XCUITestDriver/testRunner"];
    config.targetApplicationPath = nil;
    config.targetApplicationBundleID = nil;
    config.sessionIdentifier = [[NSUUID alloc] initWithUUIDString:@"BEEFBABE-FEED-BABE-BEEF-CAFEBEEFFACE"];
    
    NSLog(@"Running tests with configuration: %@", config);
    setenv("XCTestConfigurationFilePath", [bundlePath cStringUsingEncoding:NSUTF8StringEncoding], 1);
    return config;
    
    /*
     ORIGINAL ASSEMBLY
     
     >> look for bundle in plugins path
        sp = sp - 0x4 - 0x4 - 0x4 - 0x4 - 0x4 - 0x4 - 0x4 - 0x4 - 0xa8;
        r11 = *___stack_chk_guard;
        stack[2039] = r11;
        r6 = [[NSBundle mainBundle] builtInPlugInsPath];
        stack[2008] = r6;
        stack[2006] = @selector(defaultManager);
        r4 = [[NSFileManager defaultManager] enumeratorAtPath:r6];
        r5 = [NSDate distantPast];
        NSLog(@"Looking for test bundles in %@", r6);
        r2 = sp + 0x44;
        asm{ vmov.i32   q8, #0x0 };
        r0 = 0x4ade;
        asm{ vst1.32    {d16, d17}, [r1]! };
        r0 = r0 + 0xbe12;
        asm{ vst1.32    {d16, d17}, [r1] };
        r1 = *r0;
        stack[1999] = r1;
        r8 = objc_msgSend(r4, r1);
        r10 = 0x0;
        if (r8 == 0x0) goto loc_c102;
        
    loc_be30:
        r11 = r5;
        stack[2001] = @selector(compare:);
        stack[2003] = @selector(objectForKeyedSubscript:);
        stack[2000] = @selector(localizedDescription);
        stack[2005] = @selector(attributesOfItemAtPath:error:);
        stack[2009] = @selector(bundleWithPath:);
        stack[2007] = @selector(stringByAppendingPathComponent:);
        stack[2013] = @selector(isEqualToString:);
        stack[2012] = @selector(pathExtension);
        stack[2011] = @selector(skipDescendants);
        stack[2010] = *stack[2017];
        stack[2002] = *_NSFileModificationDate;
        stack[2004] = 0x0;
        do {
            r5 = 0x0;
            do {
                r0 = *stack[2017];
                if (r0 != stack[2010]) {
                    r0 = r4;
                }
                if (CPU_FLAGS & NE) {
                    objc_enumerationMutation(r0);
                }
                r6 = *(stack[2016] + (r5 << stack[2016]));
                objc_msgSend(r4, stack[2011]);
                if ((objc_msgSend(objc_msgSend(r6, stack[2012]), stack[2013]) & 0xff) != 0x0) {
                    r6 = objc_msgSend(stack[2008], stack[2007]);
                    if (objc_msgSend(@class(NSBundle), stack[2009]) != 0x0) {
                        stack[2014] = 0x0;
                        r0 = objc_msgSend(@class(NSFileManager), stack[2006]);
                        r0 = objc_msgSend(r0, stack[2005]);
                        if (r0 != 0x0) {
                            r10 = objc_msgSend(r0, stack[2003]);
                            if (r10 != 0x0) {
                                if (objc_msgSend(r10, stack[2001]) == 0x1) {
                                    r11 = r10;
                                }
                                r0 = stack[2004];
                                if (CPU_FLAGS & E) {
                                    r0 = r6;
                                }
                                stack[2004] = r0;
                            }
                        }
                        else {
                            r0 = objc_msgSend(stack[2014], stack[2000]);
                            NSLog(@"Test bundle found at %@ but unable to get attributes to check modification date: %@", r6, r0);
                        }
                    }
                    else {
                        NSLog(@"Item found at path %@ with test bundle path extension but was not a valid bundle", r6);
                    }
                }
                r5 = r5 + 0x1;
            } while (r5 < r8);
            r8 = objc_msgSend(r4, stack[1999]);
        } while (r8 != 0x0);
        r4 = stack[2004];
        if (r4 == 0x0) goto loc_c07a;
        
    loc_bfca:
        NSLog(@"Found test bundle at %@", r4);
        r4 = objc_msgSend(@class(NSBundle), stack[2009]);
        r10 = sub_baf8();
        r11 = *___stack_chk_guard;
        if (r10 == 0x0) goto loc_c090;
        
    loc_c00c:
        NSLog(@"Found configuration %@", r10);
        [r10 setTestBundleURL:[r4 bundleURL]];
        if (getenv("XCTestConfigurationFilePath") != 0x0) goto loc_c102;
        
    loc_c054:
        [r10 setReportResultsToIDE:0x0];
        r1 = @selector(setPathToXcodeReportingSocket:);
        r0 = r10;
        goto loc_c0fe;
        
    loc_c0fe:
        objc_msgSend(r0, r1);
        goto loc_c102;
        
    loc_c102:
        r0 = r11 - stack[2039];
        COND = r0 == 0x0;
        if (COND) {
            r0 = r10;
        }
        if (CPU_FLAGS & E) {
            return r0;
        }
        r0 = __stack_chk_fail();
        return r0;
        
    loc_c090:
        NSLog(@"No configurations found, creating a default configuration that will run all tests.");
        r10 = [[[XCTestConfiguration alloc] init] autorelease];
        [r4 bundleURL];
        r1 = @selector(setTestBundleURL:);
        r0 = r10;
        goto loc_c0fe;
        
    loc_c07a:
        r10 = 0x0;
        r11 = *___stack_chk_guard;
        goto loc_c102;
    }
     */
}

void sub_c118() {
    NSLog(@"Running tests...");
    XCTestConfiguration *config = sub_bd48();
    if (/* !CPU_FLAGS & */ config == 0x0) {
        NSProcessInfo *r0 = [NSProcessInfo processInfo];
        NSLog(@"XCTRunner Arguments: %@", [r0 arguments]);
        NSLog(@"XCTRunner Environment: %@", [r0 environment]);
        exit(0x1);
    } else {
        _XCTestMain(config);
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    CFRunLoopPerformBlock([[NSRunLoop mainRunLoop] getCFRunLoop], kCFRunLoopCommonModes, ^{
        sub_c118();
    });
    return YES;
}

@end


int main(int argc, char * argv[]) {
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([Runner class]));
    }
}
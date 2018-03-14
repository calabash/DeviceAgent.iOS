
#import <Foundation/Foundation.h>
#import <UIKit/UIApplication.h>

// These are defined in XCTest.
// To avoid duplicate symbol warnings and errors, don't import
// these if XCTest is available  - for example, when running unit tests.
#ifndef XCT_UI_TESTING_AVAILABLE
#import "XCUIApplication.h"
#import "XCApplicationQuery.h"
#import "XCUIElement.h"
#import "XCUIHitPointResult.h"
#import "XCUIDevice.h"
#import "XCUIApplicationStateTypedef.h"
#endif

// Defined in XCTAutomationSupport framework, so it is safe to import
// in any context.
#import "XCElementSnapshot.h"

@class XCUIApplication;
@class XCApplicationQuery;
@class XCUIElement;
@class XCUIHitPointResult;
@class XCElementSnapshot;

@interface XCUIApplication (CBXAdditions)

- (UIInterfaceOrientation)interfaceOrientation;
- (instancetype _Nonnull)initWithBundleIdentifier:(NSString *_Nonnull)arg1;
- (NSInteger)processID;
- (XCElementSnapshot *_Nullable)lastSnapshot;
- (void)resolve;
- (NSString *_Nonnull)bundleID;
- (XCUIApplicationState)state;
- (void)setState:(XCUIApplicationState)newState;
+ (NSString *_Nonnull)cbxStringForApplicationState:(XCUIApplicationState)state;

// As of Xcode 9.3 beta 4 applicationQuery is nil until query is called.
//
// After query is called, applicationQuery == query (object equal)
//
// When POST /terminate is called, applicationQuery becomes nil
// until query is called.
//
// Before Xcode 9.3 beta 4, DeviceAgent used applicationQuery.
// After Xcode 9.3 beta 4, applicationQuery calls are replaced with query.
- (XCApplicationQuery *_Nullable)query;
+ (id _Nullable)cbxQuery:(XCUIApplication *_Nonnull)xcuiApplication;

- (XCUIElementQuery *_Nonnull)cbxQueryForDescendantsOfAnyType;
- (XCElementSnapshot *_Nullable)cbxXCElementSnapshot;
+ (void)cbxResolveApplication:(XCUIApplication *_Nonnull)xcuiApplication;

@end

@interface XCUIElement (CBXAdditions)

- (XCElementSnapshot *_Nullable)lastSnapshot;
- (void)resolve;
- (XCUICoordinate *_Nonnull)hitPointCoordinate;
- (XCUIElementQuery *_Nonnull)query;

@end

@interface XCElementSnapshot (CBXAdditions)

- (XCUIHitPointResult *_Nullable)hitPoint:(int8_t *_Nullable)arg1;

@end

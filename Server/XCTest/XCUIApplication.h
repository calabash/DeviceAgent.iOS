//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

#import <XCTest/XCUIApplication.h>

#ifndef __IPHONE_11_0
typedef NS_ENUM(NSUInteger, XCUIApplicationState) {
    XCUIApplicationStateUnknown = 0,
    XCUIApplicationStateNotRunning = 1,
#if !TARGET_OS_OSX
    XCUIApplicationStateRunningBackgroundSuspended = 2,
#endif
    XCUIApplicationStateRunningBackground = 3,
    XCUIApplicationStateRunningForeground = 4
};
#endif

/*

 Before Xcode 9, XCUIApplicationState was not a public enum.

 XCApplicationState was a private enum.

 $ xcrun strings DeviceAgent-Runner.app/Frameworks/XCTest.framework/XCTest | grep XCApplicationState

 This error message gives us a clue about ordering.
 UI Testing Failure - App state for <XCUIApplicationProcess: 0x7ff661528a50 (null) (6798)> is
 XCApplicationStateRunningActive (3), still not XCApplicationStateNotRunning (1)

 We used that error information and some testing to create our own enum.

 typedef enum : NSUInteger {
     CBXCApplicationStateUnknown = 0,
     CBXCApplicationStateNotRunning = 1,
     CBXCApplicationStateRunningInactive,
     CBXCApplicationStateRunningActive,
 } CBXCApplicationState;

 Our enum is no longer necessary.

 */


@class NSArray, NSDictionary, NSString, XCAccessibilityElement, XCApplicationQuery, XCUIApplicationImpl;

@interface XCUIApplication ()
{
    BOOL _ancillary;
    BOOL _doesNotHandleUIInterruptions;
    BOOL _idleAnimationWaitEnabled;
    XCUIElement *_keyboard;
    NSArray *_launchArguments;
    NSDictionary *_launchEnvironment;
    XCUIApplicationImpl *_applicationImpl;
    XCApplicationQuery *_applicationQuery;
    unsigned long long _generation;
}
@property unsigned long long generation; // @synthesize generation=_generation;
@property(retain) XCApplicationQuery *applicationQuery; // @synthesize applicationQuery=_applicationQuery;
@property(retain) XCUIApplicationImpl *applicationImpl; // @synthesize applicationQuery=_applicationQuery;
@property(readonly, copy) NSString *bundleID; // @synthesize bundleID=_bundleID;
@property(readonly, copy) NSString *path; // @synthesize path=_path;
@property BOOL ancillary; // @synthesize ancillary=_ancillary;
@property(readonly) XCUIElement *keyboard; // @synthesize keyboard=_keyboard;

@property(getter=isIdleAnimationWaitEnabled) BOOL idleAnimationWaitEnabled; // @synthesize idleAnimationWaitEnabled=_idleAnimationWaitEnabled;
@property(nonatomic) BOOL doesNotHandleUIInterruptions; // @synthesize doesNotHandleUIInterruptions=_doesNotHandleUIInterruptions;
@property(readonly) BOOL fauxCollectionViewCellsEnabled;
@property(readonly, nonatomic) UIInterfaceOrientation interfaceOrientation; //TODO tvos
@property(readonly, nonatomic) BOOL running;
@property(nonatomic) pid_t processID; // @synthesize processID=_processID;
@property XCUIApplicationState state; // @synthesize state=_state;
@property(readonly) XCAccessibilityElement *accessibilityElement;

+ (instancetype)appWithPID:(pid_t)processID;

- (void)dismissKeyboard;
- (BOOL)setFauxCollectionViewCellsEnabled:(BOOL)arg1 error:(id *)arg2;
- (void)_waitForViewControllerViewDidDisappearWithTimeout:(double)arg1;
- (void)_waitForQuiescence;
- (void)terminate;
- (void)_launchUsingXcode:(BOOL)arg1;
- (void)launch;
- (id)application;
- (id)description;
- (id)lastSnapshot;
- (id)query;
- (void)clearQuery;
- (void)resolveHandleUIInterruption:(BOOL)arg1;
- (id)initPrivateWithPath:(id)arg1 bundleID:(id)arg2;
- (id)init;

@end

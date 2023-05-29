// class-dump results processed by bin/class-dump/dump.rb
//
//     Generated by classdump-c 4.2.0 (64 bit) (iOS port by DreamDevLost, Updated by Kevin Bradley.)(Debug version compiled May 27 2023 00:50:17).
//
//  Copyright (C) 1997-2019 Steve Nygard. Updated in 2022 by Kevin Bradley.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <XCTest/XCUIElementTypes.h>
#import "CDStructures.h"
@protocol OS_dispatch_queue;
@protocol OS_xpc_object;

#import "XCUIElement.h"
#import "XCUIIssueDiagnosticsProviding-Protocol.h"

@class NSArray, NSDictionary, NSString, XCAccessibilityElement, XCApplicationQuery, XCTVariationOptions, XCUIApplicationImpl, XCUIApplicationOpenRequest;
@protocol XCTRunnerAutomationSession, XCUIDevice;


@protocol XCTRunnerAutomationSession;

@interface XCUIApplication : XCUIElement <XCUIIssueDiagnosticsProviding>
{
    BOOL _ancillary;
    BOOL _prefersPlatformLauncher;
    BOOL _doesNotHandleUIInterruptions;
    BOOL _allowBackgroundInteraction;
    BOOL _idleAnimationWaitEnabled;
    NSUInteger _currentInteractionOptions;
    XCUIApplicationOpenRequest *_lastLaunchRequest;
    XCUIElement *_keyboard;
    NSArray *_launchArguments;
    NSDictionary *_launchEnvironment;
    XCApplicationQuery *_applicationQuery;
    NSUInteger _generation;
    XCUIApplicationImpl *_applicationImpl;
}

@property(readonly) XCAccessibilityElement *accessibilityElement;
@property BOOL allowBackgroundInteraction;
@property BOOL ancillary;
@property(readonly) XCUIApplicationImpl *applicationImpl;
@property(retain) XCApplicationQuery *applicationQuery;
@property(readonly, copy) NSDictionary *automaticTestRunConfigurations;
@property(readonly) XCTVariationOptions *automaticVariationOptions;
@property(readonly) id <XCTRunnerAutomationSession> automationSession;
@property(readonly) BOOL background;
@property(readonly) BOOL backgroundInteractionAllowed;
@property(readonly) NSString *bundleID;
@property NSUInteger currentInteractionOptions;
@property(readonly) id <XCUIDevice> device;
@property(nonatomic) BOOL doesNotHandleUIInterruptions;
@property(readonly) BOOL fauxCollectionViewCellsEnabled;
@property(readonly) BOOL foreground;
@property NSUInteger generation;
@property(readonly) BOOL hasAutomationSession;
@property(readonly, nonatomic) NSInteger interfaceOrientation;
@property(getter=isIdleAnimationWaitEnabled) BOOL idleAnimationWaitEnabled;
@property(readonly) XCUIElement *keyboard;
@property(retain) XCUIApplicationOpenRequest *lastLaunchRequest;
@property(copy, nonatomic) NSArray *launchArguments;
@property(copy, nonatomic) NSDictionary *launchEnvironment;
@property(readonly) NSString *path;
@property BOOL prefersPlatformLauncher;
@property(nonatomic) NSInteger processID;
@property(readonly) BOOL running;
@property(nonatomic) NSUInteger state;
@property(readonly) BOOL shouldBeCheckedForInterruptingElements;
@property(readonly) BOOL shouldSkipPostEventQuiescence;
@property(readonly) BOOL shouldSkipPreEventQuiescence;
@property(readonly) BOOL suspended;

+ (id)keyPathsForValuesAffectingBackground;
+ (id)keyPathsForValuesAffectingForeground;
+ (id)keyPathsForValuesAffectingIsApplicationStateKnown;
+ (id)keyPathsForValuesAffectingRunning;
+ (id)keyPathsForValuesAffectingState;
+ (id)keyPathsForValuesAffectingSuspended;
- (id)_combinedLaunchArguments;
- (id)_combinedLaunchEnvironment;
- (void)_launchUsingXcode:(BOOL)arg1;
- (void)_launchUsingXcode:(BOOL)arg1 withoutAccessibility:(BOOL)arg2 launchURL:(id)arg3;
- (void)_performWithInteractionOptions:(NSUInteger)arg1 block:(CDUnknownBlockType)arg2;
- (void)_waitForQuiescence;
- (BOOL)_waitForViewControllerViewDidDisappearWithTimeout:(double)arg1 error:(id *)arg2;
- (void)activate;
- (id)application;
- (void)clearQuery;
- (void)commonInitWithApplicationSpecifier:(id)arg1 device:(id)arg2;
- (id)currentProcess;
- (id)diagnosticAttachmentsForError:(id)arg1;
- (void)dismissKeyboard;
- (NSUInteger)elementType;
- (BOOL)exists;
- (id)initPrivateWithPath:(id)arg1 bundleID:(id)arg2;
- (id)initWithApplicationSpecifier:(id)arg1 device:(id)arg2;
- (id)initWithApplicationSpecifier:(id)arg1 device:(id)arg2 error:(id *)arg3;
- (id)initWithBundleIdentifier:(id)arg1;
- (id)initWithBundleIdentifier:(id)arg1 device:(id)arg2;
- (id)initWithElementQuery:(id)arg1;
- (BOOL)isApplicationStateKnown;
- (void)launch;
- (void)launchWithoutAccessibility:(BOOL)arg1;
- (void)openURL:(id)arg1;
- (id)query;
- (void)resetAlertCount;
- (void)resetAuthorizationStatusForResource:(NSInteger)arg1;
- (BOOL)resolveOrRaiseTestFailure:(BOOL)arg1 error:(id *)arg2;
- (BOOL)setFauxCollectionViewCellsEnabled:(BOOL)arg1 error:(id *)arg2;
- (void)terminate;
- (id)viewDidAppearExpectationForViewControllerWithName:(id)arg1;
- (BOOL)waitForState:(NSUInteger)arg1 timeout:(double)arg2;


@end


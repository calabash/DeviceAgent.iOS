// class-dump results processed by bin/class-dump/dump.rb
//
//     Generated by class-dump 3.5 (64 bit) (Debug version compiled May  6 2021 20:43:33).
//
//  Copyright (C) 1997-2019 Steve Nygard.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <XCTest/XCUIElementTypes.h>
#import "CDStructures.h"
@protocol OS_dispatch_queue;
@protocol OS_xpc_object;

#import "XCTest.h"

#import "XCTActivity-Protocol.h"
#import "XCTMemoryCheckerDelegate-Protocol.h"
#import "XCTWaiterDelegate-Protocol.h"

@class MXMInstrument, NSArray, NSDictionary, NSInvocation, NSMutableArray, NSMutableDictionary, NSMutableSet, NSObject, NSString, NSThread, XCTAttachmentManager, XCTIssue, XCTMemoryChecker, XCTSkippedTestContext, XCTTestIdentifier, XCTWaiter, XCTestCaseRun;
@protocol OS_dispatch_source;

@interface XCTestCase : XCTest <XCTWaiterDelegate, XCTMemoryCheckerDelegate, XCTActivity>
{
    BOOL _continueAfterFailure;
    BOOL __preciseTimeoutsEnabled;
    BOOL _isMeasuringMetrics;
    BOOL __didMeasureMetrics;
    BOOL __didStartMeasuring;
    BOOL __didStopMeasuring;
    BOOL _hasDequeuedTeardownBlocks;
    BOOL _hasReportedFailuresToTestCaseRun;
    BOOL _canHandleInterruptions;
    BOOL _shouldHaltWhenReceivesControl;
    BOOL _shouldSetShouldHaltWhenReceivesControl;
    BOOL _hasAttemptedToCaptureScreenshotOnFailure;
    XCTTestIdentifier *_identifier;
    NSInvocation *_invocation;
    double _executionTimeAllowance;
    NSArray *_activePerformanceMetricIDs;
    NSUInteger _startWallClockTime;
    struct time_value _startUserTime;
    struct time_value _startSystemTime;
    NSUInteger _measuringIteration;
    MXMInstrument *_instrument;
    NSInteger _runLoopNestingCount;
    NSMutableArray *_teardownBlocks;
    NSMutableArray *_primaryThreadBlocks;
    XCTAttachmentManager *_attachmentManager;
    NSDictionary *_activityAggregateStatistics;
    NSObject<OS_dispatch_source> *_timeoutSource;
    NSUInteger _signpostID;
    NSThread *_primaryThread;
    NSMutableSet *_previousIssuesAssociatedWithSwiftErrors;
    NSMutableArray *_enqueuedIssues;
    NSMutableArray *_expectations;
    XCTWaiter *_currentWaiter;
    XCTSkippedTestContext *_skippedTestContext;
    XCTestCaseRun *_testCaseRun;
    XCTMemoryChecker *_defaultMemoryChecker;
    NSMutableDictionary *__perfMetricsForID;
}

@property BOOL _didMeasureMetrics;
@property BOOL _didStartMeasuring;
@property BOOL _didStopMeasuring;
@property(readonly) double _effectiveExecutionTimeAllowance;
@property(retain) NSMutableDictionary *_perfMetricsForID;
@property(nonatomic) BOOL _preciseTimeoutsEnabled;
@property(copy) NSDictionary *activityAggregateStatistics;
@property(copy) XCTIssue *candidateIssueForCurrentThread;
@property BOOL continueAfterFailure;
@property double executionTimeAllowance;
@property(retain) NSInvocation *invocation;
@property NSUInteger maxDurationInMinutes;
@property(readonly) CDStruct_2ec95fd7 minimumOperatingSystemVersion;
@property(readonly, copy) NSString *name;
@property(retain) NSThread *primaryThread;
@property NSInteger runLoopNestingCount;
@property(nonatomic) BOOL shouldHaltWhenReceivesControl;
@property(nonatomic) BOOL shouldSetShouldHaltWhenReceivesControl;
@property(retain) XCTestCaseRun *testCaseRun;

+ (id)_allSubclasses;
+ (void)_allTestMethodInvocations:(id)arg1;
+ (id)_baselineDictionary;
+ (BOOL)_isDiscoverable;
+ (BOOL)_reportPerformanceFailuresForLargeImprovements;
+ (BOOL)_treatMissingBaselinesAsTestFailures;
+ (id)allSubclasses;
+ (id)allSubclassesOutsideXCTest;
+ (id)allTestMethodInvocations;
+ (id)bundle;
+ (id)defaultMeasureOptions;
+ (id)defaultMetrics;
+ (id)defaultPerformanceMetrics;
+ (id)defaultTestSuite;
+ (BOOL)isInheritingTestCases;
+ (void)setUp;
+ (void)tearDown;
+ (id)testCaseWithInvocation:(id)arg1;
+ (id)testCaseWithSelector:(SEL)arg1;
+ (id)testInvocations;
+ (id)testMethodInvocations;
- (void)_addTeardownBlock:(CDUnknownBlockType)arg1;
- (BOOL)_caughtUnhandledDeveloperExceptionPermittingControlFlowInterruptions:(BOOL)arg1 caughtInterruptionException:(BOOL *)arg2 whileExecutingBlock:(CDUnknownBlockType)arg3;
- (BOOL)_caughtUnhandledDeveloperExceptionPermittingControlFlowInterruptions:(BOOL)arg1 whileExecutingBlock:(CDUnknownBlockType)arg2;
- (void)_dequeueIssues;
- (id)_duplicate;
- (void)_enqueueIssue:(id)arg1;
- (void)_exceededExecutionTimeAllowance;
- (id)_expectationForDarwinNotification:(id)arg1;
- (id)_expectationForDistributedNotification:(id)arg1 object:(id)arg2 handler:(CDUnknownBlockType)arg3;
- (void)_handleIssue:(id)arg1;
- (id)_identifier;
- (void)_interruptOrMarkForLaterInterruption;
- (BOOL)_isDuplicateOfIssueAssociatedWithSameSwiftError:(id)arg1;
- (id)_issueWithFailureScreenshotAttachedToIssue:(id)arg1;
- (void)_logAndReportPerformanceMetrics:(id)arg1 perfMetricResultsForIDs:(id)arg2 withBaselinesForTest:(id)arg3;
- (void)_logAndReportPerformanceMetrics:(id)arg1 perfMetricResultsForIDs:(id)arg2 withBaselinesForTest:(id)arg3 defaultBaselinesForPerfMetricID:(id)arg4;
- (void)_logMemoryGraphData:(id)arg1 withTitle:(id)arg2;
- (void)_logMemoryGraphDataFromFilePath:(id)arg1 withTitle:(id)arg2;
- (void)_purgeTeardownBlocks;
- (void)_recordIssue:(id)arg1;
- (void)_recordValues:(id)arg1 forPerformanceMetricID:(id)arg2 name:(id)arg3 unitsOfMeasurement:(id)arg4 baselineName:(id)arg5 baselineAverage:(id)arg6 maxPercentRegression:(id)arg7 maxPercentRelativeStandardDeviation:(id)arg8 maxRegression:(id)arg9 maxStandardDeviation:(id)arg10 file:(id)arg11 line:(NSUInteger)arg12 polarity:(NSInteger)arg13;
- (void)_reportFailuresAtFile:(id)arg1 line:(NSUInteger)arg2 forTestAssertionsInScope:(CDUnknownBlockType)arg3;
- (Class)_requiredTestRunBaseClass;
- (void)_resetTimer;
- (BOOL)_shouldRerunTest;
- (void)_startTimeoutTimer;
- (void)_stopTimeoutTimer;
- (id)_storageKeyForCandidateIssue;
- (id)addAdditionalIterationsBasedOnOptions:(id)arg1;
- (void)addAttachment:(id)arg1;
- (void)addTeardownBlock:(CDUnknownBlockType)arg1;
- (id)addUIInterruptionMonitorWithDescription:(id)arg1 handler:(CDUnknownBlockType)arg2;
- (void)afterTestIteration:(NSUInteger)arg1 selector:(SEL)arg2;
- (void)assertInvalidObjectsDeallocatedAfterScope:(CDUnknownBlockType)arg1;
- (void)assertNoLeaksInApplication:(id)arg1 inScope:(CDUnknownBlockType)arg2;
- (void)assertNoLeaksInProcessWithIdentifier:(NSInteger)arg1 inScope:(CDUnknownBlockType)arg2;
- (void)assertNoLeaksInScope:(CDUnknownBlockType)arg1;
- (void)assertObjectsOfType:(id)arg1 inApplication:(id)arg2 invalidAfterScope:(CDUnknownBlockType)arg3;
- (void)assertObjectsOfType:(id)arg1 invalidAfterScope:(CDUnknownBlockType)arg2;
- (void)assertObjectsOfTypes:(id)arg1 inApplication:(id)arg2 invalidAfterScope:(CDUnknownBlockType)arg3;
- (void)assertObjectsOfTypes:(id)arg1 invalidAfterScope:(CDUnknownBlockType)arg2;
- (id)baselinesDictionaryForTest;
- (void)beforeTestIteration:(NSUInteger)arg1 selector:(SEL)arg2;
- (id)bundle;
- (NSInteger)defaultExecutionOrderCompare:(id)arg1;
- (void)expectFailureWithContext:(id)arg1;
- (id)expectationForNotification:(id)arg1 object:(id)arg2 handler:(CDUnknownBlockType)arg3;
- (id)expectationForNotification:(id)arg1 object:(id)arg2 notificationCenter:(id)arg3 handler:(CDUnknownBlockType)arg4;
- (id)expectationForPredicate:(id)arg1 evaluatedWithObject:(id)arg2 handler:(CDUnknownBlockType)arg3;
- (id)expectationWithDescription:(id)arg1;
- (void)handleIssue:(id)arg1;
- (id)initWithInvocation:(id)arg1;
- (id)initWithSelector:(SEL)arg1;
- (void)invokeTest;
- (id)keyValueObservingExpectationForObject:(id)arg1 keyPath:(id)arg2 expectedValue:(id)arg3;
- (id)keyValueObservingExpectationForObject:(id)arg1 keyPath:(id)arg2 handler:(CDUnknownBlockType)arg3;
- (id)languageAgnosticTestMethodName;
- (void)markInvalid:(id)arg1;
- (void)measureBlock:(CDUnknownBlockType)arg1;
- (void)measureMetrics:(id)arg1 automaticallyStartMeasuring:(BOOL)arg2 forBlock:(CDUnknownBlockType)arg3;
- (void)measureWithMetrics:(id)arg1 block:(CDUnknownBlockType)arg2;
- (void)measureWithMetrics:(id)arg1 options:(id)arg2 block:(CDUnknownBlockType)arg3;
- (void)measureWithOptions:(id)arg1 block:(CDUnknownBlockType)arg2;
- (void)memoryChecker:(id)arg1 didFailWithMessages:(id)arg2 serializedMemoryGraph:(id)arg3;
- (id)nameForLegacyLogging;
- (void)nestedWaiter:(id)arg1 wasInterruptedByTimedOutWaiter:(id)arg2;
- (NSUInteger)numberOfTestIterationsForTestWithSelector:(SEL)arg1;
- (void)performTest:(id)arg1;
- (void)recordFailureWithDescription:(id)arg1 inFile:(id)arg2 atLine:(NSUInteger)arg3 expected:(BOOL)arg4;
- (void)recordIssue:(id)arg1;
- (void)registerDefaultMetrics;
- (void)registerMetricID:(id)arg1 name:(id)arg2 unit:(id)arg3;
- (void)registerMetricID:(id)arg1 name:(id)arg2 unitString:(id)arg3;
- (void)registerMetricID:(id)arg1 name:(id)arg2 unitString:(id)arg3 polarity:(NSInteger)arg4;
- (void)removeUIInterruptionMonitor:(id)arg1;
- (void)reportMeasurements:(id)arg1 forMetricID:(id)arg2 reportFailures:(BOOL)arg3;
- (void)reportMetric:(id)arg1 reportFailures:(BOOL)arg2;
- (void)runActivityNamed:(id)arg1 inScope:(CDUnknownBlockType)arg2;
- (void)setUpTestWithSelector:(SEL)arg1;
- (void)startActivityWithTitle:(id)arg1 block:(CDUnknownBlockType)arg2;
- (void)startActivityWithTitle:(id)arg1 type:(id)arg2 block:(CDUnknownBlockType)arg3;
- (void)startMeasuring;
- (void)stopMeasuring;
- (void)tearDownTestWithSelector:(SEL)arg1;
- (NSUInteger)testCaseCount;
- (Class)testRunClass;
- (void)waitForExpectations:(id)arg1 timeout:(double)arg2;
- (void)waitForExpectations:(id)arg1 timeout:(double)arg2 enforceOrder:(BOOL)arg3;
- (void)waitForExpectationsWithTimeout:(double)arg1 handler:(CDUnknownBlockType)arg2;
- (void)waiter:(id)arg1 didFulfillInvertedExpectation:(id)arg2;
- (void)waiter:(id)arg1 didTimeoutWithUnfulfilledExpectations:(id)arg2;
- (void)waiter:(id)arg1 fulfillmentDidViolateOrderingConstraintsForExpectation:(id)arg2 requiredExpectation:(id)arg3;


@end


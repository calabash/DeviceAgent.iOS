//
//  TestManagerDConnection.h
//  XCUITestManagerDLink
//
//  Created by Chris Fuentes on 2/16/16.
//  Copyright © 2016 calabash. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XCElementSnapshot;
@class XCActivityRecord;
@class XCAccessibilityElement;

@protocol XCTestManager_IDEInterface
- (id)_XCT_nativeFocusItemDidChangeAtTime:(NSNumber *)arg1 parameterSnapshot:(XCElementSnapshot *)arg2 applicationSnapshot:(XCElementSnapshot *)arg3;
- (id)_XCT_recordedEventNames:(NSArray *)arg1 timestamp:(NSNumber *)arg2 duration:(NSNumber *)arg3 startLocation:(NSDictionary *)arg4 startElementSnapshot:(XCElementSnapshot *)arg5 startApplicationSnapshot:(XCElementSnapshot *)arg6 endLocation:(NSDictionary *)arg7 endElementSnapshot:(XCElementSnapshot *)arg8 endApplicationSnapshot:(XCElementSnapshot *)arg9;
- (id)_XCT_testCase:(NSString *)arg1 method:(NSString *)arg2 didFinishActivity:(XCActivityRecord *)arg3;
- (id)_XCT_testCase:(NSString *)arg1 method:(NSString *)arg2 willStartActivity:(XCActivityRecord *)arg3;
- (id)_XCT_recordedOrientationChange:(NSString *)arg1;
- (id)_XCT_recordedFirstResponderChangedWithApplicationSnapshot:(XCElementSnapshot *)arg1;
- (id)_XCT_exchangeCurrentProtocolVersion:(NSNumber *)arg1 minimumVersion:(NSNumber *)arg2;
- (id)_XCT_recordedKeyEventsWithApplicationSnapshot:(XCElementSnapshot *)arg1 characters:(NSString *)arg2 charactersIgnoringModifiers:(NSString *)arg3 modifierFlags:(NSNumber *)arg4;
- (id)_XCT_recordedEventNames:(NSArray *)arg1 duration:(NSNumber *)arg2 startLocation:(NSDictionary *)arg3 startElementSnapshot:(XCElementSnapshot *)arg4 startApplicationSnapshot:(XCElementSnapshot *)arg5 endLocation:(NSDictionary *)arg6 endElementSnapshot:(XCElementSnapshot *)arg7 endApplicationSnapshot:(XCElementSnapshot *)arg8;
- (id)_XCT_recordedKeyEventsWithCharacters:(NSString *)arg1 charactersIgnoringModifiers:(NSString *)arg2 modifierFlags:(NSNumber *)arg3;
- (id)_XCT_recordedEventNames:(NSArray *)arg1 duration:(NSNumber *)arg2 startElement:(XCAccessibilityElement *)arg3 startApplicationSnapshot:(XCElementSnapshot *)arg4 endElement:(XCAccessibilityElement *)arg5 endApplicationSnapshot:(XCElementSnapshot *)arg6;
- (id)_XCT_recordedEvent:(NSString *)arg1 targetElementID:(NSDictionary *)arg2 applicationSnapshot:(XCElementSnapshot *)arg3;
- (id)_XCT_recordedEvent:(NSString *)arg1 forElement:(NSString *)arg2;
- (id)_XCT_logDebugMessage:(NSString *)arg1;
- (id)_XCT_logMessage:(NSString *)arg1;
- (id)_XCT_testMethod:(NSString *)arg1 ofClass:(NSString *)arg2 didMeasureMetric:(NSDictionary *)arg3 file:(NSString *)arg4 line:(NSNumber *)arg5;
- (id)_XCT_testCase:(NSString *)arg1 method:(NSString *)arg2 didStallOnMainThreadInFile:(NSString *)arg3 line:(NSNumber *)arg4;
- (id)_XCT_testCaseDidFinishForTestClass:(NSString *)arg1 method:(NSString *)arg2 withStatus:(NSString *)arg3 duration:(NSNumber *)arg4;
- (id)_XCT_testCaseDidFailForTestClass:(NSString *)arg1 method:(NSString *)arg2 withMessage:(NSString *)arg3 file:(NSString *)arg4 line:(NSNumber *)arg5;
- (id)_XCT_testCaseDidStartForTestClass:(NSString *)arg1 method:(NSString *)arg2;
- (id)_XCT_testSuite:(NSString *)arg1 didFinishAt:(NSString *)arg2 runCount:(NSNumber *)arg3 withFailures:(NSNumber *)arg4 unexpected:(NSNumber *)arg5 testDuration:(NSNumber *)arg6 totalDuration:(NSNumber *)arg7;
- (id)_XCT_testSuite:(NSString *)arg1 didStartAt:(NSString *)arg2;
- (id)_XCT_didFinishExecutingTestPlan;
- (id)_XCT_didBeginExecutingTestPlan;
- (id)_XCT_testBundleReadyWithProtocolVersion:(NSNumber *)arg1 minimumVersion:(NSNumber *)arg2;
- (id)_XCT_getProgressForLaunch:(id)arg1;
- (id)_XCT_terminateProcess:(id)arg1;
- (id)_XCT_launchProcessWithPath:(NSString *)arg1 bundleID:(NSString *)arg2 arguments:(NSArray *)arg3 environmentVariables:(NSDictionary *)arg4;

@optional
- (id)_XCT_testMethod:(NSString *)arg1 ofClass:(NSString *)arg2 didMeasureValues:(NSArray *)arg3 forPerformanceMetricID:(NSString *)arg4 name:(NSString *)arg5 withUnits:(NSString *)arg6 baselineName:(NSString *)arg7 baselineAverage:(NSNumber *)arg8 maxPercentRegression:(NSNumber *)arg9 maxPercentRelativeStandardDeviation:(NSNumber *)arg10 file:(NSString *)arg11 line:(NSNumber *)arg12;
- (id)_XCT_testBundleReady;
@end

@protocol XCTestDriverInterface
- (id)_IDE_startExecutingTestPlanWithProtocolVersion:(NSNumber *)arg1;

@optional
- (id)_IDE_startExecutingTestPlanWhenReady;
@end


@protocol XCTestManager_DaemonConnectionInterface
- (id)_IDE_stopRecording;
- (id)_IDE_startRecordingProcessPID:(NSNumber *)arg1 applicationSnapshotAttributes:(NSArray *)arg2 applicationSnapshotParameters:(NSDictionary *)arg3 elementSnapshotAttributes:(NSArray *)arg4 elementSnapshotParameters:(NSDictionary *)arg5 simpleTargetGestureNames:(NSArray *)arg6;
- (id)_IDE_startRecordingProcessPID:(NSNumber *)arg1 snapshotAttributes:(NSArray *)arg2 snapshotParameters:(NSDictionary *)arg3 simpleTargetGestureNames:(NSArray *)arg4;
- (id)_IDE_startRecordingProcessPID:(NSNumber *)arg1;
- (id)_IDE_startRecording;
- (id)_IDE_beginSessionWithIdentifier:(NSUUID *)arg1 forClient:(NSString *)arg2 atPath:(NSString *)arg3;
- (id)_IDE_initiateControlSessionForTestProcessID:(NSNumber *)arg1;
- (id)_IDE_initiateSessionWithIdentifier:(NSUUID *)arg1 forClient:(NSString *)arg2 atPath:(NSString *)arg3 protocolVersion:(NSNumber *)arg4;

@end

@interface TestManagerDConnection : NSObject<XCTestManager_IDEInterface>
+ (void)connect;
@end

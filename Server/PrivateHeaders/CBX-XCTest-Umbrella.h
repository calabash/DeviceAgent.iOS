// Generated by bin/class-dump/dump.rb

#if LOAD_XCTEST_PRIVATE_HEADERS
#import "XCTestCore/DTXConnection-XCTestAdditions.h"
#import "XCTestCore/MXMInstrumental-Protocol.h"
#import "XCTestCore/NSArray-XCTestAdditions.h"
#import "XCTestCore/NSBundle-XCTestAdditions.h"
#import "XCTestCore/NSError-XCTTestRunSession.h"
#import "XCTestCore/NSException-XCTestAdditions.h"
#import "XCTestCore/NSKeyedArchiver-XCTestAdditions.h"
#import "XCTestCore/NSKeyedUnarchiver-XCTestAdditions.h"
#import "XCTestCore/NSMutableArray-XCTestAdditions.h"
#import "XCTestCore/NSSet-XCTestAdditions.h"
#import "XCTestCore/NSThread-XCTestAdditions.h"
#import "XCTestCore/NSValue-XCTSymbolicationServiceAdditions.h"
#import "XCTestCore/XCActivityRecord.h"
#import "XCTestCore/XCDebugLogDelegate-Protocol.h"
#import "XCTestCore/XCTASDebugLogDelegate-Protocol.h"
#import "XCTestCore/XCTActivity-Protocol.h"
#import "XCTestCore/XCTActivityAggregationRecord.h"
#import "XCTestCore/XCTActivityRecordContext-Protocol.h"
#import "XCTestCore/XCTActivityRecordStack.h"
#import "XCTestCore/XCTAggregateSuiteRunStatistics.h"
#import "XCTestCore/XCTAggregateSuiteRunStatisticsRecord.h"
#import "XCTestCore/XCTApplicationBundleInfo.h"
#import "XCTestCore/XCTApplicationLaunchMetric.h"
#import "XCTestCore/XCTAttachment.h"
#import "XCTestCore/XCTAttachmentManager.h"
#import "XCTestCore/XCTBlockingQueue.h"
#import "XCTestCore/XCTCPUMetric.h"
#import "XCTestCore/XCTClockMetric.h"
#import "XCTestCore/XCTCompoundExpectation.h"
#import "XCTestCore/XCTContext.h"
#import "XCTestCore/XCTDaemonTelemetryLogger.h"
#import "XCTestCore/XCTDarwinNotificationExpectation.h"
#import "XCTestCore/XCTDefaultDebugLogHandler.h"
#import "XCTestCore/XCTExecutionExtension-Protocol.h"
#import "XCTestCore/XCTExecutionWorker.h"
#import "XCTestCore/XCTExpectedFailure.h"
#import "XCTestCore/XCTExpectedFailureContext.h"
#import "XCTestCore/XCTExpectedFailureContextManager.h"
#import "XCTestCore/XCTExpectedFailureOptions.h"
#import "XCTestCore/XCTExtensionProvider.h"
#import "XCTestCore/XCTFailableInvocation.h"
#import "XCTestCore/XCTFixedPriorityTestScheduler.h"
#import "XCTestCore/XCTFuture.h"
#import "XCTestCore/XCTImageEncoding-XCTImageQuality.h"
#import "XCTestCore/XCTInProcessSymbolicationService.h"
#import "XCTestCore/XCTIssue.h"
#import "XCTestCore/XCTIssueHandling-Protocol.h"
#import "XCTestCore/XCTKVOExpectation.h"
#import "XCTestCore/XCTMeasureOptions.h"
#import "XCTestCore/XCTMeasurement.h"
#import "XCTestCore/XCTMemgraph.h"
#import "XCTestCore/XCTMemoryChecker.h"
#import "XCTestCore/XCTMemoryCheckerDelegate-Protocol.h"
#import "XCTestCore/XCTMemoryMarker.h"
#import "XCTestCore/XCTMemoryMetric.h"
#import "XCTestCore/XCTMessagingChannel_DaemonRecorderToIDE-Protocol.h"
#import "XCTestCore/XCTMessagingChannel_DaemonToIDE-Protocol.h"
#import "XCTestCore/XCTMessagingChannel_DaemonToIDE_All-Protocol.h"
#import "XCTestCore/XCTMessagingChannel_DaemonToRunner-Protocol.h"
#import "XCTestCore/XCTMessagingChannel_IDEToDaemon-Protocol.h"
#import "XCTestCore/XCTMessagingChannel_IDEToRunner-Protocol.h"
#import "XCTestCore/XCTMessagingChannel_RunnerToDaemon-Protocol.h"
#import "XCTestCore/XCTMessagingChannel_RunnerToIDE-Protocol.h"
#import "XCTestCore/XCTMessagingRole_AccessibilityNotificationReporting-Protocol.h"
#import "XCTestCore/XCTMessagingRole_ActivityReporting-Protocol.h"
#import "XCTestCore/XCTMessagingRole_ActivityReporting_Legacy-Protocol.h"
#import "XCTestCore/XCTMessagingRole_BundleRequesting-Protocol.h"
#import "XCTestCore/XCTMessagingRole_CapabilityExchange-Protocol.h"
#import "XCTestCore/XCTMessagingRole_ControlSessionInitiation-Protocol.h"
#import "XCTestCore/XCTMessagingRole_CrashReporting-Protocol.h"
#import "XCTestCore/XCTMessagingRole_DebugLogging-Protocol.h"
#import "XCTestCore/XCTMessagingRole_DiagnosticsCollection-Protocol.h"
#import "XCTestCore/XCTMessagingRole_EventSynthesis-Protocol.h"
#import "XCTestCore/XCTMessagingRole_ForcePressureSupportQuerying-Protocol.h"
#import "XCTestCore/XCTMessagingRole_HIDEventRecording-Protocol.h"
#import "XCTestCore/XCTMessagingRole_MemoryTesting-Protocol.h"
#import "XCTestCore/XCTMessagingRole_PerformanceMeasurementReporting-Protocol.h"
#import "XCTestCore/XCTMessagingRole_PerformanceMeasurementReporting_Legacy-Protocol.h"
#import "XCTestCore/XCTMessagingRole_ProcessMonitoring-Protocol.h"
#import "XCTestCore/XCTMessagingRole_ProtectedResourceAuthorization-Protocol.h"
#import "XCTestCore/XCTMessagingRole_RunnerSessionInitiation-Protocol.h"
#import "XCTestCore/XCTMessagingRole_SelfDiagnosisIssueReporting-Protocol.h"
#import "XCTestCore/XCTMessagingRole_SignpostReceiving-Protocol.h"
#import "XCTestCore/XCTMessagingRole_SignpostRequesting-Protocol.h"
#import "XCTestCore/XCTMessagingRole_SiriAutomation-Protocol.h"
#import "XCTestCore/XCTMessagingRole_SystemConfiguration-Protocol.h"
#import "XCTestCore/XCTMessagingRole_TestExecution-Protocol.h"
#import "XCTestCore/XCTMessagingRole_TestExecution_Legacy-Protocol.h"
#import "XCTestCore/XCTMessagingRole_TestReporting-Protocol.h"
#import "XCTestCore/XCTMessagingRole_TestReporting_Legacy-Protocol.h"
#import "XCTestCore/XCTMessagingRole_UIApplicationStateUpdating-Protocol.h"
#import "XCTestCore/XCTMessagingRole_UIAutomation-Protocol.h"
#import "XCTestCore/XCTMessagingRole_UIAutomationEventReporting-Protocol.h"
#import "XCTestCore/XCTMessagingRole_UIRecordingControl-Protocol.h"
#import "XCTestCore/XCTMetric-Protocol.h"
#import "XCTestCore/XCTMetricDiagnosticHelper.h"
#import "XCTestCore/XCTMetricHelper.h"
#import "XCTestCore/XCTMetricInstrumentalAdapter.h"
#import "XCTestCore/XCTMetric_Private-Protocol.h"
#import "XCTestCore/XCTMutableIssue.h"
#import "XCTestCore/XCTNSNotificationExpectation.h"
#import "XCTestCore/XCTNSPredicateExpectation.h"
#import "XCTestCore/XCTOSSignpostMetric.h"
#import "XCTestCore/XCTOutOfProcessSymbolicationService.h"
#import "XCTestCore/XCTPerformanceMeasurement.h"
#import "XCTestCore/XCTPerformanceMeasurementTimestamp.h"
#import "XCTestCore/XCTPromise.h"
#import "XCTestCore/XCTRemoteSignpostListenerProxy-Protocol.h"
#import "XCTestCore/XCTRepetitionPolicy.h"
#import "XCTestCore/XCTReportingSession.h"
#import "XCTestCore/XCTReportingSessionActivityReporter.h"
#import "XCTestCore/XCTReportingSessionConfiguration-Protocol.h"
#import "XCTestCore/XCTReportingSessionConfiguration.h"
#import "XCTestCore/XCTReportingSessionSuiteReporter.h"
#import "XCTestCore/XCTReportingSessionTestReporter.h"
#import "XCTestCore/XCTResult.h"
#import "XCTestCore/XCTRunnerDTServiceHubSession.h"
#import "XCTestCore/XCTRunnerDaemonSession.h"
#import "XCTestCore/XCTRunnerDaemonSessionUIAutomationDelegate-Protocol.h"
#import "XCTestCore/XCTRunnerIDESession.h"
#import "XCTestCore/XCTRunnerIDESessionDelegate-Protocol.h"
#import "XCTestCore/XCTSerializedTransportWrapper.h"
#import "XCTestCore/XCTSignpostListener-Protocol.h"
#import "XCTestCore/XCTSignpostListener.h"
#import "XCTestCore/XCTSkippedTestContext.h"
#import "XCTestCore/XCTSourceCodeContext.h"
#import "XCTestCore/XCTSourceCodeFrame.h"
#import "XCTestCore/XCTSourceCodeLocation.h"
#import "XCTestCore/XCTSourceCodeSymbolInfo.h"
#import "XCTestCore/XCTStorageMetric.h"
#import "XCTestCore/XCTSwiftErrorObservation.h"
#import "XCTestCore/XCTSwiftErrorObservation_Overlay-Protocol.h"
#import "XCTestCore/XCTSymbolInfoProviding-Protocol.h"
#import "XCTestCore/XCTSymbolicationService.h"
#import "XCTestCore/XCTTelemetryLogger.h"
#import "XCTestCore/XCTTelemetryLogging-Protocol.h"
#import "XCTestCore/XCTTelemetryObserver.h"
#import "XCTestCore/XCTTestIdentifier.h"
#import "XCTestCore/XCTTestIdentifierSet.h"
#import "XCTestCore/XCTTestIdentifierSetBuilder.h"
#import "XCTestCore/XCTTestInvocationDescriptor.h"
#import "XCTestCore/XCTTestRunSession.h"
#import "XCTestCore/XCTTestRunSessionProvider.h"
#import "XCTestCore/XCTTestScheduler-Protocol.h"
#import "XCTestCore/XCTTestSchedulerWorker-Protocol.h"
#import "XCTestCore/XCTTestWorker-Protocol.h"
#import "XCTestCore/XCTUniformTypeIdentifier.h"
#import "XCTestCore/XCTUniformTypeIdentifier_Internal.h"
#import "XCTestCore/XCTVariationOptions.h"
#import "XCTestCore/XCTWaiter.h"
#import "XCTestCore/XCTWaiterDelegate-Protocol.h"
#import "XCTestCore/XCTWaiterInterruptionCompletionHandler.h"
#import "XCTestCore/XCTWaiterManagement-Protocol.h"
#import "XCTestCore/XCTWaiterManager-Protocol.h"
#import "XCTestCore/XCTWaiterManager.h"
#import "XCTestCore/XCTest.h"
#import "XCTestCore/XCTestCase.h"
#import "XCTestCore/XCTestCaseDiscoveryUIAutomationDelegate-Protocol.h"
#import "XCTestCore/XCTestCasePlaceholder.h"
#import "XCTestCore/XCTestCasePlaceholderRun.h"
#import "XCTestCore/XCTestCaseRun.h"
#import "XCTestCore/XCTestCaseRunConfiguration.h"
#import "XCTestCore/XCTestCaseSuite.h"
#import "XCTestCore/XCTestCaseUIAutomationDelegate-Protocol.h"
#import "XCTestCore/XCTestCastMethodNamesUIAutomationDelegate-Protocol.h"
#import "XCTestCore/XCTestConfiguration.h"
#import "XCTestCore/XCTestConfigurationLoader.h"
#import "XCTestCore/XCTestDriver.h"
#import "XCTestCore/XCTestDriverUIAutomationDelegate-Protocol.h"
#import "XCTestCore/XCTestExpectation.h"
#import "XCTestCore/XCTestExpectationDelegate-Protocol.h"
#import "XCTestCore/XCTestLog.h"
#import "XCTestCore/XCTestManager_DaemonConnectionInterface-Protocol.h"
#import "XCTestCore/XCTestManager_IDEInterface-Protocol.h"
#import "XCTestCore/XCTestMisuseObserver.h"
#import "XCTestCore/XCTestObservation-Protocol.h"
#import "XCTestCore/XCTestObservationCenter.h"
#import "XCTestCore/XCTestObserver.h"
#import "XCTestCore/XCTestProbe.h"
#import "XCTestCore/XCTestRun.h"
#import "XCTestCore/XCTestSuite.h"
#import "XCTestCore/XCTestSuiteRun.h"
#import "XCTestCore/XCUIApplicationManaging-Protocol.h"
#import "XCTestCore/XCUIXcodeApplicationManaging-Protocol.h"
#import "XCTestCore/_Dummy_ConformingToLegacyProtocolNames.h"
#import "XCTestCore/_XCTExceptionPointer.h"
#import "XCTestCore/_XCTMessaging_VoidProtocol-Protocol.h"
#import "XCTestCore/_XCTRunnerDaemonSessionDummyExportedObject.h"
#import "XCTestCore/_XCTSkipFailureException.h"
#import "XCTestCore/_XCTTestIdentifierPlaceholder.h"
#import "XCTestCore/_XCTTestIdentifierSet_Placeholder.h"
#import "XCTestCore/_XCTTestIdentifierSet_Set.h"
#import "XCTestCore/_XCTTestIdentifier_Array.h"
#import "XCTestCore/_XCTTestIdentifier_Class.h"
#import "XCTestCore/_XCTTestIdentifier_Class_LegacyEncoding.h"
#import "XCTestCore/_XCTTestIdentifier_Double.h"
#import "XCTestCore/_XCTTestIdentifier_Method_LegacyEncoding.h"
#import "XCTestCore/_XCTTestIdentifier_SingleContainer.h"
#import "XCTestCore/_XCTestCaseInterruptionException.h"
#import "XCTestCore/_XCTestObservationInternal-Protocol.h"
#import "XCTestCore/_XCTestObservationPrivate-Protocol.h"
#import "XCUIAutomation/CDStructures.h"
#import "XCUIAutomation/NSError-XCUIApplicationProcess.h"
#import "XCUIAutomation/XCAXClient_iOS.h"
#import "XCUIAutomation/XCActivityRecord-UITesting.h"
#import "XCUIAutomation/XCApplicationQuery.h"
#import "XCUIAutomation/XCElementSnapshot-XCUIElementAttributes.h"
#import "XCUIAutomation/XCPointerEvent.h"
#import "XCUIAutomation/XCPointerEventPath.h"
#import "XCUIAutomation/XCSourceCodeRecording.h"
#import "XCUIAutomation/XCSourceCodeTreeNode.h"
#import "XCUIAutomation/XCSourceCodeTreeNodeEnumerator.h"
#import "XCUIAutomation/XCSynthesizedEventRecord.h"
#import "XCUIAutomation/XCTApplicationBundleInfo-AutomaticTestRunConfigurations.h"
#import "XCUIAutomation/XCTAttachment-XCUIScreenshot_ConvenienceInitializers.h"
#import "XCUIAutomation/XCTCPUMetric-UIAutomation_Private.h"
#import "XCUIAutomation/XCTContext-XCUIInterruptionMonitor.h"
#import "XCUIAutomation/XCTElementSnapshotAttributeDataSource-Protocol.h"
#import "XCUIAutomation/XCTElementSnapshotProvider-Protocol.h"
#import "XCUIAutomation/XCTImageEncoding-XCTImageEncodingXCTImageQualityUIAutomationDelegate.h"
#import "XCUIAutomation/XCTIssueHandling-Protocol.h"
#import "XCUIAutomation/XCTMacCatalystStatusProviding-Protocol.h"
#import "XCUIAutomation/XCTMemoryChecker-XCUIAutomation.h"
#import "XCUIAutomation/XCTMemoryMetric-UIAutomation_Private.h"
#import "XCUIAutomation/XCTMessagingChannel_RunnerToUIProcess-Protocol.h"
#import "XCUIAutomation/XCTMessagingRole_UIApplicationStateUpdating-Protocol.h"
#import "XCUIAutomation/XCTMessagingRole_UIAutomationProcess-Protocol.h"
#import "XCUIAutomation/XCTMetricDiagnosticHelper-UIAutomation.h"
#import "XCUIAutomation/XCTNSPredicateExpectationObject-Protocol.h"
#import "XCUIAutomation/XCTRunnerAutomationSession-Protocol.h"
#import "XCUIAutomation/XCTRunnerAutomationSession.h"
#import "XCUIAutomation/XCTRunnerDaemonSession-XCUIPlatformApplicationServicesProviding.h"
#import "XCUIAutomation/XCTRunnerDaemonSessionEventRequest.h"
#import "XCUIAutomation/XCTRunnerIDESession-UIAutomation.h"
#import "XCUIAutomation/XCTRunnerIDESessionUIAutomationDelegate-Protocol.h"
#import "XCUIAutomation/XCTStorageMetric-UIAutomation_Private.h"
#import "XCUIAutomation/XCTestCase-UIAutomationDelegate.h"
#import "XCUIAutomation/XCTestCaseIssueHandlingUIAutomationDelegate-Protocol.h"
#import "XCUIAutomation/XCTestDriver-XCTTestRunSessionUIAutomationDelegate.h"
#import "XCUIAutomation/XCTestObservation-Protocol.h"
#import "XCUIAutomation/XCUIAXNotificationHandling-Protocol.h"
#import "XCUIAutomation/XCUIAccessibilityAction.h"
#import "XCUIAutomation/XCUIAccessibilityAudit.h"
#import "XCUIAutomation/XCUIAccessibilityAuditIssue.h"
#import "XCUIAutomation/XCUIAccessibilityInterface-Protocol.h"
#import "XCUIAutomation/XCUIApplication.h"
#import "XCUIAutomation/XCUIApplicationAutomationSessionProviding-Protocol.h"
#import "XCUIAutomation/XCUIApplicationImpl.h"
#import "XCUIAutomation/XCUIApplicationImplDepot.h"
#import "XCUIAutomation/XCUIApplicationManaging-Protocol.h"
#import "XCUIAutomation/XCUIApplicationMonitor-Protocol.h"
#import "XCUIAutomation/XCUIApplicationMonitor.h"
#import "XCUIAutomation/XCUIApplicationOpenRequest.h"
#import "XCUIAutomation/XCUIApplicationPlatformServicesProviderDelegate-Protocol.h"
#import "XCUIAutomation/XCUIApplicationProcess.h"
#import "XCUIAutomation/XCUIApplicationProcessDelegate-Protocol.h"
#import "XCUIAutomation/XCUIApplicationProcessManaging-Protocol.h"
#import "XCUIAutomation/XCUIApplicationProcessTracker-Protocol.h"
#import "XCUIAutomation/XCUIApplicationRegistry.h"
#import "XCUIAutomation/XCUIApplicationRegistryRecord.h"
#import "XCUIAutomation/XCUIApplicationSpecifier.h"
#import "XCUIAutomation/XCUIButtonConsole.h"
#import "XCUIAutomation/XCUICoordinate.h"
#import "XCUIAutomation/XCUIDefaultIssueHandler.h"
#import "XCUIAutomation/XCUIDevice.h"
#import "XCUIAutomation/XCUIDeviceAutomationModeInterface-Protocol.h"
#import "XCUIAutomation/XCUIDeviceEventAndStateInterface-Protocol.h"
#import "XCUIAutomation/XCUIDeviceSetupManager.h"
#import "XCUIAutomation/XCUIElement.h"
#import "XCUIAutomation/XCUIElementAttributes-Protocol.h"
#import "XCUIAutomation/XCUIElementAttributesPrivate-Protocol.h"
#import "XCUIAutomation/XCUIElementBaseEventTarget.h"
#import "XCUIAutomation/XCUIElementEmbeddedEventTarget.h"
#import "XCUIAutomation/XCUIElementEventTarget-Protocol.h"
#import "XCUIAutomation/XCUIElementHitPointCoordinate.h"
#import "XCUIAutomation/XCUIElementQuery.h"
#import "XCUIAutomation/XCUIElementSnapshot-Protocol.h"
#import "XCUIAutomation/XCUIElementSnapshotCoordinateTransforms-Protocol.h"
#import "XCUIAutomation/XCUIElementSnapshotProviding-Protocol.h"
#import "XCUIAutomation/XCUIElementTypeQueryProvider-Protocol.h"
#import "XCUIAutomation/XCUIElementTypeQueryProvider_Private-Protocol.h"
#import "XCUIAutomation/XCUIEventSynthesisRequest-Protocol.h"
#import "XCUIAutomation/XCUIHitPointResult.h"
#import "XCUIAutomation/XCUIInterruptionHandler.h"
#import "XCUIAutomation/XCUIInterruptionMonitor.h"
#import "XCUIAutomation/XCUIInterruptionMonitoring-Protocol.h"
#import "XCUIAutomation/XCUIIssueDiagnosticsProviding-Protocol.h"
#import "XCUIAutomation/XCUIKnobControl.h"
#import "XCUIAutomation/XCUILocalDeviceScreenDataSource.h"
#import "XCUIAutomation/XCUILocalDeviceScreenshotIPCInterface-Protocol.h"
#import "XCUIAutomation/XCUILocation.h"
#import "XCUIAutomation/XCUIPlatformApplicationManager.h"
#import "XCUIAutomation/XCUIPlatformApplicationServicesProviding-Protocol.h"
#import "XCUIAutomation/XCUIPointTransformationRequest.h"
#import "XCUIAutomation/XCUIRecorderNodeFinder.h"
#import "XCUIAutomation/XCUIRecorderNodeFinderMatch.h"
#import "XCUIAutomation/XCUIRecorderTimingMessage.h"
#import "XCUIAutomation/XCUIRecorderUtilities.h"
#import "XCUIAutomation/XCUIRectTransformationRequest.h"
#import "XCUIAutomation/XCUIRemoteAccessibilityInterface-Protocol.h"
#import "XCUIAutomation/XCUIRemoteSiriInterface-Protocol.h"
#import "XCUIAutomation/XCUIResetAuthorizationStatusOfProtectedResourcesInterface-Protocol.h"
#import "XCUIAutomation/XCUIScreen.h"
#import "XCUIAutomation/XCUIScreenDataSource-Protocol.h"
#import "XCUIAutomation/XCUIScreenshot.h"
#import "XCUIAutomation/XCUIScreenshotProviding-Protocol.h"
#import "XCUIAutomation/XCUISiriService.h"
#import "XCUIAutomation/XCUISnapshotGenerationTracker.h"
#import "XCUIAutomation/XCUISystem.h"
#import "XCUIAutomation/XCUITransformParameters.h"
#import "XCUIAutomation/_XCTMessaging_VoidProtocol-Protocol.h"
#endif

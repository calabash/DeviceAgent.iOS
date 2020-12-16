// class-dump results processed by bin/class-dump/dump.rb
//
//     Generated by class-dump 3.5 (64 bit) (Debug version compiled Nov 26 2020 14:08:26).
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

#import "XCTIssueHandling-Protocol.h"

@class NSArray, NSDictionary, NSMutableArray, NSMutableDictionary, NSString, XCTTestIdentifier, XCTestConfiguration;

@interface XCTestSuite : XCTest <XCTIssueHandling>
{
    NSString *_name;
    XCTTestIdentifier *_identifier;
    NSMutableArray *_mutableTests;
    XCTestConfiguration *_testConfiguration;
    NSMutableDictionary *_mutableActivityAggregateStatistics;
}

@property(readonly, copy) XCTTestIdentifier *_identifier;
@property(readonly) NSDictionary *activityAggregateStatistics;
@property(readonly) NSMutableDictionary *mutableActivityAggregateStatistics;
@property(retain) NSMutableArray *mutableTests;
@property(copy) NSString *name;
@property(retain) XCTestConfiguration *testConfiguration;
@property(readonly, copy) NSArray *tests;

+ (void)_applyRandomExecutionOrderingSeed:(id)arg1;
+ (id)_suiteForBundleCache;
+ (id)allTests;
+ (id)defaultTestSuite;
+ (id)emptyTestSuiteNamedFromPath:(id)arg1;
+ (void)invalidateCache;
+ (id)suiteForBundleCache;
+ (id)testCaseNamesForScopeNames:(id)arg1;
+ (id)testClassSuitesForTestIdentifiers:(id)arg1 skippingTestIdentifiers:(id)arg2 testExecutionOrdering:(NSInteger)arg3;
+ (id)testSuiteForBundlePath:(id)arg1;
+ (id)testSuiteForTestCaseClass:(Class)arg1;
+ (id)testSuiteForTestCaseWithName:(id)arg1;
+ (id)testSuiteForTestConfiguration:(id)arg1;
+ (id)testSuiteWithName:(id)arg1;
- (void)_applyRandomExecutionOrdering;
- (id)_initWithTestConfiguration:(id)arg1;
- (void)_mergeActivityStatistics:(id)arg1;
- (void)_performProtectedSectionForTest:(id)arg1 testSection:(CDUnknownBlockType)arg2;
- (void)_recordUnexpectedFailureForTestRun:(id)arg1 description:(id)arg2 exception:(id)arg3;
- (Class)_requiredTestRunBaseClass;
- (void)_sortTestsUsingDefaultExecutionOrdering;
- (id)_testSuiteWithIdentifier:(id)arg1;
- (void)addTest:(id)arg1;
- (NSInteger)defaultExecutionOrderCompare:(id)arg1;
- (void)handleIssue:(id)arg1;
- (id)initWithName:(id)arg1;
- (void)performTest:(id)arg1;
- (void)recordFailureWithDescription:(id)arg1 inFile:(id)arg2 atLine:(NSUInteger)arg3 expected:(BOOL)arg4;
- (void)removeTestsWithNames:(id)arg1;
- (void)setTests:(id)arg1;
- (NSUInteger)testCaseCount;
- (Class)testRunClass;


@end


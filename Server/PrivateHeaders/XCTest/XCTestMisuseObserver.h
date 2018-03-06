// class-dump results processed by bin/class-dump/dump.rb
//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//


#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <XCTest/XCUIElementTypes.h>
#import "CDStructures.h"
@protocol OS_dispatch_queue;
@protocol OS_xpc_object;

#import "XCTestObservation-Protocol.h"

@class NSMutableArray, NSString, XCTestCase, XCTestSuite;

@interface XCTestMisuseObserver : NSObject <XCTestObservation>
{
    CDUnknownBlockType _warningLogHandler;
    NSMutableArray *_testSuiteStack;
    XCTestCase *_currentTestCase;
}

@property(retain) XCTestCase *currentTestCase;
@property(readonly) XCTestSuite *currentTestSuite;
@property(readonly) NSMutableArray *testSuiteStack;
@property(readonly, copy) CDUnknownBlockType warningLogHandler;

- (void)emitWarningLog:(id)arg1;
- (id)initWithWarningLogHandler:(CDUnknownBlockType)arg1;
- (void)popCurrentTestSuite;
- (void)pushTestSuite:(id)arg1;
- (void)removeTestSuiteFromStack:(id)arg1;
- (void)testCase:(id)arg1 didFailWithDescription:(id)arg2 inFile:(id)arg3 atLine:(NSUInteger)arg4;
- (void)testCaseDidFinish:(id)arg1;
- (void)testCaseWillStart:(id)arg1;
- (void)testSuiteDidFinish:(id)arg1;
- (BOOL)testSuiteStackContainsTestSuite:(id)arg1;
- (void)testSuiteWillStart:(id)arg1;


@end

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

#import <objc/NSObject.h>

@class NSString, XCActivityRecord, XCTTestIdentifier;
@protocol XCTMessagingRole_TestReporting, XCTMessagingRole_ActivityReporting, _XCTMessaging_VoidProtocol;

@interface XCTReportingSessionActivityReporter : NSObject
{
    NSString *_name;
    XCTTestIdentifier *_testIdentifier;
    XCActivityRecord *_activityRecord;
    id <XCTMessagingRole_TestReporting, XCTMessagingRole_ActivityReporting, _XCTMessaging_VoidProtocol> _IDEProxy;
}

@property(readonly) NSString *name;

- (void)finishAtDate:(id)arg1;
- (id)reportActivityStartedWithName:(id)arg1 atDate:(id)arg2;
- (void)reportAttachment:(id)arg1 atDate:(id)arg2;

@end


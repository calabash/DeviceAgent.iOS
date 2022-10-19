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

#import "XCTRemoteSignpostListenerProxy-Protocol.h"
#import "XCTRunnerDaemonSessionUIAutomationDelegate-Protocol.h"

@class NSMutableDictionary, NSString, NSXPCConnection, XCTCapabilities;
@protocol OS_dispatch_queue, XCTMessagingChannel_RunnerToDaemon, XCTSignpostListener, XCUIAXNotificationHandling, XCUIApplicationPlatformServicesProviderDelegate;


@protocol XCUIAXNotificationHandling;

@interface XCTRunnerDaemonSession : NSObject <XCTRunnerDaemonSessionUIAutomationDelegate, XCTRemoteSignpostListenerProxy>
{
    id <XCTSignpostListener> _signpostListener;
    NSXPCConnection *_connection;
    XCTCapabilities *_remoteInterfaceCapabilities;
    NSObject<OS_dispatch_queue> *_queue;
    NSMutableDictionary *_invalidationHandlers;
}

@property(readonly) NSXPCConnection *connection;
@property(readonly) id <XCTMessagingChannel_RunnerToDaemon> daemonProxy;
@property(retain) NSMutableDictionary *invalidationHandlers;
@property(readonly) NSObject<OS_dispatch_queue> *queue;
@property(readonly) XCTCapabilities *remoteInterfaceCapabilities;
@property __weak id <XCTSignpostListener> signpostListener;
@property(readonly) BOOL supportsPostingTelemetryData;
@property(readonly) BOOL supportsSignpostListening;
@property __weak id <XCUIAXNotificationHandling> axNotificationHandler;
@property __weak id <XCUIApplicationPlatformServicesProviderDelegate> platformApplicationServicesProviderDelegate;
@property(readonly) BOOL useLegacyEventCoordinateTransformationPath;
@property(readonly) BOOL usePointTransformationsForFrameConversions;

+ (void)capabilitiesForDaemonConnection:(id)arg1 completion:(CDUnknownBlockType)arg2;
+ (id)connectionForInitiatingSharedSession;
+ (void)initiateSessionWithCompletion:(CDUnknownBlockType)arg1;
+ (void)initiateSharedSessionWithCompletion:(CDUnknownBlockType)arg1;
+ (void)sessionWithConnection:(id)arg1 completion:(CDUnknownBlockType)arg2;
+ (id)sharedSession;
+ (id)sharedSessionIfInitiated;
+ (id)sharedSessionPromiseAndImplicitlyInitiateSession:(BOOL)arg1;
+ (id)testmanagerdServiceName;
- (void)_XCT_receivedAccessibilityNotification:(NSInteger)arg1 fromElement:(id)arg2 payload:(id)arg3;
- (void)_XCT_receivedAccessibilityNotification:(NSInteger)arg1 withPayload:(id)arg2;
- (void)_XCT_receivedSignpost:(id)arg1 withToken:(id)arg2;
- (void)_reportInvalidation;
- (id)initWithConnection:(id)arg1 remoteInterfaceCapabilities:(id)arg2;
- (void)postTelemetryData:(id)arg1 reply:(CDUnknownBlockType)arg2;
- (void)registerForSignpostsFromSubsystem:(id)arg1 category:(id)arg2 intervalTimeout:(double)arg3 reply:(CDUnknownBlockType)arg4;
- (id)registerInvalidationHandler:(CDUnknownBlockType)arg1;
- (void)requestDTServiceHubConnectionWithReply:(CDUnknownBlockType)arg1;
- (void)requestIDEConnectionTransportForSessionIdentifier:(id)arg1 reply:(CDUnknownBlockType)arg2;
- (void)requestSpindumpWithSpecification:(id)arg1 completion:(CDUnknownBlockType)arg2;
- (void)requestTailspinWithRequest:(id)arg1 completion:(CDUnknownBlockType)arg2;
- (void)unregisterForSignpostsWithToken:(id)arg1;
- (void)unregisterInvalidationHandlerWithToken:(id)arg1;


@end


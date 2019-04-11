// class-dump results processed by bin/class-dump/dump.rb
//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2015 by Steve Nygard.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <XCTest/XCUIElementTypes.h>
#import "CDStructures.h"
@protocol OS_dispatch_queue;
@protocol OS_xpc_object;

#import <objc/NSObject.h>

@class NSString, XCUIApplication;
@protocol XCUIDevice, XCUIRemoteSiriInterface;

@interface XCUISiriService : NSObject
{
    XCUIApplication *_siriApplication;
    id <XCUIDevice> _device;
    id <XCUIRemoteSiriInterface> _remoteSiriInterface;
}

@property(readonly) id <XCUIDevice> device;
@property(readonly, getter=isEnabled) BOOL enabled;
@property(readonly) id <XCUIRemoteSiriInterface> remoteSiriInterface;
@property(readonly) XCUIApplication *siriApplication;

- (void)_assertSiriEnabled;
- (void)_waitForActivation;
- (void)activateWithVoiceRecognitionText:(id)arg1;
- (id)forwardingTargetForSelector:(SEL)arg1;
- (id)initWithDevice:(id)arg1 remoteSiriInterface:(id)arg2;
- (void)injectAssistantRecognitionStrings:(id)arg1;
- (void)injectVoiceRecognitionAudioInputPaths:(id)arg1;

@end


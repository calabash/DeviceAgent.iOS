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

@class NSArray, NSString, NSURL;

@protocol XCTMessagingRole_SiriAutomation
- (void)_XCT_injectAssistantRecognitionStrings:(NSArray *)arg1 completion:(void (^)(BOOL, NSError *))arg2;
- (void)_XCT_injectVoiceRecognitionAudioInputPaths:(NSArray *)arg1 completion:(void (^)(BOOL, NSError *))arg2;
- (void)_XCT_requestSiriEnabledStatus:(void (^)(BOOL, NSError *))arg1;
- (void)_XCT_startSiriUIRequestWithAudioFileURL:(NSURL *)arg1 completion:(void (^)(BOOL, NSError *))arg2;
- (void)_XCT_startSiriUIRequestWithText:(NSString *)arg1 completion:(void (^)(BOOL, NSError *))arg2;
@end


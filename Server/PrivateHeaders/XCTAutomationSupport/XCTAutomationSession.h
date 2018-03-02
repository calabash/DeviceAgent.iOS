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

#import "XCTAutomationTarget.h"
#import "XCTConnectionAccepting.h"

@class NSMutableArray, NSString, XCTElementQueryProcessor;

@interface XCTAutomationSession : NSObject <XCTConnectionAccepting, XCTAutomationTarget>
{
    NSMutableArray *_connections;
    XCTElementQueryProcessor *_queryProcessor;
}

@property(retain) NSMutableArray *connections;
@property(retain) XCTElementQueryProcessor *queryProcessor;

- (BOOL)acceptNewConnection:(id)arg1;
- (void)fetchMatchesForQuery:(id)arg1 reply:(CDUnknownBlockType)arg2;
- (void)requestHostAppExecutableNameWithReply:(CDUnknownBlockType)arg1;


@end


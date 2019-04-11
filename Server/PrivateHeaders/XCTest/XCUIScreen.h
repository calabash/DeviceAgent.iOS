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

#import "XCUIScreenshotProviding-Protocol.h"

@protocol XCUIDevice, XCUIScreenDataSource;

@interface XCUIScreen : NSObject <XCUIScreenshotProviding>
{
    BOOL _isMainScreen;
    NSInteger _displayID;
    id <XCUIDevice> _device;
    id <XCUIScreenDataSource> _screenDataSource;
}

@property(readonly) __weak id <XCUIDevice> device;
@property(readonly) NSInteger displayID;
@property(readonly) BOOL isMainScreen;
@property(readonly) double scale;
@property(readonly) id <XCUIScreenDataSource> screenDataSource;

+ (id)mainScreen;
+ (id)screens;
- (id)_screenshotDataForQuality:(NSInteger)arg1 rect:(CGRect)arg2 error:(id *)arg3;
- (id)initWithDisplayID:(NSInteger)arg1 isMainScreen:(BOOL)arg2 device:(id)arg3 screenDataSource:(id)arg4;
- (id)screenshot;
- (id)screenshotDataForQuality:(NSInteger)arg1 rect:(CGRect)arg2 error:(id *)arg3;


@end


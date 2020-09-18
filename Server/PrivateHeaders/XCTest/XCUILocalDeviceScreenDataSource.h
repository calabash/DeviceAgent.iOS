// class-dump results processed by bin/class-dump/dump.rb
//
//     Generated by class-dump 3.5 (64 bit) (Debug version compiled Apr 12 2019 07:16:25).
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

#import "XCUIScreenDataSource-Protocol.h"


@interface XCUILocalDeviceScreenDataSource : NSObject <XCUIScreenDataSource>
{
}

- (id)HEICData:(struct CGImage *)arg1 compressionQuality:(double)arg2;
- (id)_clippedScreenshotData:(id)arg1 compressionQuality:(double)arg2 rect:(CGRect)arg3 scale:(double)arg4;
- (void)requestScaleForScreenWithIdentifier:(NSInteger)arg1 completion:(CDUnknownBlockType)arg2;
- (void)requestScreenIdentifiersWithCompletion:(CDUnknownBlockType)arg1;
- (void)requestScreenshotOfScreenWithID:(NSInteger)arg1 withRect:(CGRect)arg2 scale:(double)arg3 formatUTI:(id)arg4 compressionQuality:(double)arg5 withReply:(CDUnknownBlockType)arg6;


@end


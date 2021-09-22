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

#import <DTXConnectionServices/NSObject-Protocol.h>

@protocol DTXBlockCompressor <NSObject>
- (NSUInteger)compressBuffer:(const char *)arg1 ofLength:(NSUInteger)arg2 toBuffer:(char *)arg3 ofLength:(NSUInteger)arg4 usingCompressionType:(NSInteger)arg5 withFinalCompressionType:(NSInteger *)arg6;
- (BOOL)uncompressBuffer:(const char *)arg1 ofLength:(NSUInteger)arg2 toBuffer:(char *)arg3 withKnownUncompressedLength:(NSUInteger)arg4 usingCompressionType:(NSInteger)arg5;
@end


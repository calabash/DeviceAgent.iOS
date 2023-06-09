// class-dump results processed by bin/class-dump/dump.rb
//
//     Generated by classdump-c 4.2.0 (64 bit) (iOS port by DreamDevLost, Updated by Kevin Bradley.)(Debug version compiled May 27 2023 00:50:17).
//
//  Copyright (C) 1997-2019 Steve Nygard. Updated in 2022 by Kevin Bradley.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <XCTest/XCUIElementTypes.h>
#import "CDStructures.h"
@protocol OS_dispatch_queue;
@protocol OS_xpc_object;

#import <objc/NSObject.h>
#import <stdatomic.h>

#import "XCTSymbolInfoProviding-Protocol.h"

@class NSSet, NSString;

@interface XCTInProcessSymbolicationService : NSObject <XCTSymbolInfoProviding>
{
    struct atomic_flag _symbolicatorInitialized;
    NSSet *_imageNames;
    CDStruct_37ea9563 _symbolicator;
    CDStruct_37ea9563 _symbolicationFunctions;
}

@property(readonly, copy) NSSet *imageNames;
@property(readonly) NSSet *symbolInfoImageNames;
@property(readonly) CDStruct_37ea9563 symbolicationFunctions;
@property(readonly) struct _CSTypeRef symbolicator;
@property(readonly) struct atomic_flag symbolicatorInitialized;

+ (id)imageNamesFromEnvironmentVariables:(id)arg1;
+ (void)registerSharedServiceWithConfiguration:(id)arg1;
- (void)_prepareForSymbolication;
- (id)initWithImageNames:(id)arg1;
- (id)initWithImageNames:(id)arg1 symbolicationFunctions:(CDStruct_37ea9563)arg2;
- (id)symbolInfoForAddressInCurrentProcess:(NSUInteger)arg1 error:(id *)arg2;
- (id)symbolInfoForImageOffset:(NSUInteger)arg1 forImageWithPath:(id)arg2 andArch:(id)arg3 error:(id *)arg4;
- (id)symbolInfoForImageOffset:(NSUInteger)arg1 inImageWithUUID:(id)arg2 error:(id *)arg3;


@end


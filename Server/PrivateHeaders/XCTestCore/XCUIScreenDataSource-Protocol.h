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

@class XCTImageEncoding;

@protocol XCUIScreenDataSource <NSObject>
- (void)requestScaleForScreenWithIdentifier:(NSInteger)arg1 completion:(void (^)(double, NSError *))arg2;
- (void)requestScreenIdentifiersWithCompletion:(void (^)(NSArray *, NSError *))arg1;
- (void)requestScreenshotOfScreenWithID:(NSInteger)arg1 withRect:(CGRect)arg2 encoding:(XCTImageEncoding *)arg3 withReply:(void (^)(XCTImage *, NSError *))arg4;
@end

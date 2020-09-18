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


@class NSArray, NSDate, NSError, NSString, XCTSourceCodeContext;

@interface XCTIssue : NSObject <NSCopying, NSMutableCopying, NSSecureCoding>
{
    struct atomic_flag _failureBreakPointCalled;
    BOOL _didInterruptTest;
    BOOL _shouldInterruptTest;
    NSInteger _type;
    NSString *_compactDescription;
    NSString *_detailedDescription;
    XCTSourceCodeContext *_sourceCodeContext;
    NSError *_associatedError;
    NSArray *_attachments;
    NSDate *_timestamp;
}

@property(retain) NSError *associatedError;
@property(copy) NSArray *attachments;
@property(copy) NSString *compactDescription;
@property(copy) NSString *detailedDescription;
@property BOOL didInterruptTest;
@property struct atomic_flag failureBreakPointCalled;
@property(readonly) BOOL isFailure;
@property(readonly) BOOL isLegacyExpectedFailure;
@property BOOL shouldInterruptTest;
@property(retain) XCTSourceCodeContext *sourceCodeContext;
@property(copy) NSDate *timestamp;
@property NSInteger type;

+ (id)issueWithException:(id)arg1;
+ (id)issueWithType:(NSInteger)arg1 compactDescription:(id)arg2 associatedError:(id)arg3;
+ (id)issueWithType:(NSInteger)arg1 compactDescription:(id)arg2 callStackAddresses:(id)arg3 filePath:(id)arg4 lineNumber:(NSInteger)arg5;
- (void)_updateAttachmentsTimestamps;
- (id)initWithType:(NSInteger)arg1 compactDescription:(id)arg2;
- (id)initWithType:(NSInteger)arg1 compactDescription:(id)arg2 detailedDescription:(id)arg3 sourceCodeContext:(id)arg4 associatedError:(id)arg5 attachments:(id)arg6;
- (BOOL)matchesLegacyPropertiesOfIssue:(id)arg1;
- (id)mutableCopyWithZone:(struct _NSZone *)arg1;

@end


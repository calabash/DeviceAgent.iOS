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

#import "XCTIssue.h"

@class NSArray, NSDate, NSError, NSMutableArray, NSString, XCTSourceCodeContext;

@interface XCTMutableIssue : XCTIssue
{
    NSMutableArray *_mutableAttachments;
}

@property(copy) NSArray *attachments;
@property(retain) NSError *associatedError; // @dynamic associatedError;
@property(copy) NSString *compactDescription; // @dynamic compactDescription;
@property(copy) NSString *detailedDescription; // @dynamic detailedDescription;
@property(retain) XCTSourceCodeContext *sourceCodeContext; // @dynamic sourceCodeContext;
@property(copy) NSDate *timestamp; // @dynamic timestamp;
@property NSInteger type; // @dynamic type;

- (void)addAttachment:(id)arg1;
- (id)initWithType:(NSInteger)arg1 compactDescription:(id)arg2 detailedDescription:(id)arg3 sourceCodeContext:(id)arg4 associatedError:(id)arg5 attachments:(id)arg6;


@end


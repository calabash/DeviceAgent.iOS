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

#import <objc/NSObject.h>


@class NSArray;

@interface XCAXAuditConfiguration : NSObject <NSSecureCoding, NSCopying>
{
    NSArray *_auditTypes;
    NSArray *_ignoredIdentifiers;
    NSInteger _timeout;
}

@property(copy, nonatomic) NSArray *auditTypes;
@property(copy, nonatomic) NSArray *ignoredIdentifiers;
@property(nonatomic) NSInteger timeout;


@end


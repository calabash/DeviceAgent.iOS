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

#import "XCTElementSetTransformer-Protocol.h"


@interface XCTElementBlockSortingTransformer : NSObject <XCTElementSetTransformer>
{
    BOOL stopsOnFirstMatch;
    NSString *transformationDescription;
    CDUnknownBlockType _comparator;
}

@property(readonly, copy) CDUnknownBlockType comparator;
@property BOOL stopsOnFirstMatch;
@property(copy) NSString *transformationDescription;
@property(readonly) BOOL supportsAttributeKeyPathAnalysis;
@property(readonly) BOOL supportsRemoteEvaluation;

- (id)initWithComparator:(CDUnknownBlockType)arg1;
- (id)iteratorForInput:(id)arg1;
- (id)requiredKeyPathsOrError:(id *)arg1;
- (id)transform:(id)arg1 relatedElements:(id *)arg2;


@end


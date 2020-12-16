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

#import "XCTElementSetCodableTransformer.h"

@class XCTIndexingTransformerIterator;

@interface XCTElementIndexingTransformer : XCTElementSetCodableTransformer
{
    NSUInteger _elementIndex;
    XCTIndexingTransformerIterator *_currentIterator;
}

@property(retain) XCTIndexingTransformerIterator *currentIterator;
@property(readonly) NSUInteger elementIndex;

+ (void)provideCapabilitiesToBuilder:(id)arg1;
- (BOOL)canBeRemotelyEvaluatedWithCapabilities:(id)arg1;
- (id)initWithElementIndex:(NSUInteger)arg1;
- (id)iteratorForInput:(id)arg1;
- (id)requiredKeyPathsOrError:(id *)arg1;
- (BOOL)supportsAttributeKeyPathAnalysis;
- (id)transform:(id)arg1 relatedElements:(id *)arg2;

@end


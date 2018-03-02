// class-dump results processed by bin/class-dump/dump.rb
//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//


#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <XCTest/XCUIElementTypes.h>
#import "CDStructures.h"
@protocol OS_dispatch_queue;
@protocol OS_xpc_object;

#import "XCTMatchingElementIterator.h"

@class NSSet, NSString, XCElementSnapshot, XCTElementIndexingTransformer;


@protocol XCTElementSetTransformer;

@interface XCTIndexingTransformerIterator : NSObject <XCTMatchingElementIterator>
{
    BOOL _hasMatched;
    XCElementSnapshot *_input;
    id <XCTElementSetTransformer> _transformer;
    XCElementSnapshot *_currentMatch;
    XCTElementIndexingTransformer *_indexingTransformer;
    NSUInteger _count;
}

@property NSUInteger count;
@property(retain) XCElementSnapshot *currentMatch;
@property(readonly) NSSet *currentRelatedElements;
@property(readonly) BOOL hasMatched;
@property(readonly) XCTElementIndexingTransformer *indexingTransformer;
@property(retain) XCElementSnapshot *input;
@property(readonly) id <XCTElementSetTransformer> transformer;

- (id)initWithInput:(id)arg1 filteringTransformer:(id)arg2;
- (id)nextMatch;


@end


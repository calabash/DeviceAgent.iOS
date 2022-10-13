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

#import "XCTMatchingElementIterator-Protocol.h"

@class NSEnumerator, NSSet, NSString, XCElementSnapshot;
@protocol XCTElementSetTransformer;


@protocol XCTElementSetTransformer;

@interface XCTMatchingElementIterator : NSObject <XCTMatchingElementIterator>
{
    NSEnumerator *_outputEnumerator;
    XCElementSnapshot * _input;
    id <XCTElementSetTransformer> _transformer;
    XCElementSnapshot * _currentMatch;
    NSSet *_currentRelatedElements;
}

@property(retain) XCElementSnapshot * currentMatch;
@property(retain) NSSet *currentRelatedElements;
@property(readonly) XCElementSnapshot * input;
@property(readonly) id <XCTElementSetTransformer> transformer;

- (id)initWithInput:(id)arg1 transformer:(id)arg2;
- (id)nextMatch;


@end


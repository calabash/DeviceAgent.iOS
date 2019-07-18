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

@interface XCUIApplicationSpecifier : NSObject <NSCopying>
{
    NSString *_bundleIdentifier;
    NSString *_path;
}

@property(readonly) NSString *bundleIdentifier;
@property(readonly) NSString *path;

+ (id)specifierWithBundleIdentifier:(id)arg1 path:(id)arg2;
- (id)initWithBundleIdentifier:(id)arg1 path:(id)arg2;

@end


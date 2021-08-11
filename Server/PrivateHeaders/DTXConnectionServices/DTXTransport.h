//
//     Generated by class-dump 3.5 (64 bit) (Debug version compiled Nov 26 2020 14:08:26).
//
//  Copyright (C) 1997-2019 Steve Nygard.
//

#import <objc/NSObject.h>

@class DTXResourceTracker, NSArray;
@protocol OS_dispatch_queue;

@interface DTXTransport : NSObject
{
    NSObject<OS_dispatch_queue> *_serializer;
    NSObject<OS_dispatch_queue> *_handlerGuard;
    DTXResourceTracker *_tracker;
    CDUnknownBlockType _dataReceivedHandler;
    unsigned int _status;
    _Bool _resumed;
}

+ (BOOL)recognizesURL:(id)arg1;
+ (id)schemes;
- (void).cxx_destruct;
@property(copy, nonatomic) CDUnknownBlockType dataReceivedHandler;
- (void)dealloc;
- (void)disconnect;
- (id)init;
- (id)initWithRemoteAddress:(id)arg1;
- (id)initWithXPCRepresentation:(id)arg1;
@property(readonly) NSArray *localAddresses;
- (id)permittedBlockCompressionTypes;
- (void)received:(const char *)arg1 ofLength:(unsigned long long)arg2 destructor:(CDUnknownBlockType)arg3;
@property(readonly, nonatomic) DTXResourceTracker *resourceTracker; // @synthesize resourceTracker=_tracker;
- (void)serializedDisconnect:(CDUnknownBlockType)arg1;
- (id)serializedXPCRepresentation;
@property unsigned int status; // @synthesize status=_status;
- (unsigned int)supportedDirections;
- (unsigned long long)transmit:(const void *)arg1 ofLength:(unsigned long long)arg2;

@end

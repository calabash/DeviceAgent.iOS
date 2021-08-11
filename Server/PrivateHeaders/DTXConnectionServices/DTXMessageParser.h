//
//     Generated by class-dump 3.5 (64 bit) (Debug version compiled Nov 26 2020 14:08:26).
//
//  Copyright (C) 1997-2019 Steve Nygard.
//

#import <objc/NSObject.h>

@class NSMutableDictionary;
@protocol DTXBlockCompressor, OS_dispatch_queue;

@interface DTXMessageParser : NSObject
{
    const char *_parsingBuffer;
    unsigned long long _parsingBufferUsed;
    unsigned long long _parsingBufferSize;
    CDUnknownBlockType _exceptionHandler;
    CDUnknownBlockType _parsedMessageHandler;
    _Bool _eof;
    NSObject<OS_dispatch_queue> *_parsingQueue;
    NSMutableDictionary *_fragmentedBuffersByIdentifier;
    id <DTXBlockCompressor> _compressor;
}

- (void).cxx_destruct;
- (void)_messageParsedWithHeader:(struct DTXMessageHeader)arg1 bytes:(const void *)arg2 length:(unsigned long long)arg3 destructor:(CDUnknownBlockType)arg4;
- (void)dealloc;
- (id)initWithMessageHandler:(CDUnknownBlockType)arg1 andParseExceptionHandler:(CDUnknownBlockType)arg2;
- (void)parseIncomingBytes:(const char *)arg1 length:(unsigned long long)arg2;
- (id)parsingComplete;
- (void)replaceCompressor:(id)arg1;

@end


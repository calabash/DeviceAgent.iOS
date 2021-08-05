//
//     Generated by class-dump 3.5 (64 bit) (Debug version compiled Nov 26 2020 14:08:26).
//
//  Copyright (C) 1997-2019 Steve Nygard.
//

#import <objc/NSObject.h>

@class NSData, NSDictionary, NSError;
@protocol NSSecureCoding><NSObject;

@interface DTXMessage : NSObject
{
    unsigned int _messageType;
    int _compressionType;
    unsigned int _status;
    NSData *_payloadData;
    unsigned long long _cost;
    NSData *_serializedData;
    id <NSSecureCoding><NSObject> _payloadObject;
    void *_auxiliary;
    _Atomic _Bool _immutable;
    BOOL _deserialized;
    BOOL _expectsReply;
    unsigned int _identifier;
    unsigned int _channelCode;
    unsigned int _conversationIndex;
    NSDictionary *_auxiliaryPromoted;
}

+ (id)defaultAllowedSecureCodingClasses;
+ (_Bool)extractSerializedCompressionInfoFromBuffer:(const char *)arg1 length:(unsigned long long)arg2 compressionType:(int *)arg3 uncompressedLength:(unsigned long long *)arg4 compressedDataOffset:(unsigned long long *)arg5;
+ (void)initialize;
+ (id)message;
+ (id)messageReferencingBuffer:(const void *)arg1 length:(unsigned long long)arg2 destructor:(CDUnknownBlockType)arg3;
+ (id)messageWithBuffer:(const void *)arg1 length:(unsigned long long)arg2;
+ (id)messageWithData:(id)arg1;
+ (id)messageWithError:(id)arg1;
+ (id)messageWithObject:(id)arg1;
+ (id)messageWithPrimitive:(void *)arg1;
+ (id)messageWithSelector:(SEL)arg1 arguments:(id)arg2;
+ (id)messageWithSelector:(SEL)arg1 objectArguments:(id)arg2;
+ (id)messageWithSelector:(SEL)arg1 typesAndArguments:(unsigned int)arg2;
+ (void)setReportCompressionBlock:(CDUnknownBlockType)arg1;
- (void).cxx_destruct;
- (void)_appendTypesAndValues:(unsigned int)arg1 withKey:(id)arg2 list:(struct __va_list_tag [1])arg3;
- (id)_decompressedData:(id)arg1 compressor:(id)arg2 compressionType:(int)arg3;
- (id)_faultAuxiliaryValueOfType:(Class)arg1 forKey:(id)arg2;
- (id)_initWithReferencedSerializedForm:(id)arg1 compressor:(id)arg2 payloadSet:(CDUnknownBlockType)arg3;
- (void)_makeBarrier;
- (void)_makeImmutable;
- (id)_mutableAuxiliaryDictionary;
- (void)_setPayloadBuffer:(const char *)arg1 length:(unsigned long long)arg2 shouldCopy:(BOOL)arg3 destructor:(CDUnknownBlockType)arg4;
- (void)_willModifyAuxiliary;
@property(nonatomic) unsigned int channelCode; // @synthesize channelCode=_channelCode;
- (void)compressWithCompressor:(id)arg1 usingType:(int)arg2 forCompatibilityWithVersion:(long long)arg3;
@property(nonatomic) unsigned int conversationIndex; // @synthesize conversationIndex=_conversationIndex;
@property(readonly, nonatomic) unsigned long long cost; // @synthesize cost=_cost;
@property(readonly, nonatomic) NSData *data; // @synthesize data=_payloadData;
- (id)dataForMessageKey:(id)arg1;
- (void)dealloc;
- (id)description;
- (id)descriptionWithRoutingInformation:(struct DTXMessageRoutingInfo)arg1;
@property(readonly, nonatomic) BOOL deserialized; // @synthesize deserialized=_deserialized;
@property(retain, nonatomic) NSError *error;
@property(nonatomic) unsigned int errorStatus; // @synthesize errorStatus=_status;
@property(nonatomic) BOOL expectsReply; // @synthesize expectsReply=_expectsReply;
- (const void *)getBufferWithReturnedLength:(unsigned long long *)arg1;
@property(nonatomic) unsigned int identifier; // @synthesize identifier=_identifier;
- (id)initWithInvocation:(id)arg1;
- (id)initWithSelector:(SEL)arg1 firstArg:(id)arg2 remainingObjectArgs:(struct __va_list_tag [1])arg3;
- (id)initWithSelector:(SEL)arg1 objects:(id)arg2;
- (id)initWithSerializedForm:(id)arg1 compressor:(id)arg2;
- (id)initWithSerializedForm:(const char *)arg1 length:(unsigned long long)arg2 destructor:(CDUnknownBlockType)arg3 compressor:(id)arg4;
- (long long)integerForMessageKey:(id)arg1;
- (void)invokeWithTarget:(id)arg1 replyChannel:(id)arg2 validator:(CDUnknownBlockType)arg3;
@property(readonly, nonatomic) BOOL isBarrier;
@property(readonly, nonatomic) BOOL isDispatch;
@property(nonatomic) unsigned int messageType;
- (id)newReply;
- (id)newReplyReferencingBuffer:(const void *)arg1 length:(unsigned long long)arg2 destructor:(CDUnknownBlockType)arg3;
- (id)newReplyWithError:(id)arg1;
- (id)newReplyWithMessage:(id)arg1;
- (id)newReplyWithObject:(id)arg1;
@property(readonly, nonatomic) id <NSSecureCoding><NSObject> object;
- (id)objectWithAllowedClasses:(id)arg1;
@property(copy, nonatomic) id <NSSecureCoding><NSObject> payloadObject;
- (void)serializedFormApply:(CDUnknownBlockType)arg1;
@property(readonly, nonatomic) unsigned long long serializedLength;
- (void)setData:(id)arg1 forMessageKey:(id)arg2;
- (void)setInteger:(long long)arg1 forMessageKey:(id)arg2;
- (void)setObject:(id)arg1 forMessageKey:(id)arg2;
- (void)setString:(id)arg1 forMessageKey:(id)arg2;
- (BOOL)shouldInvokeWithTarget:(id)arg1;
- (id)stringForMessageKey:(id)arg1;
- (id)valueForMessageKey:(id)arg1;

@end


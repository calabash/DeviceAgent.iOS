//
//     Generated by class-dump 3.5 (64 bit) (Debug version compiled Nov 26 2020 14:08:26).
//
//  Copyright (C) 1997-2019 Steve Nygard.
//

#import <objc/NSObject.h>

@interface DTXRemoteInvocationReceipt : NSObject
{
    id _returnValue;
    CDUnknownBlockType _completionHandler;
    CDUnknownBlockType _waiterChain;
    struct os_unfair_lock_s _guard;
    unsigned int _valueState:2;
    unsigned int _completionState:2;
    unsigned int _reserved:28;
}

- (void).cxx_destruct;
- (void)_checkedAssign:(CDUnknownBlockType)arg1;
- (void)handleCompletion:(CDUnknownBlockType)arg1;
- (id)init;
- (void)invokeCompletionWithReturnValue:(id)arg1 error:(id)arg2;
- (void)waitForFulfillment;

@end


//
//  CBGesture.m
//  CBXDriver
//
//  Created by Chris Fuentes on 3/17/16.
//  Copyright © 2016 Calabash. All rights reserved.
//

#import "CBGesture.h"

@implementation CBGesture
- (void)_executePrivate:(CompletionBlock)completion {
    _must_override_exception;
}

- (void)execute:(CompletionBlock)completion {
    [self validate];
    [self _executePrivate:completion];
}

- (void)validate {
    _must_override_exception;
}
@end

//
//  CBTap.m
//  CBXDriver
//
//  Created by Chris Fuentes on 3/18/16.
//  Copyright © 2016 Calabash. All rights reserved.
//

#import "CBTap.h"

@implementation CBTap
- (id)init {
    if (self = [super init]) {
        self.name = @"tap";
    }
    return self;
}

- (void)validate {
    
}

- (void)_executePrivate:(CompletionBlock)completion {
//    XCTouchGesture *touch =
    [[Testmanagerd get] _XCT_performTouchGesture:nil completion:completion];
}
@end

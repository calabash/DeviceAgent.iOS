//
//  CBGesture.m
//  CBXDriver
//
//  Created by Chris Fuentes on 3/17/16.
//  Copyright © 2016 Calabash. All rights reserved.
//

#import "CBGesture.h"

@implementation CBGesture
@synthesize warnings;

+ (NSString *)name {
    _must_override_exception;
}

- (NSArray <NSString *> *)requiredKeys {
    _must_override_exception;
}

- (NSArray <NSString *> *)optionalKeys {
    _must_override_exception;
}

+ (CBGesture *)executeWithJSON:(NSDictionary *)json
                    completion:(CompletionBlock)completion {
    CBGesture *gest = [self withJSON:json];
    [gest execute:completion];
    return gest;
}

+ (instancetype)withJSON:(NSDictionary *)json {
    CBGesture *gesture = [self new];
    gesture.warnings = [NSMutableArray array];
    
    id specs = [json mutableCopy];
    [specs removeObjectForKey:@"gesture"];
    
    if (json[@"query"]) {
        [specs removeObjectForKey:@"query"];
        gesture.query = [CBQuery withQueryString:json[@"query"] specifiers:specs];
    } else {
        gesture.query = [CBQuery withSpecifiers:json];
    }
    
    return gesture;
}

- (XCSynthesizedEventRecord *)event {
    _must_override_exception;
}

- (XCTouchGesture *)gesture {
    _must_override_exception;
}

- (void)addWarning:(NSString *)format, ... {
    va_list args;
    va_start(args, format);
    NSString *msg = [NSString stringWithFormat:format, args];
    [self.warnings addObject:[NSString stringWithFormat:@"[WARNING]: %@",  msg]];
    va_end(args);
}

- (void)execute:(CompletionBlock)completion {
    NSArray *delta = [self.query requiredSpecifierDelta:[self requiredKeys]];
    if (delta.count > 0) {
        @throw [CBInvalidArgumentException withFormat:@"[%@] Missing required keys: %@",
                [self.class name],
                delta];
    }
    
    delta = [self.query optionalSpecifierDelta:[self optionalKeys]];
    if (delta.count > 0) {
        for (NSString *key in delta) {
            [self addWarning:@"'%@' is an unsupported key.", key];
        }
    }
    
    [self validate]; //Should be implemented by subclass
    
    if ([[XCTestDriver sharedTestDriver] daemonProtocolVersion] != 0x0) {
        [[Testmanagerd get] _XCT_synthesizeEvent:[self event] completion:^(NSError *e) {
            if (e) @throw [CBException withMessage:@"Error performing gesture"];
        }];
    } else {
        [[Testmanagerd get] _XCT_performTouchGesture:[self gesture] completion:^(NSError *e) {
            if (e) @throw [CBException withMessage:@"Error performing gesture"];
        }];
    }
    completion(nil, self.warnings); //TODO refactor
}

- (void)validate {
    _must_override_exception;
}
@end

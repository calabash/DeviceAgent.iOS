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
    return @[];
}

- (NSArray <NSString *> *)optionalSpecifiers {
    return @[];
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
    
    gesture.query = [CBQuery withSpecifiers:json
                          collectWarningsIn:gesture.warnings];
    
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
    [self.warnings addObject:[[NSString alloc] initWithFormat:format arguments:args]];
    va_end(args);
}

- (void)execute:(CompletionBlock)completion {
    NSArray *delta = [self.query requiredSpecifierDelta:[self requiredKeys]];
    if (delta.count > 0) {
        @throw [CBInvalidArgumentException withFormat:@"[%@] Missing required keys: %@",
                [self.class name],
                [JSONUtils objToJSONString:delta]];
    }
    
    delta = [self.query optionalKeyDelta:[self optionalSpecifiers]];
    if (delta.count > 0) {
        for (NSString *key in delta) {
            [self addWarning:@"'%@' is not a supported option for %@.", key, [self.class name]];
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

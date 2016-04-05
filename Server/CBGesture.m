//
//  CBGesture.m
//  CBXDriver
//
//  Created by Chris Fuentes on 3/17/16.
//  Copyright © 2016 Calabash. All rights reserved.
//

#import "CBGesture.h"

@implementation CBGesture

+ (NSString *)name {
    _must_override_exception;
}

- (NSArray <NSString *> *)requiredOptions {
    _must_override_exception;
}

- (NSArray <NSString *> *)requiredSpecifiers {
    _must_override_exception;
}

- (NSArray <NSString *> *)optionalOptions {
    return @[];
}

- (NSArray <NSString *> *)optionalSpecifiers {
    return @[];
}

+ (NSArray <NSString *> *)defaultOptionalSpecifiers {
    return @[CB_IDENTIFIER_KEY,
             CB_TEXT_KEY,
             CB_TEXT_LIKE_KEY,
             CB_PROPERTY_KEY,
             CB_PROPERTY_LIKE_KEY,
             CB_INDEX_KEY];
}

+ (CBGesture *)executeWithJSON:(NSDictionary *)json
                    completion:(CompletionBlock)completion {
    CBGesture *gest = [self withJSON:json];
    [gest execute:completion];
    return gest;
}

+ (instancetype)withJSON:(NSDictionary *)json {
    CBGesture *gesture = [self new];
    
    id specs = [json mutableCopy];
    [specs removeObjectForKey:@"gesture"];
    
    QueryConfiguration *queryConfig = [QueryConfiguration withJSON:specs
                                                requiredSpecifiers:[gesture requiredSpecifiers]
                                                optionalSpecifiers:[gesture optionalSpecifiers]];
    gesture.query = [CBQuery withQueryConfiguration:queryConfig];
    
    return gesture;
}

- (XCSynthesizedEventRecord *)eventWithElements:(NSArray<XCUIElement *> *)elements {
    _must_override_exception;
}

- (XCTouchGesture *)gestureWithElements:(NSArray<XCUIElement *> *)elements {
    _must_override_exception;
}


- (void)execute:(CompletionBlock)completion {
    [self validate]; //Should be implemented by subclass
    
    NSArray <XCUIElement *> *elements = [self.query execute];
    if (elements.count == 0) {
        @throw [CBException withMessage:@"Error performing gesture: No elements match query."];
    }
    
    //Testmanagerd calls are async, but the http server is sync so we need to synchronize it.
    __block BOOL done = NO;
    __block NSError *err;
    
    if ([[XCTestDriver sharedTestDriver] daemonProtocolVersion] != 0x0) {
        [[Testmanagerd get] _XCT_synthesizeEvent:[self eventWithElements:elements]
                                      completion:^(NSError *e) {
            done = YES;
            err = e;
        }];
    } else {
        [[Testmanagerd get] _XCT_performTouchGesture:[self gestureWithElements:elements]
                                          completion:^(NSError *e) {
            done = YES;
            err = e;
        }];
    }

    while(!done){
        //TODO: fine-tune this. 
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    }
    if (err) @throw [CBException withMessage:@"Error performing gesture"];
    completion(err);
}

- (void)validate {
    BOOL contains = NO;
    NSArray *specifiers = [self optionalSpecifiers];
    for (NSString *key in specifiers) {
        if (self.query[key]) {
            contains = YES;
            break;
        }
    }
    if (!contains) {
        @throw [CBInvalidArgumentException withFormat:
                @"[%@] Requires at least one of the following specifiers: %@",
                self.class.name,
                [JSONUtils objToJSONString:specifiers]];
    }
}
@end

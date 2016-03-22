//
//  QuerySelector.h
//  CBXDriver
//
//  Created by Chris Fuentes on 3/22/16.
//  Copyright © 2016 Calabash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XCUIElementQuery.h"
#import "XCUIElement.h"
#import "CBException.h"
#import "CBMacros.h"

@protocol QuerySelector <NSObject>
+ (NSString *)name;
- (XCUIElementQuery *)applyInternal:(XCUIElementQuery *)query;
+ (instancetype)withValue:(id)value;
@end

@interface QuerySelector : NSObject<QuerySelector>
- (XCUIElementQuery *)applyToQuery:(XCUIElementQuery *)query;
@property (nonatomic, strong) id value;
@end

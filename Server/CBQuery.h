//
//  CBElementQuery.h
//  CBXDriver
//
//  Created by Chris Fuentes on 3/18/16.
//  Copyright © 2016 Calabash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuerySelector.h"
#import "CBConstants.h"
#import "XCUIElement.h"

@interface CBQuery : NSObject
@property (nonatomic, strong) NSArray <QuerySelector *> *selectors;
@property (nonatomic, strong) NSDictionary *specifiers;

/*
    Coordinate based queries
 */
- (NSDictionary *)coordinate;  //e.g. for tap_coordinate
- (NSArray <NSDictionary *> *)coordinates; //e.g., for drag_coordinates

/*
    General queries
 */
+ (CBQuery *)withSpecifiers:(NSDictionary *)specifiers
          collectWarningsIn:(NSMutableArray <NSString *> *)warnings;

- (NSArray <XCUIElement *> *)execute;

- (NSString *)toJSONString;

/*
    Delta between what is required and what is provided
 */
- (NSArray <NSString *> *)requiredSpecifierDelta:(NSArray <NSString *> *)required;

/*
    Delta between what options are provided and which are supported.
    E.g. 'speed' might supported for 'flick' but not 'tap'
 */
- (NSArray <NSString *> *)optionalKeyDelta:(NSArray <NSString *> *)optional;
@end

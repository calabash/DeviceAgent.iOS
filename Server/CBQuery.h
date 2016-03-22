//
//  CBElementQuery.h
//  CBXDriver
//
//  Created by Chris Fuentes on 3/18/16.
//  Copyright © 2016 Calabash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CBConstants.h"
#import "XCUIElement.h"

@interface CBQuery : NSObject
@property (nonatomic, strong) NSDictionary *specifiers;
@property (nonatomic, strong) CBQuery *subQuery; //child, parent

- (NSDictionary *)coordinate;  //e.g. for tap_coordinate
- (NSArray <NSDictionary *> *)coordinates; //e.g., for drag_coordinates
+ (CBQuery *)withSpecifiers:(NSDictionary *)specifiers;
+ (CBQuery *)withQueryString:(NSString *)queryString specifiers:(NSDictionary *)specifiers;

- (XCUIElement *)execute;

- (NSDictionary *)toDict;
@end

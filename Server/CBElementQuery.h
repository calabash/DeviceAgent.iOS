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

@interface CBElementQuery : NSObject
@property (nonatomic, strong) NSDictionary *specifiers;
@property (nonatomic, strong) CBElementQuery *subQuery; //child, parent

- (NSDictionary *)coordinate;  //e.g. for tap_coordinate
- (NSArray<NSDictionary *> *)coordinates; //e.g., for drag_coordinates
+ (CBElementQuery *)withSpecifiers:(NSDictionary *)specifiers;
+ (CBElementQuery *)withQueryString:(NSString *)queryString specifiers:(NSDictionary *)specifiers;

- (XCUIElement *)execute;

- (NSDictionary *)toDict;
@end

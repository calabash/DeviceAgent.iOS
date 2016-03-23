//
//  QuerySelectorProperty.h
//  CBXDriver
//
//  Created by Chris Fuentes on 3/23/16.
//  Copyright © 2016 Calabash. All rights reserved.
//

#import "QuerySelector.h"
#import "JSONUtils.h"

@interface QuerySelectorProperty : QuerySelector<QuerySelector>
+ (NSDictionary <NSString *, id> *)parseValue:(id)value; // @{ @"key" : string, @"value" : id }
@end

//
//  QuerySelectorFactory.h
//  CBXDriver
//
//  Created by Chris Fuentes on 3/22/16.
//  Copyright © 2016 Calabash. All rights reserved.
//

#import "QuerySelector.h"
#import "QuerySelector.h"
@interface QuerySelectorFactory : QuerySelector
+ (QuerySelector *)selectorWithKey:(NSString *)key value:(id)val;
@end

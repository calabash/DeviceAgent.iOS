//
//  CBApplication+Queries.h
//  xcuitest-server
//
//  Created by Chris Fuentes on 2/3/16.
//  Copyright © 2016 calabash. All rights reserved.
//

#import "CBApplication.h"

@interface CBApplication (Queries)
+ (NSDictionary *)tree;
+ (NSArray *)elementsMarked:(NSString *)text;
+ (NSArray *)elementsWithID:(NSString *)identifier;
@end

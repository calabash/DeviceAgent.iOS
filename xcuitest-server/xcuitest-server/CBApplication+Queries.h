//
//  CBApplication+Queries.h
//  xcuitest-server
//

#import "CBApplication.h"

@interface CBApplication (Queries)
+ (NSDictionary *)tree;
+ (NSArray *)elementsMarked:(NSString *)text;
+ (NSArray *)elementsWithID:(NSString *)identifier;
@end

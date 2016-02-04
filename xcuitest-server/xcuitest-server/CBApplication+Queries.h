//
//  CBApplication+Queries.h
//  xcuitest-server
//

#import "CBApplication.h"

@interface CBApplication (Queries)
+ (NSDictionary *)tree;
+ (NSArray *)jsonForElementsMarked:(NSString *)text;
+ (NSArray *)jsonForElementsWithID:(NSString *)identifier;
@end

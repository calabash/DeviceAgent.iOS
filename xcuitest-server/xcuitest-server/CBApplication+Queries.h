//
//  CBApplication+Queries.h
//  xcuitest-server
//

#import "CBApplication.h"

@interface CBApplication (Queries)
+ (NSDictionary *)tree;

+ (NSArray <NSDictionary *> *)jsonForElementsMarked:(NSString *)text;
+ (NSArray <NSDictionary *> *)jsonForElementsWithID:(NSString *)identifier;

+ (NSArray <XCUIElement *> *)elementsMarked:(NSString *)text;
+ (NSArray <XCUIElement *> *)elementsWithIdentifier:(NSString *)identifier;
@end

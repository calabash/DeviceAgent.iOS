//
//  CBApplication+Queries.h
//  xcuitest-server
//

#import "CBApplication.h"

@interface CBApplication (Queries)
+ (NSDictionary *)tree;

+ (NSArray <NSDictionary *> *)jsonForElementsMarked:(NSString *)text;
+ (NSArray <NSDictionary *> *)jsonForElementsWithID:(NSString *)identifier;

+ (XCUIElement *)elementMarked:(NSString *)mark;
+ (NSArray <XCUIElement *> *)elementsMarked:(NSString *)text;

+ (XCUIElement *)elementWithIdentifier:(NSString *)identifier;
+ (NSArray <XCUIElement *> *)elementsWithIdentifier:(NSString *)identifier;
@end

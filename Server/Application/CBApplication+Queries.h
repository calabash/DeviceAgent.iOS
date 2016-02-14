//
//  CBApplication+Queries.h
//  xcuitest-server
//

#import "CBApplication.h"
#import "XCElementSnapshot.h"

@interface CBApplication (Queries)
+ (NSDictionary *)tree;

+ (NSArray <NSDictionary *> *)jsonForElementsMarked:(NSString *)text;
+ (NSArray <NSDictionary *> *)jsonForElementsWithID:(NSString *)identifier;
+ (NSArray <NSDictionary *> *)jsonForElementsWithType:(NSString *)type;

+ (XCUIElement *)elementMarked:(NSString *)mark;
+ (NSArray <XCUIElement *> *)elementsMarked:(NSString *)text;

+ (XCUIElement *)elementWithIdentifier:(NSString *)identifier;
+ (NSArray <XCUIElement *> *)elementsWithIdentifier:(NSString *)identifier;

+ (XCElementSnapshot *)elementAtCoordinates:(float)x :(float)y;

@end

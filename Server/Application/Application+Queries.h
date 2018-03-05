
#import "Application.h"

@class XCUIElement;
@class XCElementSnapshot;

@interface Application (Queries)
+ (NSDictionary *)tree;

+ (NSArray <NSDictionary *> *)jsonForElementsWithID:(NSString *)identifier;
+ (NSArray <NSDictionary *> *)jsonForElementsWithType:(NSString *)type;

+ (XCUIElement *)elementWithIdentifier:(NSString *)identifier;
+ (NSArray <XCUIElement *> *)elementsWithIdentifier:(NSString *)identifier;

+ (XCElementSnapshot *)elementAtCoordinates:(float)x :(float)y;

@end

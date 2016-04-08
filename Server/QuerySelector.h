
#import "InvalidArgumentException.h"
#import <Foundation/Foundation.h>
#import "XCUIElementQuery.h"
#import "XCUIElement.h"
#import "CBMacros.h"

typedef NS_ENUM(int, QuerySelectorExecutionPriority) {
    kQuerySelectorExecutionPriorityAny = 0,
    kQuerySelectorExecutionPrioritySooner = -1,
    kQuerySelectorExecutionPriorityFirst = INT_MIN,
    kQuerySelectorExecutionPriorityLater = 1,
    kQuerySelectorExecutionPriorityLast = INT_MAX
};

@protocol QuerySelector <NSObject>
+ (NSString *)name;
- (XCUIElementQuery *)applyInternal:(XCUIElementQuery *)query;
+ (instancetype)withValue:(id)value;
@end

@interface QuerySelector : NSObject<QuerySelector>
- (XCUIElementQuery *)applyToQuery:(XCUIElementQuery *)query;
@property (nonatomic, strong) id value;
+ (QuerySelectorExecutionPriority)executionPriority;
@end

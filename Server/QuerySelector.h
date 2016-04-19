
#import "InvalidArgumentException.h"
#import <Foundation/Foundation.h>
#import "XCUIElementQuery.h"
#import "XCUIElement.h"
#import "CBXMacros.h"

/**
    An enum describing the relative execution priority of a selector.
    Higher-valued selectors are executed later.
 */
typedef NS_ENUM(int, QuerySelectorExecutionPriority) {
    /** Execution order doesn't matter */
    kQuerySelectorExecutionPriorityAny = 0,
    /** Slight preference for sooner but not crucial */
    kQuerySelectorExecutionPrioritySooner = -1,
    /** Must be executed first.
     @warning Onus is put on the programmer to not use this on multiple classes
     */
    kQuerySelectorExecutionPriorityFirst = INT_MIN,
    /** Slight preference for later but not crucial */
    kQuerySelectorExecutionPriorityLater = 1,
    /** Must be executed last.
     @warning Onus is put on the programmer to not use this on multiple classes
     */
    kQuerySelectorExecutionPriorityLast = INT_MAX
};

/**
 Protocol to which all all QuerySelectors must conform.
 Doing so allows them to be easily picked up at runtime
 and automatically added to the QuerySelectorFactor.
 */

@protocol QuerySelector <NSObject>

/**
 Returns the name of the selector. This is used in the API as the 'key', e.g.
 for `{ "id" : "foo" }`, the selector's name would be `"id"`. 
 
 @return Selector's name
 */
+ (NSString *)name;

/**
 Actual query-builder logic. This is overridden by subclasses to encapsulate the different
 XCUITest APIs for building a query. 
 
 @param query an input query
 @return the input query further constrained by the current selector.
 */
- (XCUIElementQuery *)applyInternal:(XCUIElementQuery *)query;

/**
 Convenience constructor
 
 @param value The value that this selector is matching on.
 @return A new QuerySelector with the provided value.
 */
+ (instancetype)withValue:(id)value;
@end

/**
 QuerySelectors encapsulate individual query components which serve to constrain 
 a more general query. 
 
 For example, if you query `{ "key1" : "foo", "key2" : "bar" }`, evaluation is processed
 as follows:
 
 1. Start with a generic 'all' query that matches every element in the application. 
 2. Constrain this query by those elements where 'key1' matches 'foo'.
 3. Further constrain this query by elements where 'key2' matches 'bar.
 
 The end result is an AND-ed query that matches key1 to "foo" and key2 to "bar".
 
 Note that the definition of "match" is dependent on the selectors' implementation of
 applyInternal: above.
 */

@interface QuerySelector : NSObject<QuerySelector>
/** 
 Wrapper method for applying a selector to an input query. 
 
 If the input query is `nil`, it will be converted to an `all` query and then passed to 
 `applyInternal` for class-specific matching logic.
 
 @param query Input query or nil
 @return The input query further constrained by the current selector.
 */
- (XCUIElementQuery *)applyToQuery:(XCUIElementQuery *)query;

/** 
 The value against which this selector will match.
 */
@property (nonatomic, strong) id value;

/**
    The class's execution priority. Will be the same for all instances of the class.
    @return Class's execution priority
 */
+ (QuerySelectorExecutionPriority)executionPriority;
@end
